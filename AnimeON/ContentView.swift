//
//  ContentView.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(AnimeVM.self) private var vm
    @Query(sort: [SortDescriptor<Anime>(\.romajiTitle)])
    var animeList: [Anime]
    
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(animeList) { anime in
                        AnimePosterView(anime: anime)
                    }
                }
                .padding()
            }
            .navigationTitle("Anime List")
        }
    }
}

#Preview {
    ContentView()
        .environment(AnimeVM())
        .modelContainer(for: [Anime.self])
}
