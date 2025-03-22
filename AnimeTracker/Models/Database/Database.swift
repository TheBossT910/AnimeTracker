//
//  Database.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-02-18.
//
// Class that communicates with the database.

// TODO: Create an interface (called Protocols) for all of the methods in this file. This is to make it easier in the future if we change databases

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
        
        self.lastDocumentSnapshot = nil
        self.lastAiringSnapshots = ["Sundays": nil, "Mondays": nil, "Tuesdays": nil, "Wednesdays": nil, "Thursdays": nil, "Fridays": nil, "Saturdays": nil]
        self.airingKeys = ["Sundays": [], "Mondays": [], "Tuesdays": [], "Wednesdays": [], "Thursdays": [], "Fridays": [], "Saturdays": []]
        
        // creating a Firestore instance
        self.db = Firestore.firestore()
        
        Task {
            // initially load 1 document
            await getInitialDocuments(documentAmount: 1)
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
                        
                        // creating anime object
                        let currentAnime: anime = anime(
                            id: animeID,
                            main: currentMain,
                            episodes: []
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
    // TODO: could be optimized furthur? Somehow ignore all fetch docs? (i.e. airing fetched more docs)
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
                // add to array if it doesn't already exist
                if (!animeIDs.contains(document.documentID)) {
                    animeIDs.append(document.documentID)
                    counter += 1
                }
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
    // TODO: in the future, dynamically load these in as well. This implementation is okay for now
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
    
    // retrieves the airing shows' documents and their specific airing episode document
    private func getAiring(episodesCollection: QuerySnapshot, weekday: String, documentAmount: Int = 5) async {
        // adding ids to set to ensure no duplicates
        var animeIDSet = Set<String>()
    
        // dictionary to save episode documents
        var episodeDocs: [String: [episodes]] = [:]
        
        // going up 2 levels to get the anime collection id
        episodesCollection.documents.forEach { document in
            let animeID = document.reference.parent.parent?.documentID ?? ""
            var currentEpisodes: [episodes] = []
            
            animeIDSet.insert(animeID)
            do {
                // get the currentEpisode and add to array
                let currentEpisode: episodes = try document.data(as: episodes.self)
                currentEpisodes.append(currentEpisode)
//                    print("EpID \(currentEpisode.id ?? "NONE") in animeID \(animeID)")
            } catch {
                print("Error converting to episode in getInitialAiring!")
            }
            
            // save episodes
            episodeDocs[animeID] = currentEpisodes
        }
//            print(animeIDSet.count) // debug
//            print(episodeDocs)    // debug
        
        // convert set to array
        var animeIDs: [String] = []
        animeIDs = Array(animeIDSet)
        
        // get shows that we have not fetched before
        var newAnimeIDSet = Set<String>()
        // returns a new set with elements not seen in orderedKeys
        newAnimeIDSet = animeIDSet.subtracting(Set(orderedKeys))
        let newAnimeIDs: [String] = Array(newAnimeIDSet)
        print("Num of unique: \(newAnimeIDs.count)")
        
        
        // get new shows we don't already have yet
        let response = await getDocuments(animeIDs: newAnimeIDs)
        // merge previous anime data with new response data
        animeData.merge(response) { (_, new) in new }
        
        // add keys
        orderedKeys = orderedKeys + getUniqueKeys(sourceKeys: orderedKeys, retrievedKeys: animeIDs)
        // adding airing data keys
        airingKeys[weekday] = (airingKeys[weekday] ?? []) + getUniqueKeys(sourceKeys: airingKeys[weekday] ?? [], retrievedKeys: animeIDs)
        // set last snapshot
        lastAiringSnapshots[weekday] = episodesCollection.documents.last
        
        // now, add episode data to each anime
        animeIDs.forEach { animeID in
            let currentAnime = animeData[animeID]
            let currentEpisodes = currentAnime?.episodes ?? []
            let newEpisodes = episodeDocs[animeID] ?? []
            
            // combine old + new episodes, and update local data
            let updatedEpisodes: [episodes] = Array(Set<episodes>(currentEpisodes + newEpisodes))
            animeData[animeID]?.episodes = updatedEpisodes
        }
    }
    
    
    // initially gets airing data
    public func getInitialAiring(weekday: String, week: Date, documentAmount: Int = 5) async {
        // get the weekday as a number, and return the Unix time range for the day (start of day -> end of day)
        let weekdayAsNumber = getWeekdayAsNumber(weekday: weekday)
        let unixRange = getUnixRangeForWeekday(weekday: weekdayAsNumber, week: week)
        
        do {
            // getting filtered shows
            let episodesCollection = try await db.collectionGroup("episodes")
                .whereField("broadcast", isGreaterThanOrEqualTo: Int(unixRange!.start))
                .whereField("broadcast", isLessThanOrEqualTo: Int(unixRange!.end))
                .limit(to: documentAmount)
                .getDocuments()
            
            await getAiring(episodesCollection: episodesCollection, weekday: weekday, documentAmount: documentAmount)
            
        } catch {
            print("error getting initialAiring \(error)")
        }
    }
    
    // gets next airing data
    public func getNextAiring(weekday: String, week: Date, documentAmount: Int = 5) async {
        // get the weekday as a number, and return the Unix time range for the day (start of day -> end of day)
        let weekdayAsNumber = getWeekdayAsNumber(weekday: weekday)
        let unixRange = getUnixRangeForWeekday(weekday: weekdayAsNumber, week: week)
        
        do {
            // getting filtered shows
            let episodesCollection = try await db.collectionGroup("episodes")
                .whereField("broadcast", isGreaterThanOrEqualTo: Int(unixRange!.start))
                .whereField("broadcast", isLessThanOrEqualTo: Int(unixRange!.end))
                .start(afterDocument: self.lastAiringSnapshots[weekday]!!)
                .limit(to: documentAmount)
                .getDocuments()
            
            await getAiring(episodesCollection: episodesCollection, weekday: weekday, documentAmount: documentAmount)
            
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
    // TODO: this could be moved to Utils, but is a highly-linked method...
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
