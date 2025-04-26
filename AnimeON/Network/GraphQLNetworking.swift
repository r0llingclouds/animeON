//
//  GraphQLNetworking.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

import Foundation

// Structure to represent a GraphQL request
struct GraphQLRequest {
    let query: String
    let variables: [String: Any]
}

// Extension to our network repository for GraphQL functionality
extension NetworkRepository {
    func sendGraphQLRequest<T: Decodable>(query: String, variables: [String: Any]) async throws -> T {
        let url = URL(string: "https://graphql.anilist.co")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create a dictionary and then convert to data
        let requestDict: [String: Any] = [
            "query": query,
            "variables": variables
        ]
        
        // Convert dictionary to JSON data
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestDict)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        // For debugging
        if let jsonString = String(data: data, encoding: .utf8) {
            print("API Response: \(jsonString)")
        }
        
        return try decoder.decode(T.self, from: data)
    }
}

// Error handling for network operations
enum NetworkError: Error {
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError
    case encodingError
}
