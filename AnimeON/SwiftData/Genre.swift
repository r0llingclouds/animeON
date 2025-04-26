//
//  Genre.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

import Foundation
import SwiftData

@Model
final class Genre {
    @Attribute(.unique) var name: String
    
    @Relationship(deleteRule: .cascade, inverse: \AnimeGenres.genreID)
    var animeGenres: [AnimeGenres]?
    
    init(name: String) {
        self.name = name
    }
}
