//
//  AnimeFirebaseData.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-29.
//

import FirebaseFirestore

class AnimeDataFirebase: ObservableObject {
    //Dictionary to store document data, dictionary in a dictionary
    @Published var docs: [String]
    @Published var animes: [String: [String: Any]]
    private var collection: String
    
    // Initialize and fetch data
    init(collection: String) {
        self.docs = []
        self.animes = [:]
        self.collection = collection
        Task {
            await getDocuments()
            await getAnimes(collection: self.collection)
        }
    }
    
    //function to retrive all documents from a collection
    func getDocuments() async {
        do {
            let db = Firestore.firestore()
            let query = try await db.collection("/animes/").getDocuments()
            
            //making an empty dictionary
            var docArr: [String] = []
            
            //for each document in Anime
            query.documents.forEach { document in
                docArr.append(document.documentID)
            }
            //assigning to object variable
            self.docs = docArr
            
        } catch {
            
        }
    }
        
    func getAnimes(collection: String) async {
            let db = Firestore.firestore()
            var innerDocDict: [String: Any] = [:]
        
            //going through each document for an anime collection
            for document in docs {
                do {
                    //fetching a collection
                    let innerQuery = try await db.collection("/animes/\(document)/\(collection)").getDocuments()
                    //structuring the data
                     innerQuery.documents.forEach { innerDoc in
                        let raw = innerDoc.data()
                         let generalObj = structureData(docID: innerDoc.documentID, raw: raw)
                        innerDocDict[innerDoc.documentID] = generalObj
                        
                    }
                    self.animes[document] = innerDocDict
                    
                } catch {
                    
                }
            }
        }
    
    func structureData(docID: String, raw: [String: Any]) -> Any {
        //Returns an object created using the appropriate struct
        switch docID {
        case "general":
            let engTitle = raw["engTitle"] as? String
            let jpnTitle = raw["jpnTitle"] as? String
            let episodes = raw["episodes"] as? Int
            let broadcast = raw["broadcast"] as? String
            let premiere = raw["premiere"] as? String
            let rating = raw["rating"] as? String
            let categoryStatus = raw["categoryStatus"] as? String
            let isFavorite = raw["isFavorite"] as? Bool
            let isRecommended = raw["isRecommended"] as? Bool
            let obj = general(
                engTitle: engTitle,
                jpTitle: jpnTitle,
                episodes: episodes,
                broadcast: broadcast,
                premiere: premiere,
                rating: rating,
                categoryStatus: categoryStatus,
                isFavorite: isFavorite,
                isRecommended: isRecommended)
            return obj
            
        case "description":
            let anime = raw["anime"] as? String
            let episodes = raw["episodes"] as? [String: String]
            let obj = description(anime: anime, episodes: episodes)
            return obj
        
        case "files":
            let boxImage = raw["boxImage"] as? String
            let splashImage = raw["splashImage"] as? String
            let obj = files(boxImage: boxImage, splashImage: splashImage)
            return obj
            
        case "recap":
            let recapInfo = raw["recap"] as? [String: String]
            let obj = recap(recap: recapInfo)
            return obj
            
        case "media":
            //TODO: get movies, etc. other medias as well. Currently hard-coded to only get episodes!
            let episodeInfo = raw["episodes"] as? [String: [String: String]]
            let episodes = fetchMediaInfo(media: episodeInfo!)
            
            let movieInfo = raw["movies"] as? [String: [String: String]]
            let movies = fetchMediaInfo(media: movieInfo!)
            
            let obj = media(episodes: episodes, movies: movies)
            return obj
            
        default:
            let obj = defaultStruct(data: nil)
            return obj
        }
    }
    
    //get/format data for "media" in Firebase
    func fetchMediaInfo(media: [String: [String: String]]) -> [String: mediaContent] {
        var dict: [String: mediaContent] = [:]
        
        //look at each episode
        for item in media {
            //get each episode
            let episode = item.value
            let key = item.key
            
            //get their data
            let airDay = episode["air_day"]
            let airTime = episode["air_time"]
            let description = episode["description"]
            let nameJP = episode["name_jp"]
            let nameEng = episode["name_eng"]
            let recap = episode["recap"]
            
            //create an object with this data, and add to a dictionary with key (episode number) and value (episode object)
            let innerObj = mediaContent(air_day: airDay, air_time: airTime, description: description, name_eng: nameEng, name_jp: nameJP, recap: recap)
            dict[key] = innerObj
        }
        
        return dict
    
    }
}


//structs for general, files, description, recap documents in each anime's collection
struct general: Identifiable, Decodable {
    @DocumentID var id: String?
    let engTitle: String?
    let jpTitle: String?
    let episodes: Int?
    let broadcast: String?
    let premiere: String?
    let rating: String?
    let categoryStatus: String?
    let isFavorite: Bool?
    let isRecommended: Bool?

}

struct files: Identifiable, Decodable {
    @DocumentID var id: String?
    let boxImage: String?
    let splashImage: String?
}
//TODO: Delete this -> deprecated. Using media now!
struct description: Identifiable, Decodable {
    @DocumentID var id: String?
    let anime: String?
    let episodes: [String: String]?
}

//TODO: Still need to properly set up recap on Firebase -> we are deleting this
struct recap: Identifiable, Decodable {
    @DocumentID var id: String?
    let recap: [String: String]?
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
