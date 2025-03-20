//
//  DatabaseEnums.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-02-18.
//
// Holds the structure for the database documents

import Foundation
import FirebaseFirestore

// temporarily creating structs here for testing.
// in real implementation, structs would be declared in a seperate file!

// stores each anime's data into an easy-to-access struct
struct anime: Codable {
    @DocumentID var id: String?
    var main: main?
    var episodes: [episodes]?
}

struct main: Codable {
    @DocumentID var id: String?
    // doc info
    var anilist_id: Int?
    var db_version: String?
    var doc_id: Int?
    var mal_id: Int?
    var relation_id: String?
    var title: String?
    var tvdb_id: Int?
    
    // show info
    var description: String?
    var episodes: Int?
    var premiere: String?
    var rating: String?
    var title_english: String?
    var title_native: String?
    
    // show files
    var box_image: String?
    var icon_image: String?
    var splash_image: String?
}

//struct data: Codable {
//    @DocumentID var id: String?
//    var files: files?
//    var general: general?
//}

struct episodes: Codable {
    @DocumentID var id: String?
    var anilist_id: Int?
    var box_image: String?
    var broadcast: Int?
    var description: String?
    var recap: String?
    var runtime: Int?
    var title_episode: String?
    var tvdb_id: Int?
}

struct user_data: Codable {
    @DocumentID var id: String?
    var user_name: String?
    var favorites: [Int]?
    //"Dropped", "Completed", "Watching", "Plan to Watch" are different watch lists
    var dropped: [Int]?
    var completed: [Int]?
    var watching: [Int]?
    var plan_to_watch: [Int]?
}

////structs for general, files, description, recap documents in each anime's collection
//struct general: Identifiable, Decodable {
//    @DocumentID var id: String?
//    let broadcast: String?
//    let category_status: String?
//    let description: String?
//    let title_eng: String?
//    let title_jp: String?
//    let episodes: Int?
//    var isFavorite: Bool?
//    let isRecommended: Bool?
//    let premiere: String?
//    let rating: String?
//}
//
//struct files: Identifiable, Decodable {
//    @DocumentID var id: String?
//    let box_image: String?
//    let splash_image: String?
//    let icon: String?
//    let doc_id_anime: String?
//}
//
//struct media: Identifiable, Decodable {
//    @DocumentID var id: String?
//    let episodes: [String: mediaContent]?
//    let movies: [String: mediaContent]?
//}
//
////use this when we need to return a default struct. This is a fallback
//struct defaultStruct: Identifiable, Decodable {
//    @DocumentID var id: String?
//    let data: String?
//}
//
//struct mediaContent: Identifiable, Decodable {
//    @DocumentID var id: String?
//    let air_day: String?
//    let air_time: String?
//    let description: String?
//    let name_eng: String?
//    let name_jp: String?
//    let recap: String?
//}
