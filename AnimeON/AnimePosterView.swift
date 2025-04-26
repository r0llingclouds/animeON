//
//  AnimePosterView.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

import SwiftUI
import SwiftData
import SMP25Kit

struct AnimePosterView: View {
    @Environment(AnimeVM.self) private var vm
    @State private var imageVM = AsyncImageVM()
    let anime: Anime
    
    var body: some View {
        VStack(alignment: .leading) {
            // Poster image
            if let poster = imageVM.image {
                Image(uiImage: poster)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(radius: 4)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        Image(systemName: "tv")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                    .onAppear {
                        imageVM.getImage(url: anime.coverImageURL)
                    }
            }
            
            // Title and info
            VStack(alignment: .leading, spacing: 4) {
                Text(vm.getDisplayTitle(anime: anime))
                    .font(.headline)
                    .lineLimit(2)
                
                if let genres = vm.getGenres(anime: anime) {
                    Text(genres)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Text(vm.getAnimeInfo(anime: anime))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AnimePosterView(anime: .sampleAnime)
        .environment(AnimeVM())
        .frame(width: 180)
        .padding()
}
