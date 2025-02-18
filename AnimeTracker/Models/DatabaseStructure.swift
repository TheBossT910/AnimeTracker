//
//  DatabaseEnums.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-02-18.
//
// Holds the structure for the database documents

import Foundation
import FirebaseFirestore

//structs for general, files, description, recap documents in each anime's collection
struct general: Identifiable, Decodable {
    @DocumentID var id: String?
    let broadcast: String?
    let category_status: String?
    let description: String?
    let title_eng: String?
    let title_jp: String?
    let episodes: Int?
    var isFavorite: Bool?
    let isRecommended: Bool?
    let premiere: String?
    let rating: String?
}

struct files: Identifiable, Decodable {
    @DocumentID var id: String?
    let box_image: String?
    let splash_image: String?
    let icon: String?
    let doc_id_anime: String?
}

struct media: Identifiable, Decodable {
    @DocumentID var id: String?
    let episodes: [String: mediaContent]?
    let movies: [String: mediaContent]?
}

//use this when we need to return a default struct. This is a fallback
struct defaultStruct: Identifiable, Decodable {
    @DocumentID var id: String?
    let data: String?
}

struct mediaContent: Identifiable, Decodable {
    @DocumentID var id: String?
    let air_day: String?
    let air_time: String?
    let description: String?
    let name_eng: String?
    let name_jp: String?
    let recap: String?
}
