//
//  ProductsEndpoints.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import Foundation

enum ProductsEndpoints {
    static let products = ApiEndpoint(
        path: "/admin/api/2025-10/products.json",
        method: .GET
    )

    static let graphQL = ApiEndpoint(
        path: "/admin/api/2025-10/graphql.json",
        method: .POST
    )
}
