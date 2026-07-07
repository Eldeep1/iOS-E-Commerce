//
//  PaymobService.swift
//  Buyza App
//
//  Created by depo on 06/07/2026.
//

import Foundation

class PaymobService {
    static let shared = PaymobService()
    
    private var apiKey: String {
        Bundle.main.infoDictionary?["PAYMOB_API_KEY"] as? String ?? "YOUR_PAYMOB_API_KEY"
    }
    private let integrationID = 5769699
    private let iframeID = "1058544"
    
    private init() {}
    
   
    private func fetchConversionRate() async -> Double {
        guard let url = URL(string: "https://api.exchangerate-api.com/v4/latest/USD") else { return 48.0 }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let rates = json["rates"] as? [String: Any],
               let egpRate = rates["EGP"] as? Double {
                return egpRate
            }
        } catch {
            print("Failed to fetch live exchange rate: \(error)")
        }
        return 48.0
    }

    func generatePaymentURL(amount: Double, address: Address, customerEmail: String = "customer@buyza.com") async throws -> URL {
        
        let authToken = try await authenticate()
        
        
        let exchangeRate = await fetchConversionRate()
        let amountInEGP = amount * exchangeRate
        let amountInCents = Int(amountInEGP * 100)
        
        let orderID = try await registerOrder(authToken: authToken, amountInCents: amountInCents)
        
        
        let paymentKey = try await requestPaymentKey(
            authToken: authToken,
            orderID: orderID,
            amountInCents: amountInCents,
            address: address,
            email: customerEmail
        )
        
        
        guard let url = URL(string: "https://accept.paymob.com/api/acceptance/iframes/\(iframeID)?payment_token=\(paymentKey)") else {
            throw NSError(domain: "PaymobError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid iFrame URL"])
        }
        return url
    }
    
    private func authenticate() async throws -> String {
        let url = URL(string: "https://accept.paymob.com/api/auth/tokens")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: ["api_key": apiKey])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 && httpResponse.statusCode != 201 {
            throw NSError(domain: "PaymobError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to authenticate with Paymob. Check API Key."])
        }
        
        let json = try JSONDecoder().decode(AuthResponse.self, from: data)
        return json.token
    }
    
    private func registerOrder(authToken: String, amountInCents: Int) async throws -> Int {
        let url = URL(string: "https://accept.paymob.com/api/ecommerce/orders")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "auth_token": authToken,
            "delivery_needed": false,
            "amount_cents": String(amountInCents),
            "currency": "EGP",
            "items": []
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 && httpResponse.statusCode != 201 {
            throw NSError(domain: "PaymobError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to register Paymob order."])
        }
        
        let json = try JSONDecoder().decode(OrderResponse.self, from: data)
        return json.id
    }
    
    private func requestPaymentKey(authToken: String, orderID: Int, amountInCents: Int, address: Address, email: String) async throws -> String {
        let url = URL(string: "https://accept.paymob.com/api/acceptance/payment_keys")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let firstName = address.firstName.isEmpty ? "Customer" : address.firstName
        let lastName = address.lastName.isEmpty ? "Buyza" : address.lastName
        
        let billingData: [String: String] = [
            "apartment": "NA",
            "email": email,
            "floor": "NA",
            "first_name": firstName,
            "street": address.streetAddress.isEmpty ? "NA" : address.streetAddress,
            "building": "NA",
            "phone_number": address.phoneNumber.isEmpty ? "01000000000" : address.phoneNumber,
            "shipping_method": "PKG",
            "postal_code": address.zip.isEmpty ? "NA" : address.zip,
            "city": address.city.isEmpty ? "NA" : address.city,
            "country": address.country.isEmpty ? "EG" : address.country,
            "last_name": lastName,
            "state": address.province.isEmpty ? "NA" : address.province
        ]
        
        let body: [String: Any] = [
            "auth_token": authToken,
            "amount_cents": String(amountInCents),
            "expiration": 3600,
            "order_id": String(orderID),
            "billing_data": billingData,
            "currency": "EGP",
            "integration_id": integrationID,
            "return_url": "https://buyza.com/callback"
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 && httpResponse.statusCode != 201 {
            throw NSError(domain: "PaymobError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to request Paymob payment key."])
        }
        
        let json = try JSONDecoder().decode(PaymentKeyResponse.self, from: data)
        return json.token
    }
    
    // MARK: - Models
    private struct AuthResponse: Decodable { let token: String }
    private struct OrderResponse: Decodable { let id: Int }
    private struct PaymentKeyResponse: Decodable { let token: String }
}
