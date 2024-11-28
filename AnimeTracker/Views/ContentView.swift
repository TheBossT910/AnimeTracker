//
//  ContentView.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import SwiftUI

struct ContentView: View {
    //default value of .featured
    @State private var selection: Tab = .animeStatus
    
    enum Tab {
        case animeStatus
        case list
//        case schedule
    }
    
    var body: some View {
        //binding the selection input as a reference to the "selection" variable. Adding the $ makes it into a binding, which allows us to dynamically change the value
        TabView(selection: $selection) {
            CategoriesHome()
                //giving a name and icon, seen in the bottom menu bar
                .tabItem {
                    Label("Anime Status", systemImage: "star")
                }
                //changes the value of "selection" to show this view
                .tag(Tab.animeStatus)
            
            AnimeList()
                //giving a name and icon, seen in the bottom menu bar
                .tabItem {
                    Label("Anime List", systemImage: "list.bullet")
                }
                //changes the value of "selection" to show this view
                .tag(Tab.list)
            
            //TEMPORARY!
//            ScheduleRow(items: AnimeData().animes)
//                .tabItem {
//                    Label("Schedule", systemImage: "calendar")
//                }
//                .tag(Tab.schedule)
        }
    }
}

#Preview {
    ContentView()
        .environment(AnimeData())
}
