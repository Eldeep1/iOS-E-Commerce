//
//  ApiEndpoint.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//
import Foundation

struct ApiEndpoint {

    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
    }

    static let shopifyAccessToken = ""

    static var defaultHeaders: [String: String] {
        [
            "X-Shopify-Access-Token": shopifyAccessToken,
            "Content-Type": "application/json"
        ]
    }

    let path: String
    let method: Method
    let parameters: [URLQueryItem]?
    let headers: [String: String]?

    init(
        path: String,
        method: Method,
        parameters: [URLQueryItem]? = nil,
        headers: [String: String]? = nil
    ) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.headers = headers
    }

    var allHeaders: [String: String] {
        var merged = Self.defaultHeaders
        headers?.forEach { merged[$0.key] = $0.value }
        return merged
    }
}
