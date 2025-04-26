//
//  GraphQLNetworking.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

import Foundation

// Structure to represent a GraphQL request
struct GraphQLRequest: Encodable {
    let query: String
    let variables: [String: Any]
    
    // Custom encoding for variables (which is a dictionary with Any values)
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(query, forKey: .query)
        
        // Convert variables dictionary to JSON data
        let variablesData = try JSONSerialization.data(withJSONObject: variables)
        let variablesDict = try JSONSerialization.jsonObject(with: variablesData)
        try container.encode(variablesDict, forKey: .variables)
    }
    
    enum CodingKeys: String, CodingKey {
        case query
        case variables
    }
}

// Extension to our network repository for GraphQL functionality
extension NetworkRepository {
    func sendGraphQLRequest<T: Decodable>(query: String, variables: [String: Any]) async throws -> T {
        let request = GraphQLRequest(query: query, variables: variables)
        let url = URL(string: "https://graphql.anilist.co")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
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
