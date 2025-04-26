//
//  APITestView.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

import SwiftUI

struct APITestView: View {
    let repository = Repository()
    @State private var animeResults: [AnimeDTO] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                // Search field for testing specific anime search
                HStack {
                    TextField("Search anime...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Search") {
                        searchAnime()
                    }
                    .disabled(searchText.isEmpty)
                }
                .padding()
                
                // Button to test popular anime fetch
                Button("Fetch Popular Anime") {
                    fetchPopularAnime()
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom)
                
                if isLoading {
                    ProgressView()
                        .padding()
                } else if let error = errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    // Results list
                    List(animeResults, id: \.id) { anime in
                        VStack(alignment: .leading) {
                            Text(anime.title.english ?? anime.title.romaji ?? "Unknown")
                                .font(.headline)
                            
                            if let genres = anime.genres, !genres.isEmpty {
                                Text(genres.joined(separator: ", "))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            if let score = anime.averageScore {
                                Text("Score: \(score)")
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
            .navigationTitle("API Test")
        }
    }
    
    func fetchPopularAnime() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                animeResults = try await repository.getPopularAnime()
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    func searchAnime() {
        guard !searchText.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                if let result = try await repository.searchAnime(title: searchText) {
                    animeResults = [result]
                } else {
                    animeResults = []
                    errorMessage = "No results found"
                }
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
}

#Preview {
    APITestView()
}
