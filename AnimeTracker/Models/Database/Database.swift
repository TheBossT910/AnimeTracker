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
    @Published var userData: user_data?
    
    // database var
    private var db: Firestore
    
    // for auto-loading ALL animes
    private var lastDocumentSnapshot: DocumentSnapshot?
    
    // for auto-loading AIRING animes
    @Published var lastAiringSnapshots: [String: DocumentSnapshot?] = [:]
    @Published var airingKeys: [String: [String]] = [:]
    
    // array to make sure all shows are showed in loaded order
    var orderedKeys: [String] = []
    
    // constructor
    init() {
        // initial values
        self.animeData = [:]
        self.userData = [:]
        
        self.lastDocumentSnapshot = nil
        self.lastAiringSnapshots = ["Sundays": nil, "Mondays": nil, "Tuesdays": nil, "Wednesdays": nil, "Thursdays": nil, "Fridays": nil, "Saturdays": nil]
        self.airingKeys = ["Sundays": [], "Mondays": [], "Tuesdays": [], "Wednesdays": [], "Thursdays": [], "Fridays": [], "Saturdays": []]
        
        // creating a Firestore instance
        self.db = Firestore.firestore()
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
            print("Error getting documents main fn: \(error)")
        }
        
        // return response data
        return response
    }
    
    // retrives the initial batch of animes from database
    public func getInitialDocuments(documentAmount: Int = 10) async {
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
            print("Error fetching initial documents: \(error)")
        }
        
        // get data
        let response = await getDocuments(animeIDs: animeIDs)
        // merge previous anime data with new response data
        animeData.merge(response) { (_, new) in new }
        
        // add keys
        orderedKeys = orderedKeys + getUniqueKeys(sourceKeys: orderedKeys, retrievedKeys: animeIDs)
    }

    // retrieve the next animes from database
    public func getNextDocuments(documentAmount: Int = 10) async {
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
            print("Error fetching next documents: \(error)")
        }
        
        // get data
        let response = await getDocuments(animeIDs: animeIDs)
        // merge previous anime data with new response data
        animeData.merge(response) { (_, new) in new }
        
        // add keys
        orderedKeys = orderedKeys + getUniqueKeys(sourceKeys: orderedKeys, retrievedKeys: animeIDs)
    }
    
    // immediately retrieves all favorited/watchlisted shows
    public func getMarkedDocuments(userID: String) async {
        // getting all different data arrays
        let favorites = userData?.favorites ?? []
        let completed = userData?.completed ?? []
        let dropped = userData?.dropped ?? []
        let watching = userData?.watching ?? []
        let planToWatch = userData?.plan_to_watch ?? []
        
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
                
        // add keys
        orderedKeys = orderedKeys + getUniqueKeys(sourceKeys: orderedKeys, retrievedKeys: animeIDs)
        
    }
    
    // initially gets airing data
    public func getInitialAiring(weekday: String, week: Date, documentAmount: Int = 5) async {
        // get the weekday as a number, and return the Unix time range for the day (start of day -> end of day)
        let weekdayAsNumber = getWeekdayAsNumber(weekday: weekday)
        let unixRange = getUnixRangeForWeekday(weekday: weekdayAsNumber, week: week)
        
        // adding ids to set to ensure no duplicates
        var animeIDSet = Set<String>()
        
        do {
            // getting filtered shows
            let episodesCollection = try await db.collectionGroup("episodes")
                .whereField("broadcast", isGreaterThanOrEqualTo: Int(unixRange!.start))
                .whereField("broadcast", isLessThanOrEqualTo: Int(unixRange!.end))
                .limit(to: documentAmount)
                .getDocuments()
            
            // going up 2 levels to get the anime collection id
            episodesCollection.documents.forEach { animeIDSet.insert($0.reference.parent.parent?.documentID ?? "") }
//            print(animeIDSet.count) // debug
            
            // convert set to array
            var animeIDs: [String] = []
            animeIDs = Array(animeIDSet)
            
            // get shows
            let response = await getDocuments(animeIDs: animeIDs)
            print("Animes retrieved for \(weekday): \(response.count)")
            
            // merge previous anime data with new response data
            animeData.merge(response) { (_, new) in new }
            
            // add keys
            orderedKeys = orderedKeys + getUniqueKeys(sourceKeys: orderedKeys, retrievedKeys: animeIDs)
            
            // adding airing data keys
            airingKeys[weekday] = (airingKeys[weekday] ?? []) + getUniqueKeys(sourceKeys: airingKeys[weekday] ?? [], retrievedKeys: animeIDs)
            
            // set last snapshot
            lastAiringSnapshots[weekday] = episodesCollection.documents.last
            
        } catch {
            print("error getting initialAiring \(error)")
        }
        
    }
    
    // gets next airing data
    public func getNextAiring(weekday: String, week: Date, documentAmount: Int = 5) async {
        // get the weekday as a number, and return the Unix time range for the day (start of day -> end of day)
        let weekdayAsNumber = getWeekdayAsNumber(weekday: weekday)
        let unixRange = getUnixRangeForWeekday(weekday: weekdayAsNumber, week: week)
        
        // adding ids to set to ensure no duplicates
        var animeIDSet = Set<String>()
        
        do {
            // getting filtered shows after the last retrieved show
            let episodesCollection = try await db.collectionGroup("episodes")
                .whereField("broadcast", isGreaterThanOrEqualTo: Int(unixRange!.start))
                .whereField("broadcast", isLessThanOrEqualTo: Int(unixRange!.end))
                .start(afterDocument: self.lastAiringSnapshots[weekday]!!)
                .limit(to: documentAmount)
                .getDocuments()
            
            // going up 2 levels to get the anime collection id
            episodesCollection.documents.forEach { animeIDSet.insert($0.reference.parent.parent?.documentID ?? "") }
//            print(animeIDSet.count) // debug
            
            // convert set to array
            var animeIDs: [String] = []
            animeIDs = Array(animeIDSet)
            
            // get shows
            let response = await getDocuments(animeIDs: animeIDs)
            print("Additional animes retrieved for \(weekday): \(response.count)")
            
            // merge previous anime data with new response data
            animeData.merge(response) { (_, new) in new }

            // add keys
            orderedKeys = orderedKeys + getUniqueKeys(sourceKeys: orderedKeys, retrievedKeys: animeIDs)
            
            // adding airing data keys
            airingKeys[weekday] = (airingKeys[weekday] ?? []) + getUniqueKeys(sourceKeys: airingKeys[weekday] ?? [], retrievedKeys: animeIDs)
            
            // set last snapshot
            lastAiringSnapshots[weekday] = episodesCollection.documents.last
            
        } catch {
            print("error getting nextAiring \(error)")
        }
    }
    
    // retrieves user data from database
    // TODO: stop using an array to store 1 variable... We are just doing this because our current implementation worked like this!
    public func getUserDocument(userID: String) async {
        do {
            let queryUser = try await db.collection("/user_data/").document(userID).getDocument()
            userData = try queryUser.data(as: user_data.self)
        }
        catch {
            print("Error getting user documents: \(error)")
        }
    }
    
    // toggles a given anime as a favorite
    public func updateFavorite(userID: String, isFavorite: Bool, animeID: Int) {
        var myUser: user_data = userData!
        
        // not in favorites and we want to add to favorites
        if ((myUser.favorites?.contains(animeID)) == false) && isFavorite {
            // add to array
            myUser.favorites?.append(animeID)
            
            // update database
            db.collection("/user_data/").document(userID).updateData(["favorites": myUser.favorites as Any])
            // update local copy
            userData = myUser
        } else if ((myUser.favorites?.contains(animeID)) == true) && !isFavorite {   // in favorites, and we want to remove from favorites
            // remove from array
            myUser.favorites?.removeAll { $0 == animeID }
            
            // update database
            db.collection("/user_data/").document(userID).updateData(["favorites": myUser.favorites as Any])
            // update local copy
            userData = myUser
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
            userData = try await db.collection("/user_data/").document(userID).getDocument(as: user_data.self)
        }
    }
    
    // resets the airing keys
    public func resetAiringKeys() {
        self.airingKeys = ["Sundays": [], "Mondays": [], "Tuesdays": [], "Wednesdays": [], "Thursdays": [], "Fridays": [], "Saturdays": []]
    }
    
    // returns the unique keys from retrievedKeys  not found in sourceKeys
    private func getUniqueKeys(sourceKeys: [String], retrievedKeys: [String]) -> [String] {
        var uniqueKeys: [String] = []
        retrievedKeys.forEach {
            // add to uniqueKeys if not in sourceKeys
            if !sourceKeys.contains($0) {
                uniqueKeys.append($0)
            }
        }
        
        // return unique keys
        return uniqueKeys
    }
}
