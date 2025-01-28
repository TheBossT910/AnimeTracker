//
//  ScheduleRow.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-27.
//

//TODO:
//Add the "top shows" section
//Format/sort by day of the week properly

import SwiftUI

struct ScheduleRow: View {
    @EnvironmentObject var animeDataFB: AnimeDataFirebase  //holds a AnimeDataFirebase object, with Firebase data
    var day: String
    
    var filteredAnimes: [String : [String: Any]] {
        animeDataFB.animes.filter { anime in
            let curGeneral = anime.value["general"] as? general?
            //TODO: Seperate broadcast day and time so we don't have to process the combined String
            //NOTE: curDay has an "s" after every day!
            let curDay = curGeneral??.broadcast?.split(separator: " ")[0]
            return String(curDay ?? "N/A") == day
        }
    }

    var body: some View {
        //grabbing keys of all animes
        let animeKeys = Array(filteredAnimes.keys).sorted()
        
        ScrollView(.vertical) {
            Text(day)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            //default text for when no animes are found
            Text(animeKeys.isEmpty ? "No Animes Found" : "")
                .font(.headline)
            
            //displays each splash image... using normal image for now
            ForEach(animeKeys, id: \.self) { animeKey in
                //grabbing splash image 
                let animeFB = animeDataFB.animes[animeKey]
                let curFiles = animeFB?["files"] as? files?
                let splashImage = curFiles??.splash_image ?? "N/A"
                
                //NavigationLink allows us to navigate to AnimeDetail when clicked (when importing this view into another view)
                NavigationLink {
                    AnimeDetail(animeID: animeKey)
                } label: {
                    ScheduleItem(animeID: animeKey, splashImage: Image(splashImage))
                }
                //fixes the bug where all text is highlighted blue in views that use this view
                .buttonStyle(.plain)
            }
        }

    }
}

#Preview {
    //environment object
    var animeDataFB = AnimeDataFirebase(collection: "s1")
    
    ScheduleRow(day: "Tuesdays")
        .environmentObject(animeDataFB)
}
