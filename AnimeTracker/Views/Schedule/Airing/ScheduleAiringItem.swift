//
//  ScheduleAiringItem.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-01-26.
//

import SwiftUI

struct ScheduleAiringItem: View {
    @EnvironmentObject var db: Database
    @EnvironmentObject var authManager: AuthManager
    
    var animeID: String
    //TODO: fetch time properly
    var time: String = "23:00(JST)"
    //TODO: implement show play bar properly (ratio of total air time/ width * already aired time). Currently hard-coded and won't work for different screen sizes, etc.
    var playLocation: CGFloat = 150
    
    var body: some View {
        //getting current anime data
        let anime = db.animeData[animeID]
        let animeMain = anime?.main
        
        //getting specific variables we want to use
        let splash = URL(string: animeMain?.splash_image ?? "N/A")

        //TODO: split time into a seperate var in Firebase. This is temporary!
        //Not implemented yet
//        let broadcastTime = animeGeneral?.broadcast?.split(separator: " ")[1]
        
        ZStack {
            //splash image. The main image
            AsyncImage(url: splash) { image in
                image
                .resizable()
                .scaledToFill()
                .frame(height: 120)
                .clipped()
                .padding()
                // TODO: implement airing bar
//                .overlay(alignment: .bottom) {
//                    //loading/airing bar
//                    Rectangle()
//                        .frame(height: 10)
//                        .opacity(0.5)
//                        //TODO: implement in the future that the color changes from green/orange/red depending on currently airing, ending, finished airing
//                        .foregroundStyle(.green)
//                        .padding()
//                    
//                        .overlay(alignment: .leading) {
//                            //"location" of show (the air bar)
//                            GeometryReader { geometry in
//                                //black bar over the green translucent bar for the already-aired times
//                                Rectangle()
//                                    .frame(width: geometry.size.width - playLocation)
//                                    .foregroundStyle(.black)
//                                    .opacity(0.4)
//                                //red bar indicating current air position
//                                Rectangle()
//                                    .frame(width: geometry.size.width - playLocation, height: 3)
//                                    .foregroundStyle(.red)
//                            }
//                            //padding that allows geometry reader width to be contained within the splash image
//                            .padding()
//                        }
//                    }
            } placeholder: {
                Color.gray
                    .frame(height: 120)
            }
            
            //TODO: Implement proper checkmark system
//            // completion checkmark
//            Text("☑")
//                .font(.system(size: 30, weight: .bold, design: .default))
//                //It is green to show that we have watched it. This is hard-coded to be green.
//                //I think I should use green and orange colors to indicate watched/not watched
//                .foregroundStyle(.green)
//                .padding()
        }
    }
}

#Preview {
    //environment object
    let db = Database()
    let authManager = AuthManager.shared
    
    //"163134" is ReZero
    ScheduleAiringItem(animeID: "163134")
        .environmentObject(db)
        .environmentObject(authManager)
}
