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
        case schedule
        case profile
    }
    
    var body: some View {
        //binding the selection input as a reference to the "selection" variable. Adding the $ makes it into a binding, which allows us to dynamically change the value
        TabView(selection: $selection) {
            CategoriesHome()
                //giving a name and icon, seen in the bottom menu bar
                .tabItem {
                    Label("Status", systemImage: "star")
                }
                //changes the value of "selection" to show this view
                .tag(Tab.animeStatus)
            
            AnimeList()
                //giving a name and icon, seen in the bottom menu bar
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
                //changes the value of "selection" to show this view
                .tag(Tab.list)
            
            ScheduleHome()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
                .tag(Tab.schedule)
            AuthView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }
                .tag(Tab.profile)
        }
    }
}

#Preview {
    //environment objects
    let db = Database()
    let authManager = AuthManager.shared
    
    ContentView()
        .environmentObject(db)
        .environmentObject(authManager)
}
