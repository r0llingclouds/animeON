//
//  PeliculONContainer.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//


import Foundation
import SwiftData

@ModelActor
actor PeliculONContainer {
    let repository = Repository()
    
    func loadInitialData() async throws {
        let genres = try await repository.getGenres()
        try loadGenres(genresDTO: genres)
        let (nowPlaying, upcoming) = try await (repository.getNowPlaying(), repository.getUpcoming())
        let nowPlayingMovies = try loadMovies(moviesDTO: nowPlaying)
        nowPlayingMovies.forEach { $0.nowPlaying = true }
        let upcomingMovies = try loadMovies(moviesDTO: upcoming)
        upcomingMovies.forEach { $0.upcoming = true }
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
    
    func loadGenres(genresDTO: [GenresDTO]) throws {
        genresDTO.map { genre in
            Genres(id: genre.id, name: genre.name)
        }.forEach { new in
            modelContext.insert(new)
        }
    }
    
    func loadMovies(moviesDTO: [MovieDTO]) throws -> [Movies] {
        try moviesDTO.map { movie in
            let newMovie = Movies(id: movie.id,
                                  title: movie.title,
                                  originalTitle: movie.originalTitle,
                                  originalLanguage: movie.originalLanguage,
                                  overview: movie.overview,
                                  releaseDate: movie.releaseDate,
                                  poster: movie.posterPath,
                                  backdrop: movie.backdropPath,
                                  voteAverage: movie.voteAverage)
            modelContext.insert(newMovie)
            for genre in try getGenres(genres: movie.genreIds) {
                let newRelation = MoviesGenres(movieID: newMovie, genreID: genre)
                modelContext.insert(newRelation)
            }
            return newMovie
        }
    }
    
    func getGenres(genres: [Int]) throws -> [Genres] {
        let descriptor = FetchDescriptor<Genres>(predicate: #Predicate { genres.contains($0.id) })
        let result = try modelContext.fetch(descriptor)
        return result
    }
}
