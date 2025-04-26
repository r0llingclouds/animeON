//
//  Anime.swift
//  AnimeON
//
//  Created by Tirso López Ausens on 26/4/25.
//

import Foundation
import SwiftData

@Model
final class Anime {
    @Attribute(.unique) var id: Int
    var englishTitle: String?
    var romajiTitle: String
    var nativeTitle: String?
    var descriptionAnime: String?
    var coverImageURL: URL?
    var episodes: Int?
    var averageScore: Double?
    
    var isPopular: Bool = false
    
    @Relationship(deleteRule: .cascade, inverse: \AnimeGenres.animeID)
    var animeGenres: [AnimeGenres]?
    
    init(id: Int, englishTitle: String?, romajiTitle: String, nativeTitle: String?,
         description: String?, coverImageURL: URL?, episodes: Int?, averageScore: Double?) {
        self.id = id
        self.englishTitle = englishTitle
        self.romajiTitle = romajiTitle
        self.nativeTitle = nativeTitle
        self.descriptionAnime = description
        self.coverImageURL = coverImageURL
        self.episodes = episodes
        self.averageScore = averageScore
    }
}

// Preview helper
extension Anime {
    @MainActor static var sampleAnime: Anime {
        let anime = Anime(
            id: 1,
            englishTitle: "Attack on Titan",
            romajiTitle: "Shingeki no Kyojin",
            nativeTitle: "進撃の巨人",
            description: "Several hundred years ago, humans were nearly exterminated by giants. Giants are typically several stories tall, seem to have no intelligence, devour human beings and, worst of all, seem to do it for the pleasure rather than as a food source.",
            coverImageURL: URL(string: "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx16498-C6FPmWm59CyP.jpg"),
            episodes: 25,
            averageScore: 84.5
        )
        return anime
    }
}
