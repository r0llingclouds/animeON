//
//  APITester.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

import Foundation

struct APITester {
    static let repository = Repository()
    
    static func testAPIConnections() {
        print("Starting API tests...")
        
        // Test popular anime
        Task {
            do {
                print("Testing getPopularAnime()...")
                let popularAnime = try await repository.getPopularAnime()
                print("✅ SUCCESS: Retrieved \(popularAnime.count) popular anime")
                
                // Print first anime details as sample
                if let first = popularAnime.first {
                    print("Sample anime: \(first.title.english ?? first.title.romaji ?? "Untitled")")
                    print("ID: \(first.id)")
                    print("Episodes: \(first.episodes ?? 0)")
                    print("Score: \(first.averageScore ?? 0)")
                    print("Genres: \(first.genres?.joined(separator: ", ") ?? "None")")
                    print("Cover image URL: \(first.coverImage.large)")
                }
                
                // Test search anime
                print("\nTesting searchAnime()...")
                if let searchResult = try await repository.searchAnime(title: "Attack on Titan") {
                    print("✅ SUCCESS: Found anime with search")
                    print("Search result: \(searchResult.title.english ?? searchResult.title.romaji ?? "Untitled")")
                    print("ID: \(searchResult.id)")
                } else {
                    print("❌ FAILURE: No anime found with search")
                }
                
            } catch {
                print("❌ ERROR: \(error.localizedDescription)")
            }
        }
    }
}
