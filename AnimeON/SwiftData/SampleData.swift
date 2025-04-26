//
//  SampleData.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//


import SwiftUI
import SwiftData

struct SampleData: PreviewModifier {
        
    static func makeSharedContext() async throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Movies.self, configurations: configuration)
        let testContainer = TestContainer(context: container.mainContext)
                
        try testContainer.loadGenres()
        try testContainer.loadMovies()
        
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleData())
}
