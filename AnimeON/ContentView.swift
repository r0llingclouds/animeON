//
//  ContentView.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(MoviesVM.self) private var vm
    @Query(filter: #Predicate { $0.nowPlaying },
           sort: [SortDescriptor<Movies>(\.title)])
        var movies: [Movies]
    let column = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: column) {
                ForEach(movies) { movie in
                    PosterView(movie: movie)
                }
            }
        }
        .safeAreaPadding()
    }
}

#Preview(traits: .sampleData) {
    ContentView()
        .environment(MoviesVM())
}
