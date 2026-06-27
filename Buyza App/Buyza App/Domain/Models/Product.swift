//
//  Product.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import Foundation

struct ProductsResponse: Codable {
    let products: [Product]
}

struct Product: Codable {
    let id: Int
    let title: String
}

struct ProductsGraphQLData: Decodable {
    let products: ProductsConnection
}

struct ProductsConnection: Decodable {
    let edges: [ProductEdge]
}

struct ProductEdge: Decodable {
    let node: GraphQLProduct
}

struct GraphQLProduct: Decodable {
    let id: String
    let title: String
}
