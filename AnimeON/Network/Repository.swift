//
//  Repository.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//


import Foundation
import SMP25Kit

// Keep the existing Repository structure but update it for Anilist
struct Repository: NetworkRepository {
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

// Update the protocol for anime operations
protocol NetworkRepository: NetworkInteractor, Sendable {
    func getPopularAnime() async throws(NetworkError) -> [AnimeDTO]
    func searchAnime(title: String) async throws(NetworkError) -> AnimeDTO?
}

// Implementation for Anilist API
extension NetworkRepository {
    func getPopularAnime() async throws(NetworkError) -> [AnimeDTO] {
        let query = """
        query {
          Page(page: 1, perPage: 20) {
            media(sort: POPULARITY_DESC, type: ANIME) {
              id
              title {
                english
                romaji
                native
              }
              coverImage {
                large
                medium
              }
              description
              episodes
              averageScore
              genres
            }
          }
        }
        """
        
        let response = try await sendGraphQLRequest(query: query, variables: [:]) as AnimeResponse
        
        guard let media = response.data.Page?.media else {
            return []
        }
        
        return media
    }
    
    func searchAnime(title: String) async throws(NetworkError) -> AnimeDTO? {
        let query = """
        query ($title: String) {
          Media(search: $title, type: ANIME) {
            id
            title {
              english
              romaji
              native
            }
            coverImage {
              large
              medium
            }
            description
            episodes
            averageScore
            genres
          }
        }
        """
        
        let variables: [String: Any] = ["title": title]
        
        let response = try await sendGraphQLRequest(query: query, variables: variables) as AnimeResponse
        
        return response.data.Media
    }
}
