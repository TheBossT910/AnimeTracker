//
//  AnimeFirebaseData.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-29.
//

import FirebaseFirestore

class AnimeDataFirebase: ObservableObject {
    //Dictionary to store document data, dictionary in a dictionary
    @Published var docs: [String: [String: Any]]
    var collection: String
    
    // Initialize and fetch data
    init(collection: String) {
        self.collection = collection
        self.docs = [:]
        Task {
            await getDocuments()
        }
    }
    
    //function to retrive all documents from a collection
    func getDocuments() async {
        do {
            let db = Firestore.firestore()
            let query = try await db.collection(collection).getDocuments()
            
            //making an empty dictionary
            var docDict: [String: [String: Any]] = [:]
            
            //adding each document data (value) with key of document id
            query.documents.forEach { document in
                docDict[document.documentID] = document.data()
            }
            //assigning to object variable
            self.docs = docDict
            
        } catch {
            
        }
    }
}
    


// Define your model
struct general: Identifiable, Decodable {
    @DocumentID var id: String?  // Maps Firestore's document ID
    let title: String?
    let watched: Bool?
    let anime: String?
}


