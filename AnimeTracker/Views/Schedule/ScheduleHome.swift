//
//  ScheduleHome.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-27.
//

import SwiftUI

struct ScheduleHome: View {
    @EnvironmentObject var db: Database
    @EnvironmentObject var authManager: AuthManager

    var week = ["Sundays", "Mondays", "Tuesdays", "Wednesdays", "Thursdays", "Fridays", "Saturdays"]
    var currentlyAiringIDs: [String] = ["163134", "164299", "169755"]
    @State private var showFavoritesOnly: Bool = false
    
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
                    
                    HStack {
                        //favorites toggle
                        Toggle(isOn: $showFavoritesOnly) {
                            Text("Show Favorites Only")
                                .font(.subheadline)
                                .fontWeight(.heavy)
                        }
                        .disabled(!authManager.isAuthenticated)
                        // updates toggle so it is "off" when disabled
                        .onChange(of: authManager.isAuthenticated) {
                            if !authManager.isAuthenticated {
                                showFavoritesOnly = false
                            }
                        }
                    }
                    .frame(width: geometry.size.width * 0.80)
                        
                    
                    //allows us to display different pages we can swipbe between
                    TabView {
                        ForEach(week, id: \.self) { day in
                            //wrap ScheduleRow in a container so it is displayed properly by TabView
                            VStack {
                                ScheduleRow(day: day, showFavorites: $showFavoritesOnly)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    //animation when switching between favorites only and all animes view
                    .animation(.default, value: showFavoritesOnly)
                    .tabViewStyle(.page)
                    //height is relative to device height. Explicitly coded so that TabView HAS a height as it was automatically resizing to be really small
                    .frame(width: geometry.size.width * 0.90, height: geometry.size.height / 1.3)
                    
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .padding()
                }
            }
        }
//        .frame(width: 300)
    }
}

#Preview {
    //environment object
    let db = Database()
    let authManager = AuthManager.shared
    
    ScheduleHome()
        .environmentObject(db)
        .environmentObject(authManager)
}
