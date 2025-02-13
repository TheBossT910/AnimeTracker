//
//  ScheduleHome.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-27.
//

import SwiftUI

struct ScheduleHome: View {
    @EnvironmentObject var animeDataFB: AnimeDataFirebase   //holds an AnimeDataFirebase object, with Firebase information
    var week = ["Sundays", "Mondays", "Tuesdays", "Wednesdays", "Thursdays", "Fridays", "Saturdays"]
    var currentlyAiringIDs: [String] = ["6KaHVRxICvkkrRYsDiMY", "eqIKQyLZ7eMe8GmMOB6O", "323Prp20ZeyevdQQcyl9"]
    // TODO: Bocchi the Rock! (the last item) was accidently deleted off of Firebase, which is why it displays nothing for the last item!!
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ScrollView {
                    Text("Airing Right Now")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .padding(.top)
                    ScheduleAiringRow(animeAiringIDs: currentlyAiringIDs)
                    
                    Text("My Anime Schedule")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .padding(.top)
                        
                    
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
                    .frame(height: geometry.size.height / 1.3)
                    
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .padding()
                }
            }
        }
    }
}

#Preview {
    //environment object
    var animeDataFB = AnimeDataFirebase(collection: "s1")
    ScheduleHome()
        .environmentObject(animeDataFB)
}
