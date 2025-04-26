//
//  URL.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

import Foundation

let apiURL = URL(string: "https://api.themoviedb.org/3/")!

extension URL {
    static let movie = apiURL.appending(path: "movie")
    static let nowPlaying = movie.appending(path: "now_playing").appending(queryItems: [.language, .region])
    static let upcoming = movie.appending(path: "upcoming").appending(queryItems: [.language, .region])
    static let genres = apiURL.appending(path: "genre/movie/list").appending(queryItems: [.language])
}

extension URLQueryItem {
    static let language = URLQueryItem(name: "language", value: "es-ES")
    static let region = URLQueryItem(name: "region", value: "ES")
}

