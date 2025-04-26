//
//  PosterView.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

import SwiftUI
import SwiftData
import SMP25Kit

struct PosterView: View {
    @State private var vm = AsyncImageVM()
    let movie: Movies
    
    var body: some View {
        if let poster = vm.image {
            Image(uiImage: poster)
                .resizable()
                .scaledToFit()
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.black.opacity(0.5))
                        .frame(height: 60)
                        .overlay {
                            title
                        }
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(color: .primary.opacity(0.3),
                        radius: 5, x: 0, y: 5)
        } else {
            Image(systemName: "popcorn")
                .resizable()
                .scaledToFit()
                .padding()
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.black.opacity(0.5))
                        .frame(height: 60)
                        .overlay {
                            title
                        }
                }
                .background {
                    Color.gray.opacity(0.2)
                }
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .onAppear {
                    vm.getImage(url: movie.poster)
                }
        }
    }
    
    var title: some View {
        Text(movie.title)
            .font(.system(.headline, design: .rounded))
            .foregroundStyle(.white)
            .padding()
            .lineLimit(2, reservesSpace: true)
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.8)
    }
}

#Preview(traits: .sampleData) {
    PosterView(movie: .testMovie)
}
