//
//  PayPalService.swift
//  Buyza App
//
//  Created by depo on 06/07/2026.
//

import Foundation

class PayPalService {
    static let shared = PayPalService()
    
    
    private let clientID = Bundle.main.infoDictionary?["PAYPAL_CLIENT_ID"] as? String ?? "SAD"
    private let secret = Bundle.main.infoDictionary?["PAYPAL_SECRET"] as? String ?? "SAD AGAIN"
    
    private let baseURL = "https://api-m.sandbox.paypal.com"
    
    private init() {}
    
    
    private func authenticate() async throws -> String {
        let url = URL(string: "\(baseURL)/v1/oauth2/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let loginString = "\(clientID):\(secret)"
        guard let loginData = loginString.data(using: .utf8) else {
            throw NSError(domain: "PayPalError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to encode credentials"])
        }
        let base64LoginString = loginData.base64EncodedString()
        
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: .utf8)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "PayPalError", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: "Failed to authenticate with PayPal"])
        }
        
        let json = try JSONDecoder().decode(AuthResponse.self, from: data)
        return json.access_token
    }
    
   
    func createOrder(amountInUSD: Double) async throws -> URL {
        let accessToken = try await authenticate()
        
        let formattedAmount = String(format: "%.2f", amountInUSD)
        
        let url = URL(string: "\(baseURL)/v2/checkout/orders")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "intent": "CAPTURE",
            "purchase_units": [
                [
                    "amount": [
                        "currency_code": "USD",
                        "value": formattedAmount
                    ]
                ]
            ],
            "application_context": [
                "return_url": "https://buyza.com/callback?success=true",
                "cancel_url": "https://buyza.com/callback?success=false"
            ]
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            throw NSError(domain: "PayPalError", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: "Failed to create PayPal order"])
        }
        
        let json = try JSONDecoder().decode(OrderResponse.self, from: data)
        
        guard let approveLink = json.links.first(where: { $0.rel == "approve" })?.href,
              let approveURL = URL(string: approveLink) else {
            throw NSError(domain: "PayPalError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Approve link missing from PayPal response"])
        }
        
        return approveURL
    }
    
    
    func captureOrder(orderID: String) async throws {
        let accessToken = try await authenticate()
        
        let url = URL(string: "\(baseURL)/v2/checkout/orders/\(orderID)/capture")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            let errorMsg = String(data: data, encoding: .utf8) ?? "Failed to capture PayPal order"
            print("PayPal Capture Error: \(errorMsg)")
            throw NSError(domain: "PayPalError", code: (response as? HTTPURLResponse)?.statusCode ?? 500, userInfo: [NSLocalizedDescriptionKey: "Failed to capture PayPal order"])
        }
    }
    
    // MARK: - Models
    private struct AuthResponse: Decodable {
        let access_token: String
    }
    
    private struct OrderResponse: Decodable {
        let id: String
        let links: [Link]
    }
    
    private struct Link: Decodable {
        let href: String
        let rel: String
        let method: String
    }
}
