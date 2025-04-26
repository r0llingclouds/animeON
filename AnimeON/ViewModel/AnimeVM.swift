//
//  AnimeVM.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

import SwiftUI

@Observable
final class AnimeVM {
    // Get the best available title for display
    func getDisplayTitle(anime: Anime) -> String {
        // Prefer English title if available, otherwise use romaji
        return anime.englishTitle ?? anime.romajiTitle
    }
    
    // Format anime information for display
    func getAnimeInfo(anime: Anime) -> String {
        var info = [String]()
        
        if let episodes = anime.episodes {
            info.append("\(episodes) episodes")
        }
        
        if let score = anime.averageScore {
            info.append("Score: \(Int(score))%")
        }
        
        return info.joined(separator: " • ")
    }
    
    // Get genres as a formatted string
    func getGenres(anime: Anime) -> String? {
        anime.animeGenres?.map(\.genreID).map(\.name).formatted(.list(type: .and))
    }
    
    // Optional: Add a method to search for anime by title
    @MainActor
    func searchAnime(title: String, container: AnimeContainer) async -> Anime? {
        do {
            return try await container.searchAnime(title: title)
        } catch {
            print("Error searching for anime: \(error)")
            return nil
        }
    }
}
