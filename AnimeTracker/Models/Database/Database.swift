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
        self.lastAiringSnapshots = ["Sunday": nil, "Monday": nil, "Tuesday": nil, "Wednesday": nil, "Thursday": nil, "Friday": nil, "Saturday": nil]
        self.airingKeys = ["Sunday": [], "Monday": [], "Tuesday": [], "Wednesday": [], "Thursday": [], "Friday": [], "Saturday": []]
        
        // creating a Firestore instance
        self.db = Firestore.firestore()
        
        // running async tasks
        Task {
            await getInitialDocuments(documentAmount: 20)
            // TODO: temporary? remove!
//            await getInitialAiring(weekday: "Tuesday")
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
        // merge previous anime data with new response data
        animeData.merge(response) { (_, new) in new }
        // add to keys array
        orderedKeys = orderedKeys + animeIDs
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
        // add to keys array
        orderedKeys = orderedKeys + animeIDs
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
        // add to keys array
        orderedKeys = orderedKeys + animeIDs
    }
    
    // retrieves user data from database
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
    
    // initially gets airing data
    public func getInitialAiring(date: Int) async {
        let weekday = "Tuesday"
        
        // Example usage to get the Unix range for Tuesday (weekday 3)
        let unixRange = getUnixRangeForWeekday(weekday: date)
        
        // adding ids to set to ensure no duplicates
        var animeIDSet = Set<String>()
        
        do {
            let episodesCollection = try await db.collectionGroup("episodes")
                .whereField("broadcast", isGreaterThanOrEqualTo: Int(unixRange!.start))
                .whereField("broadcast", isLessThanOrEqualTo: Int(unixRange!.end))
                .limit(to: 10)
                .getDocuments()
            
            // going up 2 levels to get the anime collection id
            episodesCollection.documents.forEach { animeIDSet.insert($0.reference.parent.parent?.documentID ?? "") }
            print(animeIDSet.count) // debug
            
            // get shows
            // TODO: don't use this as-is? We could simply add them to the main anime array, and filter by day/time as we are already doing...
            // convert to array
            var animeIDs: [String] = []
            animeIDs = Array(animeIDSet)
            
            let response = await getDocuments(animeIDs: animeIDs)
            print("Num of animes on tuesday today: \(response.count)")
            
            // merge previous anime data with new response data
            animeData.merge(response) { (_, new) in new }
            // add to keys array
            orderedKeys = orderedKeys + animeIDs
            
            // add to airing data
            var currentKeys =  airingKeys["Tuesday"] ?? []
            
            // only add new keys to newKeys array
            var newKeys: [String] = []
            for key in animeIDs {
                if !currentKeys.contains(key) {
                    newKeys.append(key)
                }
            }
            
            // save old + new keys
            airingKeys["Tuesday"] = currentKeys + newKeys
            
            // set last snapshot
            lastAiringSnapshots[weekday] = episodesCollection.documents.last
            
            
        } catch {
            print("error getting initialAiring \(error)")
        }
        
    }
    
    // gets next airing data
    public func getNextAiring(date: Int) async {
        let weekday = "Tuesday"
        
        // Example usage to get the Unix range for Tuesday (weekday 3)
        let unixRange = getUnixRangeForWeekday(weekday: date)
        
        // adding ids to set to ensure no duplicates
        var animeIDSet = Set<String>()
        
        do {
            let episodesCollection = try await db.collectionGroup("episodes")
                .whereField("broadcast", isGreaterThanOrEqualTo: Int(unixRange!.start))
                .whereField("broadcast", isLessThanOrEqualTo: Int(unixRange!.end))
                .start(afterDocument: self.lastAiringSnapshots[weekday]!!)
                .limit(to: 10)
                .getDocuments()
            
            // going up 2 levels to get the anime collection id
            episodesCollection.documents.forEach { animeIDSet.insert($0.reference.parent.parent?.documentID ?? "") }
            print(animeIDSet.count) // debug
            
            // get shows
            // TODO: don't use this as-is? We could simply add them to the main anime array, and filter by day/time as we are already doing...
            // convert to array
            var animeIDs: [String] = []
            animeIDs = Array(animeIDSet)
            
            let response = await getDocuments(animeIDs: animeIDs)
            print("Num of animes on tuesday today: \(response.count)")
            
            // merge previous anime data with new response data
            animeData.merge(response) { (_, new) in new }
            // add to keys array
            orderedKeys = orderedKeys + animeIDs
            
            // add to airing data
            var currentKeys =  airingKeys["Tuesday"] ?? []
            
            // only add new keys to newKeys array
            var newKeys: [String] = []
            for key in animeIDs {
                if !currentKeys.contains(key) {
                    newKeys.append(key)
                }
            }
            
            // save old + new keys
            airingKeys["Tuesday"] = currentKeys + newKeys
            
            // set last snapshot
            lastAiringSnapshots[weekday] = episodesCollection.documents.last
            
            
        } catch {
            print("error getting initialAiring \(error)")
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

func getWeekdayAsNumber(weekday: String) -> Int {
    switch weekday {
        case "Sundays"
            : return 0
        case "Mondays"
            : return 1
        case "Tuesdays"
            : return 2
        case "Wednesdays"
            : return 3
        case "Thursdays"
            : return 4
        case "Fridays"
            : return 5
        case "Saturdays"
            : return 6
        default:
            print("Error! Invalid weekday!")
            return -1
    }
}

// function courtesy of ChatGPT.
// TODO: create your own implementation
// gets the weekday range
// 0 is Sunday, 6 is Saturday
func getUnixRangeForWeekday(weekday: Int) -> (start: TimeInterval, end: TimeInterval)? {
    let calendar = Calendar.current
    let currentDate = Date()
    
    // Get the current weekday
    let currentWeekday = calendar.component(.weekday, from: currentDate) // Sunday = 1, Monday = 2, ..., Saturday = 7
    
    // Calculate the difference in days between current weekday and target weekday
    let dayDifference = (weekday - currentWeekday + 7) % 7 // Ensures that dayDifference is always positive
    
    // Get the current week's weekday at 00:00 (start of the day)
    guard let startOfDay = calendar.date(byAdding: .day, value: dayDifference, to: currentDate) else {
        return nil
    }
    
    let startOfDayAtMidnight = calendar.startOfDay(for: startOfDay) // Midnight (00:00)
    
    // Calculate the end of the day (23:59:59) for the given weekday
    guard let endOfDay = calendar.date(byAdding: .second, value: 86399, to: startOfDayAtMidnight) else {
        return nil
    }
    
    // Convert start and end dates to Unix timestamps
    let startUnix = startOfDayAtMidnight.timeIntervalSince1970
    let endUnix = endOfDay.timeIntervalSince1970
    
    return (start: startUnix, end: endUnix)
}
