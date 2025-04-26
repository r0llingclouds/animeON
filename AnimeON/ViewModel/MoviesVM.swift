//
//  MoviesVM.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

import SwiftUI

@Observable
final class MoviesVM {
    func getGenres(movie: Movies) -> String? {
        movie.moviesGenres?.map(\.genreID).map(\.name).formatted(.list(type: .and))
    }
}
