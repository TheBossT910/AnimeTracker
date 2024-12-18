//
//  FirebaseTest.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-28.
//

import SwiftUI

import FirebaseFirestore
//import FirebaseFirestoreSwift

struct AnimeFirebase: Identifiable, Decodable {
    //gives a unique id to each item
    //let id = UUID()
    
    //using the unique id of each item in the database as the unique id of each item
    //the ? makes the String type optional
    @DocumentID var id: String?
    let title: String
    let watched: Bool
}


struct FirebaseTest: View {
    @FirestoreQuery(collectionPath: "animeGeneral") var animes: [AnimeFirebase]
    
    //getting a sub collection! -> I had to delete and remake it for some reason
    @FirestoreQuery(collectionPath: "/animeGeneral/AXYHtEVx4zq1UWPdB53t/OshiNoKo") var animes2: [AnimeFirebase]
    
    //can filter our results using predicates
//    @FirestoreQuery(collectionPath: "animeGeneral", predicates: .where(field: "watched", isEqualTo: true)) var animes: [AnimeFirebase]
    
    var body: some View {
        List(animes) {anime in
            Text(anime.title)
        }
        List(animes2) {anime in
            Text(anime.title)
        }
    }
}

#Preview {
    FirebaseTest()
}
