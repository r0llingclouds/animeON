//
//  TestContainer.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//


import SwiftUI
import SwiftData

@MainActor
final class TestContainer: Sendable {
    static let movieDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    let decoder: JSONDecoder = {
        var decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(movieDateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    var urlGenres: URL {
        Bundle.main.url(forResource: "genres", withExtension: "json")!
    }
    
    var urlNowPlaying: URL {
        Bundle.main.url(forResource: "now_playing", withExtension: "json")!
    }
    
    var urlupcoming: URL {
        Bundle.main.url(forResource: "upcoming", withExtension: "json")!
    }
    
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func loadGenres() throws {
        let data = try Data(contentsOf: urlGenres)
        let genresDTO = try decoder.decode(GenresResponseDTO.self, from: data).genres
        genresDTO.map { genre in
            Genres(id: genre.id, name: genre.name)
        }.forEach { new in
            context.insert(new)
        }
    }
    
    func loadMovies() throws {
        let data = try Data(contentsOf: urlNowPlaying)
        let moviesDTO = try decoder.decode(Results.self, from: data).results
        try moviesDTO.forEach { movie in
            let newMovie = Movies(id: movie.id,
                                  title: movie.title,
                                  originalTitle: movie.originalTitle,
                                  originalLanguage: movie.originalLanguage,
                                  overview: movie.overview,
                                  releaseDate: movie.releaseDate,
                                  poster: movie.posterPath,
                                  backdrop: movie.backdropPath,
                                  voteAverage: movie.voteAverage)
            context.insert(newMovie)
            try getGenres(genres: movie.genreIds).forEach { genre in
                let newRelation = MoviesGenres(movieID: newMovie, genreID: genre)
                context.insert(newRelation)
            }
        }
    }
    
    func getGenres(genres: [Int]) throws -> [Genres] {
        let descriptor = FetchDescriptor<Genres>(predicate: #Predicate { genres.contains($0.id) })
        let result = try context.fetch(descriptor)
        return result
    }
}
