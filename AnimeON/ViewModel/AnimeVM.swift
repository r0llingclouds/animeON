//
//  AnimeVM.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

import SwiftUI

@Observable
final class AnimeVM {

    func getDisplayTitle(anime: Anime) -> String {
        anime.displayTitle
    }
    

    func getAnimeInfo(anime: Anime) -> String {
        anime.infoString
    }
    

    func getGenres(anime: Anime) -> String? {
        anime.genresString
    }
    
    // WIP!
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
