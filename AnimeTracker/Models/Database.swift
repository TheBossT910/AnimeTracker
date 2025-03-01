//
//  Database.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-02-18.
//
// Updated file to communicate with the database.
// This replaces AnimeFirebaseDatabase, which will be deprecated at a later date

// TODO: Implement new database code. We are using the new database structure for Firebase. See Notion for more details
// TODO: Create an interface (called Protocols) for all of the methods in this file. This is to make it easier in the future if we change databases

import Foundation
import FirebaseFirestore

@MainActor class Database : DatabaseProtocol, ObservableObject {
    @Published var anime_data: [String: [String: [String: [String : Any]]]]
    @Published var structEpisodeTest: [String: [episodes]]
    private var db: Firestore
    
    // constructor
    init() {
        self.anime_data = [:]
        self.structEpisodeTest = [:]
        // creating a Firestore instance
        self.db = Firestore.firestore()
        
        // running async tasks
        Task {
            await getDocuments()
        }
    }
    
    // getting all documents from Firebase
    func getDocuments() async {
        do {
            // get all documents (all animes) in anime_data
            var animeArray: [String] = []
            let queryAnime = try await self.db.collection("/anime_data/").getDocuments()
            queryAnime.documents.forEach { document in
                // append all anime IDs to array
                let animeID = document.documentID
                animeArray.append(animeID)
                
                // adding main document to array
//                anime_data[animeID]?["main"] = document.data()
            }
            
            // parsing each anime
            var counter: Int = 0
            for animeID in animeArray {
                // creating arrays to store data for their respective documents
                var dataArray: [String: [String: Any]] = [:]
                var episodeArray: [String: [String: Any]] = [:]
                // this is for the struct test
                var newEpisodes: [episodes] = []
                
                // getting all data documents
                let queryData = try await self.db.collection("/anime_data/\(animeID)/data").getDocuments()
                queryData.documents.forEach { document in
                    // add each data document to array
                    dataArray[document.documentID] = document.data()
                }
                
                //getting all episode documents
                let queryEpisodes = try await self.db.collection("/anime_data/\(animeID)/episodes").getDocuments()
                queryEpisodes.documents.forEach { document in
                    // add each episode document to array
//                    episodeArray[document.documentID] = document.data()
                    do {
                        var newEp: episodes
                        newEp = try document.data(as: episodes.self)
                        newEpisodes.append(newEp)
                    }
                    catch {
                        print("failed to decode episode data into struct")
                    }
                }
                
                let queryMain = try await self.db.collection("/anime_data/").document(animeID).getDocument()
                let  mainData = queryMain.data()!
                
                anime_data[animeID] = ["anime": ["main": mainData], "data": dataArray, "episodes": episodeArray]
                // FB struct test
                structEpisodeTest[animeID] = newEpisodes
                counter = counter + 1
                print("\(counter)/200")
            }
        
            
        } catch {
            print("Error fetching documents: \(error)")
        }
    }
}

// temporarily creating structs here for testing.
// in real implementation, structs would be declared in a seperate file!

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
