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
    var week = ["Sundays", "Mondays", "Tuesdays", "Wednesdays", "Thursdays", "Fridays", "Saturdays"]
    
    var body: some View {
        ScrollView {
            Text("Airing Right Now")
            ScheduleAiringRow()
            
            Text("Current Anime Schedule")
            
            //allows us to display different pages we can swipbe between
            TabView {
                ForEach(week, id: \.self) { day in
                    //wrap ScheduleRow in a container so it is displayed properly by TabView
                    VStack {
                        ScheduleRow(day: day)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .tabViewStyle(.page)
            //height is relative to device height. Explicitly coded so that TabView HAS a height as it was automatically resizing to be really small
            .frame(height: UIScreen.main.bounds.height / 1.5)
            .background(Color.gray.opacity(0.1))
            .padding()
        }
    }
}

#Preview {
    //environment object
    var animeDataFB = AnimeDataFirebase(collection: "s1")
    ScheduleHome()
        .environmentObject(animeDataFB)
}
