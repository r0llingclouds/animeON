//
//  Movies.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//


import Foundation
import SwiftData

@Model
final class Movies {
    @Attribute(.unique) var id: Int
    var title: String
    var originalTitle: String
    var originalLanguage: String
    var overview: String
    var releaseDate: Date
    var poster: URL?
    var backdrop: URL?
    var voteAverage: Double
    
    var nowPlaying: Bool = false
    var upcoming: Bool = false
    
    @Relationship(deleteRule: .cascade, inverse: \MoviesGenres.movieID) var moviesGenres: [MoviesGenres]?
    
    init(id: Int, title: String, originalTitle: String, originalLanguage: String, overview: String, releaseDate: Date, poster: URL?, backdrop: URL?, voteAverage: Double) {
        self.id = id
        self.title = title
        self.originalTitle = originalTitle
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.releaseDate = releaseDate
        self.poster = poster
        self.backdrop = backdrop
        self.voteAverage = voteAverage
    }
}

extension Movies {
    @MainActor static let testMovie: Movies = {
        let genre = Genres(id: 12, name: "Aventura")
        let movie = Movies(id: 986056,
                           title: "Thunderbolts*",
                           originalTitle: "Thunderbolts*",
                           originalLanguage: "en",
                           overview: "Un grupo de supervillanos y antihéroes van en misiones para el gobierno. Basado en la serie de cómics del mismo nombre.",
                           releaseDate: .now,
                           poster: URL(string: "https://image.tmdb.org/t/p/w500/eA39qgcH3r2dA9MQMBPwEXS6F86.jpg"),
                           backdrop: nil,
                           voteAverage: 7)
        let genreRelation = MoviesGenres(movieID: movie, genreID: genre)
        movie.moviesGenres?.append(genreRelation)
        return movie
    }()
}
