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


// TODO: fetch documents async

import Foundation
import FirebaseFirestore

@MainActor class Database : DatabaseProtocol, ObservableObject {
    @Published var animeData: [String: anime]
    @Published var userData: [String : user_data]
    private var db: Firestore
    private var lastDocumentSnapshot: DocumentSnapshot?
    private var gotMarkedDocuments: Bool = false
    
    // constructor
    init() {
        // initial values
        self.animeData = [:]
        self.userData = [:]
        self.lastDocumentSnapshot = nil
        
        // creating a Firestore instance
        self.db = Firestore.firestore()
        
        // running async tasks
        Task {
            await getInitialDocuments(documentAmount: 20)
        }
    }
    
    // retrieves documents from Firebase (async)
    private func getDocuments(animeIDs: [String]) async -> [String: anime] {
        // storing async response in 'response' variable
        var response: [String: anime] = [:]
        
        // try to get anime data
        do {
            response = try await withThrowingTaskGroup(of: (String, anime).self) { group in
                // going through each animeID
                for animeID in animeIDs {
                    // creating a task for each anime
                    group.addTask {
                        // for main
                        let currentMain = try await self.db.collection("/anime_data/").document(animeID).getDocument(as: main.self)
                        
                        // for data
                        let currentFile = try await self.db.collection("/anime_data/\(animeID)/data").document("files").getDocument(as: files.self)
                        let currentGeneral = try await self.db.collection("/anime_data/\(animeID)/data").document("general").getDocument(as: general.self)
                        
                        // for episodes
                        var currentEpisodes: [episodes] = []
                        let queryEpisodes = try await self.db.collection("/anime_data/\(animeID)/episodes").getDocuments()
                        queryEpisodes.documents.forEach { document in
                            currentEpisodes.append(try! document.data(as: episodes.self))
                        }
                        
                        // creating anime object
                        let currentAnime: anime = anime(
                            id: animeID,
                            main: currentMain,
                            data: data(files: currentFile, general: currentGeneral),
                            episodes: currentEpisodes
                        )
                        
                        return (animeID, currentAnime)
                        }
                    }
                
                // parsing data
                var animes = [String: anime]()
                for try await (animeID, currentAnime) in group {
                    // adding data to proper spots in array
                    animes[animeID] = currentAnime
                }
                
                // return parsed data (to response)
                return animes
            }
        } catch {
            print("Error getting documents: \(error)")
        }
        
        // return response data
        return response
    }
    
    // retrives the initial batch of animes from database
    private func getInitialDocuments(documentAmount: Int = 20) async {
        // getting all anime ids
        var animeIDs : [String] = []
        do {
            // fetch all anime documents
            let queryAnime = try await self.db.collection("/anime_data")
                .limit(to: documentAmount)
                .getDocuments()
            var counter = 0
            queryAnime.documents.forEach { document in
                // add to array
                animeIDs.append(document.documentID)
                counter += 1
            }
            print("Initial anime documents: \(counter)")
            lastDocumentSnapshot = queryAnime.documents.last
        }
        catch {
            print("Error fetching documents: \(error)")
        }
        
        let response = await getDocuments(animeIDs: animeIDs)
        // set animeData to response
        animeData = response
    }

    // retrieve the next animes from database
    public func getNextDocuments(documentAmount: Int = 20) async {
        // getting all anime ids
        var animeIDs : [String] = []
        do {
            // fetch all anime documents
            let queryAnime = try await self.db.collection("/anime_data")
                .start(afterDocument: self.lastDocumentSnapshot!)
                .limit(to: documentAmount)
                .getDocuments()
            var counter = 0
            queryAnime.documents.forEach { document in
                // add to array
                animeIDs.append(document.documentID)
                counter += 1
            }
            print("Added anime documents: \(counter)")
            lastDocumentSnapshot = queryAnime.documents.last
        }
        catch {
            print("Error fetching documents: \(error)")
        }
        
        let response = await getDocuments(animeIDs: animeIDs)
        // merge previous anime data with new response data
        animeData.merge(response) { (_, new) in new }
    }
    
