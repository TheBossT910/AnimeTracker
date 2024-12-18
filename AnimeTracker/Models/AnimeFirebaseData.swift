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
    @Published var animes: [String: [String: general]]
    
    // Initialize and fetch data
    init() {
        self.docs = []
        self.animes = [:]
        Task {
            await getDocuments()
            await getAnimes()
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
        
        func getAnimes() async {
            let db = Firestore.firestore()
            var innerDocDict: [String: general] = [:]
            for document in docs {
                do {
                    let innerQuery = try await db.collection("/animes/\(document)/s1").getDocuments()
                    try innerQuery.documents.forEach { innerDoc in
                        innerDocDict[innerDoc.documentID] = try innerDoc.data(as: general.self)
                    }
                    self.animes[document] = innerDocDict
                    
                } catch {
                    
                }
            }
        }
    }

//TODO: create different structs for each specific type of document in Firebase
struct general: Identifiable, Decodable {
    @DocumentID var id: String?  // Maps Firestore's document ID
    let title: String?
    let watched: Bool?
    let anime: String?
    let engTitle: String?
}
