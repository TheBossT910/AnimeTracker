//
//  ScheduleHome.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-27.
//

import SwiftUI
import Foundation

struct ScheduleHome: View {
    @EnvironmentObject var db: Database
    @EnvironmentObject var authManager: AuthManager

    @State private var date = Date()
    var week = ["Sundays", "Mondays", "Tuesdays", "Wednesdays", "Thursdays", "Fridays", "Saturdays"]
    // TODO: look for popular/currently airing shows insted of favorites. This is temporary
    var airing: [String] {
        // getting all favorites
        let userID = authManager.userID ?? ""
        // get all favorites with splash images
        let favWithSplash = db.userData[userID]?.favorites?.filter { fav in
            let currentAnime = db.animeData[String(fav)]
            if (currentAnime?.main?.splash_image != nil) {
                return true
            }
            return false
        }
        
        // getting the first 3 favorites, and converting result to String array
        var favStringArr: [String] = []
        if ((favWithSplash?.count ?? 0) >= 3) {
            let selectFavorites = favWithSplash?[..<3] ?? []
            let favIntArr = Array(selectFavorites)
            favStringArr = favIntArr.map { String($0) }
        }
        
        // return results
        return favStringArr
    }
    @State private var showFavoritesOnly: Bool = false
    
    var body: some View {
        
        GeometryReader { geometry in
            NavigationStack {
                ScrollView {
                    // only displays airing row if we have content to show
                    if (!airing.isEmpty) {
                        Text("Airing Right Now")
                            .font(.title2)
                            .fontWeight(.heavy)
                            .padding(.top)
                        ScheduleAiringRow(animeAiringIDs: airing)
                    }
                    
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
                    
                    // select the week we want to see
                    
                    HStack() {
                        DatePicker(
                            "Week",
                            selection: $date,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.compact)
                        .padding(.leading)
                        .padding(.trailing)
                        .padding(.top, 2)
                    }
                    .frame(width: geometry.size.width * 0.88)
                        
                    
                    //allows us to display different pages we can swipbe between
                    TabView {
                        ForEach(week, id: \.self) { day in
                            //wrap ScheduleRow in a container so it is displayed properly by TabView
                            VStack {
                                ScheduleRow(day: day, showFavorites: $showFavoritesOnly, date: date)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    //animation when switching between favorites only and all animes view
                    .animation(.default, value: showFavoritesOnly)
                    .tabViewStyle(.page)
                    //height is relative to device height. Explicitly coded so that TabView HAS a height as it was automatically resizing to be really small
                    .frame(width: geometry.size.width * 0.90, height: geometry.size.height * 0.90)
                    
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