    // immediately retrieves all favorited/watchlisted shows
    public func getMarkedDocuments(userID: String) async {
        // getting all different data arrays
        let favorites = userData[userID]?.favorites ?? []
        let completed = userData[userID]?.completed ?? []
        let dropped = userData[userID]?.dropped ?? []
        let watching = userData[userID]?.watching ?? []
        let planToWatch = userData[userID]?.plan_to_watch ?? []
        
        // merging into 1 array
        // this creates 1 array which has all data, then makes it into a Set (to get rid of duplicates) and converts it back into an array
        let mergedInt = Array(Set(favorites + completed + dropped + watching + planToWatch))
        // converts all items (Int) into Strings
        let mergedString = mergedInt.map { String($0) }
        print("Number of marked docs: \(mergedInt.count)")
        
        // getting animes
        let animeIDs: [String] = mergedString
        let response = await getDocuments(animeIDs: animeIDs)
        
        // merge previous anime data with new response data
        animeData.merge(response) { (_, new) in new }
    }
    
    // retrieves user data from database
    // TODO: only retrieve signed-in user. This is a privacy issue!
//    private func getUserDocuments() async {
//        do {
//            let queryUsers = try await db.collection("/user_data/").getDocuments()
//            try queryUsers.documents.forEach { document in
//                // add each user to array
//                userData[document.documentID] = try document.data(as: user_data.self)
//            }
//        }
//        catch {
//            print("Error getting documents: \(error)")
//        }
//    }
    
    // TODO: stop using an array to store 1 variable... We are just doing this because our current implementation worked like this!
    public func getUserDocument(userID: String) async {
        do {
            let queryUser = try await db.collection("/user_data/").document(userID).getDocument()
            userData[queryUser.documentID] = try queryUser.data(as: user_data.self)
        }
        catch {
            print("Error getting documents: \(error)")
        }
    }
    
    // this function updates user-defined variables
    // currently, it only updates the favorite button
    // toggles the given anime as a favorite
    public func updateFavorite(userID: String, isFavorite: Bool, animeID: Int) {
        var myUser: user_data = userData[userID]!
        
        // not in favorites and we want to add to favorites
        if ((myUser.favorites?.contains(animeID)) == false) && isFavorite {
            // add to array
            myUser.favorites?.append(animeID)
            
            // update database
            db.collection("/user_data/").document(userID).updateData(["favorites": myUser.favorites as Any])
            // update local copy
            userData[userID] = myUser
        } else if ((myUser.favorites?.contains(animeID)) == true) && !isFavorite {   // in favorites, and we want to remove from favorites
            // remove from array
            myUser.favorites?.removeAll { $0 == animeID }
            
            // update database
            db.collection("/user_data/").document(userID).updateData(["favorites": myUser.favorites as Any])
            // update local copy
            userData[userID] = myUser
        }
    }
    
    // TODO: merge toggleWatchlist and updateFavorites into 1 function!
    // toggles a given anime from a watchlist
    public func toggleWatchlist(userID: String, animeID: Int, watchlist: [Int], watchlistName: String) {
        var updatedWatchlist: [Int] = []
        if (watchlist.contains(animeID)) {
            // remove show
            updatedWatchlist = watchlist.filter { $0 != animeID }
        } else {
            // add show
            updatedWatchlist = watchlist + [animeID]
        }
        
        // update databse
        db.collection("/user_data/").document(userID).updateData([watchlistName: updatedWatchlist])
        // update local copy
        Task {
            userData[userID] = try await db.collection("/user_data/").document(userID).getDocument(as: user_data.self)
        }
        
    }
}

// TODO: Put in a Util class!
// Replaces HTML tags with plain text
// courtesy of https://stackoverflow.com/questions/74321827/html-text-to-plain-text-swift
extension String {
    func toPlainText() -> String {
        self.replacingOccurrences(of: #"<[^>]+>"#, with: "", options: .regularExpression)
    }
}
