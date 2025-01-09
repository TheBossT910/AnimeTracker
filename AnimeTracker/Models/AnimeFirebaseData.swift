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
    private var db: Firestore
    
    // Initialize and fetch data
    init(collection: String) {
        self.docs = []
        self.animes = [:]
        self.collection = collection
        self.db = Firestore.firestore()
        Task {
            await getDocuments()
            await getAnimes(collection: self.collection)
        }
    }
    
    //function to retrive all documents from a collection
    func getDocuments() async {
        do {
            let query = try await self.db.collection("/animes/").getDocuments()
            
            //making an empty dictionary
            var docArr: [String] = []
            
            //for each document in Anime
            query.documents.forEach { document in
                docArr.append(document.documentID)
            }
            //assigning to object variable
            self.docs = docArr
            
        } catch {
            print("Error fetching documents: \(error.localizedDescription)")
        }
    }
        
    func getAnimes(collection: String) async {
            var innerDocDict: [String: Any] = [:]
        
            //going through each document for an anime collection
            for document in self.docs {
                do {
                    //fetching a collection
                    let innerQuery = try await self.db.collection("/animes/\(document)/\(collection)").getDocuments()
                    //structuring the data
                     innerQuery.documents.forEach { innerDoc in
                        let raw = innerDoc.data()
                         let generalObj = structureData(docID: innerDoc.documentID, raw: raw)
                        innerDocDict[innerDoc.documentID] = generalObj
                        
                    }
                    //appending data to dictionary
                    self.animes[document] = innerDocDict
                    
                } catch {
                    
                }
            }
        }
    
    func structureData(docID: String, raw: [String: Any]) -> Any {
        //Returns an object created using the appropriate struct
        switch docID {
        case "general":
            let broadcast = raw["broadcast"] as? String
            let categoryStatus = raw["category_status"] as? String
            let description = raw["description"] as? String
            let titleEng = raw["title_eng"] as? String
            let titleJp = raw["title_jp"] as? String
            let episodes = raw["episodes"] as? Int
            let isFavorite = raw["isFavorite"] as? Bool
            let isRecommended = raw["isRecommended"] as? Bool
            let premiere = raw["premiere"] as? String
            let rating = raw["rating"] as? String
            
            let obj = general(
                broadcast: broadcast,
                category_status: categoryStatus,
                description: description,
                title_eng: titleEng,
                title_jp: titleJp,
                episodes: episodes,
                isFavorite: isFavorite,
                isRecommended: isRecommended,
                premiere: premiere,
                rating: rating
            )
            return obj
            
        
        case "files":
            let boxImage = raw["box_image"] as? String
            let splashImage = raw["splash_image"] as? String
            let docIDAnime = raw["doc_id_anime"] as? String
            let obj = files(box_image: boxImage, splash_image: splashImage, doc_id_anime: docIDAnime)
            return obj
            
        case "media":
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
    
    //updates data in Firebase
    //animeDocumentID is the anime, updateDocument is the general/files/media sections
    func updateData(animeDocumentID: String, updateDocument: String, updateItems: [String: Any]) {
        //get the requested Anime document, where we want to update the data
        let query = self.db
            .collection("/animes/")
            .document(animeDocumentID)
            .collection("/s1")
            .document(updateDocument)
        //update the fields
        query.updateData(updateItems)
        
        //TODO: make this work with isRecommended in the future, and clean up the code!
        //now, lets update our currently stored data
//        var oldObj = self.animes[animeDocumentID]?["general"] as? general
//        print("before: \(oldObj?.isFavorite)")
//        oldObj?.isFavorite = updateItems["isFavorite"] as? Bool
//        self.animes[animeDocumentID]?["general"] = oldObj
//        print("after: \(oldObj?.isFavorite)")
        
//        let newObj = general(broadcast: oldObj?.broadcast, category_status: oldObj?.category_status, description: oldObj?.description, title_eng: oldObj?.title_eng, title_jp: oldObj?.title_jp, episodes: oldObj?.episodes, isFavorite: updateItems["isFavorite"] as? Bool, isRecommended: oldObj?.isRecommended, premiere: oldObj?.premiere, rating: oldObj?.rating)
//        self.animes[animeDocumentID]?["general"] = newObj
        
//        //debug
//        var temp = self.animes[animeDocumentID]?["general"] as? general
//        print("from here: \(updateItems["isFavorite"] as? Bool))")
//        print("from here: \(temp?.isFavorite ?? false)")

        }
}


//structs for general, files, description, recap documents in each anime's collection
struct general: Identifiable, Decodable {
    @DocumentID var id: String?
    let broadcast: String?
    let category_status: String?
    let description: String?
    let title_eng: String?
    let title_jp: String?
    let episodes: Int?
    var isFavorite: Bool?
    let isRecommended: Bool?
    let premiere: String?
    let rating: String?

}

struct files: Identifiable, Decodable {
    @DocumentID var id: String?
    let box_image: String?
    let splash_image: String?
    let doc_id_anime: String?
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
