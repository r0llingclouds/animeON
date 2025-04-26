//
//  AnimeONApp.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

import SwiftUI
import SwiftData

@main
struct AnimeONApp: App {
    @State private var container: AnimeContainer?
    @State private var vm = AnimeVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(vm)
                .navigationViewStyle(.stack)
                .onAppear {
                    print("Documents directory: \(URL.documentsDirectory)")
                }
        }
        .modelContainer(for: [Anime.self, Genre.self, AnimeGenres.self]) { result in
            switch result {
            case .success(let container):
                Task(priority: .userInitiated) {
                    await loadData(container)
                }
            case .failure(let error):
                print("Failed to create model container: \(error)")
            }
        }
    }
    
    func loadData(_ container: ModelContainer) async {
        do {
            self.container = AnimeContainer(modelContainer: container)
            try await self.container?.loadInitialData()
            print("Successfully loaded initial anime data")
        } catch {
            print("Error loading anime data: \(error)")
        }
    }
}
