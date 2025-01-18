//
//  ScheduleRow.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-27.
//

//TODO:
//Add the "top shows" section
//Format the day of the week properly

import SwiftUI

struct ScheduleRow: View {
    @EnvironmentObject var animeDataFB: AnimeDataFirebase  //holds a AnimeDataFirebase object, with Firebase data
    var day: String

    var body: some View {
        //grabbing keys of all animes
        let animeKeys = Array(animeDataFB.animes.keys).sorted()
        
        ScrollView(.vertical) {
            Text(day)
                .font(.title)
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
            }
        }

    }
}

#Preview {
    //environment object
    var animeDataFB = AnimeDataFirebase(collection: "s1")
    
    ScheduleRow(day: "Monday")
        .environmentObject(animeDataFB)
}
