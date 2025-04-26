//
//  GenresDTO.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

struct GenresResponseDTO: Codable {
    let genres: [GenresDTO]
}

struct GenresDTO: Codable {
    let id: Int
    let name: String
}
