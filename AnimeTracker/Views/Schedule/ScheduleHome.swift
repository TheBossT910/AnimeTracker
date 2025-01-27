//
//  ScheduleHome.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-27.
//

//TODO:
//There is a page indictor, but is is not clearly visible. Change its apperance!
//Create the "current schedule" view
//text is blue for some reason... fix!
//show shows by release day (currently hard-coded, all days show the same data)

import SwiftUI

struct ScheduleHome: View {
    @EnvironmentObject var animeDataFB: AnimeDataFirebase   //holds an AnimeDataFirebase object, with Firebase information
    var week = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var body: some View {
        NavigationSplitView {
            Text("Anime Schedule")
            
            Text("Current Schedule")
            
            //allows us to display different pages we can swipbe between
            TabView {
                ForEach(week, id: \.self) { day in
                    //temporarily displaying the same set of data for every day
                    ScheduleRow(day: day)
                }
            }
            .tabViewStyle(.page)
        } detail: {
            Text("Anime Schedule")
        }
    }
}

#Preview {
    //environment object
    var animeDataFB = AnimeDataFirebase(collection: "s1")
    ScheduleHome()
        .environmentObject(animeDataFB)
}
