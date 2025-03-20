//
//  DatabaseExample.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-02-20.
//

import SwiftUI

struct DatabaseExample: View {
    @ObservedObject var dbTest: Database = Database()
    @StateObject var authManager = AuthManager.shared
    var body: some View {
        let user = authManager.userID ?? ""
//        let user = "hlvTw2YGh1ySqS4eKeEh"
//        let animeID = "107372"  // first show in DB
//        let animeID = "186621"  //last show in DB
        let animeID = "163134"  // ReZero S3
        
        let currentAnime = dbTest.animeData[animeID]
//        let mainDebug = currentAnime?.main.debugDescription ?? "main not found"
//        let dataDebug = currentAnime?.data.debugDescription ?? "data not found"
//        let episodesDebug = currentAnime?.episodes.debugDescription ?? "episodes not found"
        
        let currentUser = dbTest.userData[user]
//        dbTest.updateFavorite(userID: "hlvTw2YGh1ySqS4eKeEh", isFavorite: true, animeID: Int(animeID) ?? -1)
        let favorite: Bool = currentUser?.favorites?.contains(Int(animeID) ?? -1) ?? false
        
        if (currentUser != nil) {
            Button(action: {
                dbTest.updateFavorite(userID: user, isFavorite: !favorite, animeID: Int(animeID) ?? -1)
                print("clicked!")
            }, label: {
                //displaying a filled/unfilled heart depending on if favorite is true/false
                Label("Toggle favorite", systemImage: favorite ? "heart.fill" : "heart")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(favorite ? .red : .primary)
            })
        }
        
//        Text(mainDebug)
//        Spacer()
//        Text(dataDebug)
//        Spacer()
//        Text(episodesDebug)
        
//        let title = currentAnime?.data?.general?.title_english ?? "N/A"
//        Text(title)
        
        // episodes 1 data
        let firstEp = currentAnime?.episodes?.first
        
        let anilist_id = firstEp?.anilist_id
        let tvdb_id = firstEp?.tvdb_id
        let box = firstEp?.box_image
        let broadcast = firstEp?.broadcast
        let desc = firstEp?.description
        let recap = firstEp?.recap
        let runtime = firstEp?.runtime
        let title = firstEp?.title_episode

        
        Text("\(anilist_id ?? 0)")
        Text("\(tvdb_id ?? 0)")
        Text("\(box ?? "N/A")")
        Text("\(broadcast ?? 0)")
        Text("\(desc ?? "N/A")")
        Text("\(recap ?? "N/A")")
        Text("\(runtime ?? 0)")
        Text("\(title ?? "N/A")")
        
        
        // displaying images
        let boxImage = URL(string: currentAnime?.main?.box_image ?? "N/A")
        
        // displaying the box image
        AsyncImage(url: boxImage) { image in
            image
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                //overlaying a rounded rectangle with a white border
                .overlay {
                    RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 5)
                }
                //adding a shadow. Gray on light mode, white on dark mode
                .shadow(color: Color.gray.opacity(0.7), radius: 10)
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
        } placeholder: {
            Color.blue
            .frame(width: 150, height: 212)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            //overlaying a rounded rectangle with a white border
            .overlay {
                RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 5)
            }
            //adding a shadow. Gray on light mode, white on dark mode
            .shadow(color: Color.gray.opacity(0.7), radius: 10)
        }
        
        // displaying the splash image
        let splashImage = URL(string: currentAnime?.main?.splash_image ?? "N/A")
        
        AsyncImage(url: splashImage) { image in
            image
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                //overlaying a rounded rectangle with a white border
                .overlay {
                    RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 5)
                }
                //adding a shadow. Gray on light mode, white on dark mode
                .shadow(color: Color.gray.opacity(0.7), radius: 10)
                .aspectRatio(contentMode: .fit)
                .frame(height: 80)
        } placeholder: {
            Color.blue
            .frame(width: 150, height: 212)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            //overlaying a rounded rectangle with a white border
            .overlay {
                RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 5)
            }
            //adding a shadow. Gray on light mode, white on dark mode
            .shadow(color: Color.gray.opacity(0.7), radius: 10)
        }
    }
}

#Preview {
    DatabaseExample()
}
