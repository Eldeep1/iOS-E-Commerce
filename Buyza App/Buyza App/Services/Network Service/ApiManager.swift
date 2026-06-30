//
//  ApiManager.swift
//  Buyza App
//
//  Created by Ahmad Fathy on 27/06/2026.
//

import Foundation


final class ApiManager{
    
    typealias NetworkResponse = (data:Data,response:URLResponse)
    
    static let shared = ApiManager()
    
    private let baseUrl = "https://mad46-ios-team10.myshopify.com"
    private let session = URLSession.shared
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    
    func sendRequest<Response: Decodable>(
        from endpoint: ApiEndpoint
    ) async throws -> Response {
        try await sendRequest(from: endpoint, with: Optional<EmptyBody>.none)
    }

    func sendRequest<Response: Decodable, Body: Encodable>(
        from endpoint: ApiEndpoint,
        with body: Body? = nil
    ) async throws -> Response {

        var request = try createRequest(from: endpoint)

        if let body {
            request.httpBody = try encoder.encode(body)
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.decoding
        }

        
        return try decoder.decode(Response.self, from: data)
    }

       
    
    
    func createRequest(from endpoint:ApiEndpoint) throws -> URLRequest{
        guard var urlComponents = URLComponents(string: baseUrl.appending(endpoint.path))
        else{
            throw ApiError.invalidPath
        }

        if let parameters = endpoint.parameters{
            urlComponents.queryItems = parameters
        }

        guard let url = urlComponents.url else {
            throw ApiError.invalidPath
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        endpoint.allHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}

private struct EmptyBody: Encodable {}
