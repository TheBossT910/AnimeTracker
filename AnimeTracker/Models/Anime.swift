//
//  Anime.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import Foundation
import SwiftUI

//Create an Anime object here
struct Anime: Codable, Hashable, Identifiable {
    //NOTE: these variables should have the same name as in the json so that they are assigned their values!
    //general data
    var name: String
    var jpTitle: String
    var engTitle: String
    var season: Int
    var episodes: Int
    var premiere: String
    var broadcast: String
    var rating: String
    var description: String
    
    //variables
    // For Anime to be Identifiable, we need an id! This makes sure that each item in Anime is unique
    var id: Int
    var isFavorite: Bool
    var isRecommended: Bool
    
    //getting the image
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
    
    //NOTE: this variable should have the same name as the one in the json!
    //the status category!
    var categoryStatus: CategoryStatus
    enum CategoryStatus: String, CaseIterable, Codable {
        //we have Watching, Completed, Plan to Watch, Dropped
        case watching =  "Watching"
        case completed = "Completed"
        case planToWatch = "Plan to Watch"
        case dropped = "Dropped"
    }
    
    //we might want to make a ctegory for the days of the week?
    
    
}
