//
//  AnimeGenres.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

import Foundation
import SwiftData

@Model
final class AnimeGenres {
    @Attribute(.unique) var id: UUID
    @Relationship(deleteRule: .cascade) var animeID: Anime
    @Relationship(deleteRule: .cascade) var genreID: Genre
    
    init(id: UUID = UUID(), animeID: Anime, genreID: Genre) {
        self.id = id
        self.animeID = animeID
        self.genreID = genreID
    }
}
