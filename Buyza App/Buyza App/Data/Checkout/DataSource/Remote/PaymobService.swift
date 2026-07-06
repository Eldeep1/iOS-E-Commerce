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
    private let integrationID = 2297861
    private let iframeID = "409009"
    
    private init() {}
    
    func generatePaymentURL(amount: Double, address: Address, customerEmail: String = "customer@buyza.com") async throws -> URL {
        // 1. Authentication Request
        let authToken = try await authenticate()
        
        // 2. Order Registration
        let exchangeRate: Double = 48.0
        let amountInEGP = amount * exchangeRate
        let amountInCents = Int(amountInEGP * 100)
        
        let orderID = try await registerOrder(authToken: authToken, amountInCents: amountInCents)
        
        // 3. Payment Key Request
        let paymentKey = try await requestPaymentKey(
            authToken: authToken,
            orderID: orderID,
            amountInCents: amountInCents,
            address: address,
            email: customerEmail
        )
        
        // 4. Build iFrame URL
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
        
        let nameParts = address.fullName.split(separator: " ", maxSplits: 1)
        let firstName = nameParts.first.map(String.init) ?? "Customer"
        let lastName = nameParts.count > 1 ? String(nameParts[1]) : "Buyza"
        
        let billingData: [String: String] = [
            "apartment": "12",
            "email": email,
            "floor": "3",
            "first_name": firstName,
            "street": "El Tahrir Street",
            "building": "15",
            "phone_number": "01022222222",
            "shipping_method": "PKG",
            "postal_code": "11511",
            "city": "Cairo",
            "country": "EG",
            "last_name": lastName,
            "state": "Cairo"
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
