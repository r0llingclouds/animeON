//
//  AnimeONApp.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

import SwiftUI
import SwiftData

let APIKey = ""

@main
struct PeliculONApp: App {
    @State private var container: PeliculONContainer?
    @State private var vm = MoviesVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(vm)
                .onAppear {
                    print(URL.documentsDirectory)
                }
        }
        .modelContainer(for: Movies.self) { result in
            guard case .success(let container) = result else { return }
            Task(priority: .low) { await loadData(container) }
        }
    }
    
    func loadData(_ container: ModelContainer) async {
        do {
            self.container = PeliculONContainer(modelContainer: container)
            try await self.container?.loadInitialData()
        } catch {
            print("Error en la carga de datos \(error).")
        }
    }
}

