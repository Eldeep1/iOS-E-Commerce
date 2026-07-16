//
//  ContentView.swift
//  Buyza App
//
//  Created by Ahmed Tarek on 27/06/2026.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        Text("Testing...")
            .task {
                do {
                    let response: ProductsResponse = try await ApiManager.shared.sendRequest(from: ProductsEndpoints.products)

                    print("REST:", response.products)

                    if let first = response.products.first {
                        print(first.id)
                        print(first.title)
                    }
                } catch {
                    print("REST error:", error)
                }

                do {
                    let response: GraphQLResponse<ProductsGraphQLData> = try await ApiManager.shared.sendRequest(
                        from: ProductsEndpoints.graphQL,
                        with: GraphQLQuery(query: """
                            {
                              products(first: 10) {
                                edges {
                                  node {
                                    id
                                    title
                                  }
                                }
                              }
                            }
                            """)
                    )

                    if let error = response.firstError {
                        print("GraphQL error:", error.message)
                        return
                    }

                    let products = response.data.products.edges.map(\.node)
                    print("GraphQL:", products)

                    if let first = products.first {
                        print(first.id)
                        print(first.title)
                    }
                } catch {
                    print("GraphQL error:", error)
                }
            }
    }
}



#Preview {
    ContentView()
}
