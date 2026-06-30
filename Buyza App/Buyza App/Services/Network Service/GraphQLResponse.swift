//
//  GraphQLResponse.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import Foundation

struct GraphQLResponse<D: Decodable>: Decodable {
    let data: D?
    let errors: [GraphQLErrorResponse]?
}

struct GraphQLErrorResponse: Decodable {
    let message: String
}

extension GraphQLResponse {
    var firstError: GraphQLErrorResponse? {
        errors?.first
    }
}
