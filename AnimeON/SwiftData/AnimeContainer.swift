//
//  AnimeContainer.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

import Foundation
import SwiftData

@ModelActor
actor AnimeContainer {
    let repository = Repository()
    
    func loadInitialData() async throws {
        // Get popular anime from the API
        let popularAnimeDTO = try await repository.getPopularAnime()
        
        // Load them into the database and mark as popular
        let animeEntities = try loadAnime(animeDTO: popularAnimeDTO)
        animeEntities.forEach { $0.isPopular = true }
        
        // Save changes if needed
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
    
    func loadAnime(animeDTO: [AnimeDTO]) throws -> [Anime] {
        try animeDTO.map { dto in
            // Create new anime entity
            let anime = Anime(
                id: dto.id,
                englishTitle: dto.title.english,
                romajiTitle: dto.title.romaji ?? "Unknown Title",
                nativeTitle: dto.title.native,
                description: dto.description,
                coverImageURL: dto.coverImage.large,
                episodes: dto.episodes,
                averageScore: dto.averageScore
            )
            
            // Insert into database
            modelContext.insert(anime)
            
            // Handle genres if they exist
            if let genres = dto.genres {
                for genreName in genres {
                    let genre = try getOrCreateGenre(name: genreName)
                    let relation = AnimeGenres(animeID: anime, genreID: genre)
                    modelContext.insert(relation)
                }
            }
            
            return anime
        }
    }
    
    func searchAnime(title: String) async throws -> Anime? {
        // Check if we already have this anime in the database
        let descriptor = FetchDescriptor<Anime>(
            predicate: #Predicate {
                $0.englishTitle?.localizedCaseInsensitiveContains(title) == true ||
                $0.romajiTitle.localizedCaseInsensitiveContains(title)
            }
        )
        
        let existingResults = try modelContext.fetch(descriptor)
        if let existingAnime = existingResults.first {
            return existingAnime
        }
        
        // If not found locally, search via API
        guard let animeDTO = try await repository.searchAnime(title: title) else {
            return nil
        }
        
        // Convert DTO to entity and save
        let animeEntities = try loadAnime(animeDTO: [animeDTO])
        if modelContext.hasChanges {
            try modelContext.save()
        }
        
        return animeEntities.first
    }
    
    private func getOrCreateGenre(name: String) throws -> Genre {
        let descriptor = FetchDescriptor<Genre>(
            predicate: #Predicate { $0.name == name }
        )
        
        let existingGenres = try modelContext.fetch(descriptor)
        
        if let existing = existingGenres.first {
            return existing
        } else {
            let newGenre = Genre(name: name)
            modelContext.insert(newGenre)
            return newGenre
        }
    }
}
