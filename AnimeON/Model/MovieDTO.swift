//
//  MovieDTO.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//


import Foundation

struct Results: Codable {
    let results: [MovieDTO]
}

struct MovieDTO: Codable {
    let id: Int
    let title: String
    let originalTitle: String
    let originalLanguage: String
    let overview: String
    let releaseDate: Date
    let posterPath: URL?
    let backdropPath: URL?
    let voteAverage: Double
    let genreIds: [Int]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.originalTitle = try container.decode(String.self, forKey: .originalTitle)
        self.originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.releaseDate = try container.decode(Date.self, forKey: .releaseDate)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        self.genreIds = try container.decode([Int].self, forKey: .genreIds)

        if let posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) {
            self.posterPath = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        } else {
            self.posterPath = nil
        }

        if let backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath) {
            self.backdropPath = URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)")
        } else {
            self.backdropPath = nil
        }
    }
}
