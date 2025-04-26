//
//  Genres.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//


import Foundation
import SwiftData

@Model
final class Genres {
    @Attribute(.unique) var id: Int
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \MoviesGenres.genreID) var moviesGenres: [MoviesGenres]?
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

@Model
final class MoviesGenres {
    @Attribute(.unique) var id: UUID
    @Relationship(deleteRule: .cascade) var movieID: Movies
    @Relationship(deleteRule: .cascade) var genreID: Genres
    
    init(id: UUID = UUID(), movieID: Movies, genreID: Genres) {
        self.id = id
        self.movieID = movieID
        self.genreID = genreID
    }
}
