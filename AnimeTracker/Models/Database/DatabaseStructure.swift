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
    var number_episode: Int?
}

extension episodes: Hashable {
    // checks if the left-hand side and right-hand side are the same
    static func == (lhs: episodes, rhs: episodes) -> Bool {
        // check if they have the same tvdb_id. This is unique to each episode, and all episode MUST have a tvdb_id
        return lhs.tvdb_id == rhs.tvdb_id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(tvdb_id)
    }
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
