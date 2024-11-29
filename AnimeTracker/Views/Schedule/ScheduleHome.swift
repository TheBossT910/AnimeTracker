//
//  ScheduleHome.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-27.
//

//To-do
//There is a page indictor, but is is not clearly visible. Change its apperance!
//Create the "current schedule" view
//text is blue for some reason... fix!

import SwiftUI

struct ScheduleHome: View {
    @Environment(AnimeData.self) var animeData
    var week = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var body: some View {
        NavigationSplitView {
            Text("Anime Schedule")
            
            Text("Current Schedule")
            
            //allows us to display different pages we can swipbe between
            TabView {
                ForEach(week, id: \.self) { day in
                    //temporarily displaying the same set of data for every day
                    ScheduleRow(items: animeData.animes, day: day)
                }
            }
            .tabViewStyle(.page)
        } detail: {
            Text("Anime Schedule")
        }
    }
}

#Preview {
    ScheduleHome()
        .environment(AnimeData())
}
