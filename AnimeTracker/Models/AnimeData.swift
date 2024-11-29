//
//  AnimeData.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import Foundation

@Observable
class AnimeData {
    //grabbing data from animeData.json file and putting into our own Anime objects.
    var animes: [Anime] = load("animeData.json")
    
    //creates a list of only recommended animes
    var recommendedAnimes: [Anime] {
        animes.filter { $0.isRecommended }
    }
    
    //making a dictionary of arrays which have String keys of "Watching", "Completed", "Plan to Watch", "Dropped", and values of arrays with corresponding Anime objects
    var categoryStatus: [String: [Anime]] {
        Dictionary(
            grouping: animes,
            by: { $0.categoryStatus.rawValue}
            )
    }
}

//making the function to get our data
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    //find the file
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    //try loading the file
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename): \(error)")
    }
    
    //try decoding the file and storing in type T, returning it
    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        fatalError("Couldn't decode \(filename): \(error)")
    }
}


