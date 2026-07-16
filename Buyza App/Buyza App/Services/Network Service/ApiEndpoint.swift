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
    
    static var shopifyAccessToken: String {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "ShopifyStorefrontToken") as? String else {
            return ""
        }
        return token
    }
    
    static var defaultHeaders: [String: String] {
        [
            "X-Shopify-Storefront-Access-Token": shopifyAccessToken,
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
        guard let headers else { return Self.defaultHeaders }
        if headers.keys.contains("X-Shopify-Access-Token") {
            return headers
        }
        var merged = Self.defaultHeaders
        headers.forEach { merged[$0.key] = $0.value }
        return merged
    }
}

// MARK: - Admin API Support

extension ApiEndpoint {
    
    static var shopifyAdminAccessToken: String {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "ShopifyAdminAccessToken") as? String else {
            return ""
        }
        return token
    }
    
    static var adminHeaders: [String: String] {
        [
            "X-Shopify-Access-Token": shopifyAdminAccessToken,
            "Content-Type": "application/json"
        ]
    }
}

// MARK: - Home Endpoints

extension ApiEndpoint {
    
    private static let adminApiVersion = "2026-01"
    
    static func products(limit: Int = 8) -> ApiEndpoint {
        ApiEndpoint(
            path: "/admin/api/\(adminApiVersion)/products.json",
            method: .GET,
            parameters: [URLQueryItem(name: "limit", value: "\(limit)")],
            headers: adminHeaders
        )
    }
    
    static func categories() -> ApiEndpoint {
        ApiEndpoint(
            path: "/admin/api/\(adminApiVersion)/custom_collections.json",
            method: .GET,
            headers: adminHeaders
        )
    }
    
    static func brands() -> ApiEndpoint {
        ApiEndpoint(
            path: "/admin/api/\(adminApiVersion)/smart_collections.json",
            method: .GET,
            headers: adminHeaders
        )
    }

    static func collectionProducts(collectionId: Int, limit: Int = 50) -> ApiEndpoint {
        filteredProducts(
            criteria: ProductFilterCriteria(),
            collectionId: collectionId,
            limit: limit
        )
    }

    static func productsByVendor(vendor: String, limit: Int = 50) -> ApiEndpoint {
        filteredProducts(
            criteria: ProductFilterCriteria(vendor: vendor),
            limit: limit
        )
    }

    static func filteredProducts(
        criteria: ProductFilterCriteria,
        collectionId: Int? = nil,
        limit: Int = 50
    ) -> ApiEndpoint {
        var parameters: [URLQueryItem] = [
            URLQueryItem(name: "limit", value: "\(limit)")
        ]

        if let collectionId {
            parameters.append(URLQueryItem(name: "collection_id", value: "\(collectionId)"))
        }

        if let vendor = criteria.vendor, !vendor.isEmpty {
            parameters.append(URLQueryItem(name: "vendor", value: vendor))
        }

        if let productType = criteria.productType, !productType.isEmpty {
            parameters.append(URLQueryItem(name: "product_type", value: productType))
        }

        if let publishedStatus = criteria.publishedStatus.apiValue {
            parameters.append(URLQueryItem(name: "published_status", value: publishedStatus))
        }

        if let status = criteria.status {
            parameters.append(URLQueryItem(name: "status", value: status.rawValue))
        }

        return ApiEndpoint(
            path: "/admin/api/\(adminApiVersion)/products.json",
            method: .GET,
            parameters: parameters,
            headers: adminHeaders
        )
    }
}
