//
//  GraphQLRequest.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import Foundation

/// GraphQL body for queries without variables.
struct GraphQLQuery: Encodable {
    let query: String
}

/// GraphQL body for queries with typed variables.
struct GraphQLRequest<V: Encodable>: Encodable {
    let query: String
    let variables: V

    init(query: String, variables: V) {
        self.query = query
        self.variables = variables
    }
}
