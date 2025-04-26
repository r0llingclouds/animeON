//
//  AnimeDTO.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

import Foundation

// Main response structure from Anilist GraphQL API
struct AnimeResponse: Codable {
    let data: AnimeData
}

// Contains Media object with anime data
struct AnimeData: Codable {
    let Media: AnimeDTO?
    let Page: PageData?
}

// For paginated results
struct PageData: Codable {
    let media: [AnimeDTO]
}

// Represents an anime from the API
struct AnimeDTO: Codable, Identifiable {
    let id: Int
    let title: Title
    let coverImage: CoverImage
    let description: String?
    let episodes: Int?
    let averageScore: Double?
    let genres: [String]?
    
    // Nested structure for title variations
    struct Title: Codable {
        let english: String?
        let romaji: String?
        let native: String?
    }
    
    // Nested structure for image URLs
    struct CoverImage: Codable {
        let large: URL
        let medium: URL?
    }
}
