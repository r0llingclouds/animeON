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
        let popularAnimeDTO = try await repository.getPopularAnime()
        let animeEntities = try loadAnime(animeDTO: popularAnimeDTO)
        animeEntities.forEach { $0.isPopular = true }
        
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
    
    func loadAnime(animeDTO: [AnimeDTO]) throws -> [Anime] {
        try animeDTO.map { dto in
            
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
            
            modelContext.insert(anime)
            
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
    
    
    // WIP!
    func searchAnime(title: String) async throws -> Anime? {
        // First try searching via API
        if let animeDTO = try await repository.searchAnime(title: title) {
            // Check if we already have this specific anime in database by ID
            let idDescriptor = FetchDescriptor<Anime>(
                predicate: #Predicate { $0.id == animeDTO.id }
            )
            
            let existingById = try modelContext.fetch(idDescriptor)
            if let existing = existingById.first {
                return existing
            }
            
            // If not found, convert DTO to entity and save
            let animeEntities = try loadAnime(animeDTO: [animeDTO])
            try modelContext.save()
            return animeEntities.first
        }
        
        return nil
    }
    
}
