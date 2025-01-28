//
//  ScheduleAiringItem.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-01-26.
//

//displays currently airing shows
//we want a show's icon, a show's splash, and its air time
//we want air time to compare to current time, and appropriately create the "load"/watch bar

import SwiftUI

struct ScheduleAiringItem: View {
    @EnvironmentObject var animeDataFB: AnimeDataFirebase   //stores an object to hold Firebase data
    var animeID: String
    //TODO: fetch time properly
    var time: String = "23:00(JST)"
    //TODO: implement show play bar properly (ratio of total air time/ width * already aired time). Currently hard-coded and won't work for different screen sizes, etc.
    var playLocation: CGFloat = 150
    
    var body: some View {
        //getting current anime data
        let animeFB = animeDataFB.animes[animeID]
//        let animeGeneral = animeFB?["general"] as? general
        let animeFiles = animeFB?["files"] as? files
        
        //getting specific variables we want to use
        let splash = animeFiles?.splash_image ?? "N/A"
        let icon = animeFiles?.icon ?? "N/A"
        //TODO: split time into a seperate var in Firebase. This is temporary!
        //Not implemented yet
//        let broadcastTime = animeGeneral?.broadcast?.split(separator: " ")[1]
        
        ZStack {
            //splash image. The main image
            Image(splash)
                .resizable()
                .scaledToFill()
                .frame(height: 100)
                .clipped()
                .padding()
                .overlay(alignment: .bottom) {
                    //loading/airing bar
                    Rectangle()
                        .frame(height: 10)
                        .opacity(0.5)
                        //TODO: implement in the future that the color changes from green/orange/red depending on currently airing, ending, finished airing
                        .foregroundStyle(.green)
                        .padding()
                    
                        .overlay(alignment: .leading) {
                            //"location" of show (the air bar)
                            GeometryReader { geometry in
                                //black bar over the green translucent bar for the already-aired times
                                Rectangle()
                                    .frame(width: geometry.size.width - playLocation)
                                    .foregroundStyle(.black)
                                    .opacity(0.4)
                                //red bar indicating current air position
                                Rectangle()
                                    .frame(width: geometry.size.width - playLocation, height: 3)
                                    .foregroundStyle(.red)
                            }
                            //padding that allows geometry reader width to be contained within the splash image
                            .padding()
                        }
                }
            
            //logo
            HStack {
                //TODO: add icon file path in Firebase
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 30)
                    .clipped()
                    .padding()  //allows for the blur to go around the logo
                    .background(.ultraThinMaterial) //creates a blur effect

                Spacer()
                
                //TODO: Implement proper checkmark system
                Text("☑")
                    .font(.system(size: 30, weight: .bold, design: .default))
                    //It is green to show that we have watched it. This is hard-coded to be green.
                    //I think I should use green and orange colors to indicate watched/not watched
                    .foregroundStyle(.green)
                    .padding()
            }
            .padding()
        }
        
    }
}

#Preview {
    //environment object
    let animeDataFB = AnimeDataFirebase(collection: "s1")
    ScheduleAiringItem(animeID: "6KaHVRxICvkkrRYsDiMY")
        .environmentObject(animeDataFB)
}
