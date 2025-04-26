//
//  Repository.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//


import Foundation
import SMP25Kit

struct Repository: NetworkRepository {
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }
}

protocol NetworkRepository: NetworkInteractor, Sendable {
    func getGenres() async throws(NetworkError) -> [GenresDTO]
    func getNowPlaying() async throws(NetworkError) -> [MovieDTO]
    func getUpcoming() async throws(NetworkError) -> [MovieDTO]
}

extension NetworkRepository {    
    func getGenres() async throws(NetworkError) -> [GenresDTO] {
        try await getJSON(.get(url: .genres, token: APIKey), type: GenresResponseDTO.self).genres
    }
    
    func getNowPlaying() async throws(NetworkError) -> [MovieDTO] {
        try await getJSON(.get(url: .nowPlaying, token: APIKey), type: Results.self).results
    }
    
    func getUpcoming() async throws(NetworkError) -> [MovieDTO] {
        try await getJSON(.get(url: .upcoming, token: APIKey), type: Results.self).results
    }
}
