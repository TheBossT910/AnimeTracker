//
//  CategoryRow.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-08.
//

import SwiftUI

struct CategoryRow: View {
    @EnvironmentObject var db: Database
    @EnvironmentObject var authManager: AuthManager

    var categoryName: String    //holds the name of the category we want to display
    
    var body: some View {
        //grabbing the keys of all animes
        let animeKeys: [Int] = getKeys(category: categoryName)
        
        // only displays if there are shows in the category
        if (animeKeys.count != 0) {
            VStack(alignment: .leading) {
                //displaying the category name
                Text(categoryName)
                    .font(.title2)
                    .fontWeight(.heavy)
                    .padding(.leading, 15)
                    .padding(.top, 20)
                
                //lets us scroll horizontally. showIndicators: false means don't show a scrollbar
                ScrollView(.horizontal, showsIndicators: false) {
                    //putting everything horizontally
                    HStack(alignment: .top, spacing: 0) {
                        //displaying each item
                        ForEach(animeKeys, id: \.self) { animeKey in
                            // link to the details page
                            NavigationLink {
                                AnimeDetail(animeID: String(animeKey))
                            } label: {
                                //image of the anime
                                CategoryItem(animeID: String(animeKey))
                            }
                            // fixes blue highlighted text when used in other views
                            .buttonStyle(.plain)
                        }
                    }
                }
                .frame(height: 350)
            }
        }
    }
    
    // returns an Int array of anime IDs that are in the chosen category
    func getKeys(category: String) -> [Int] {
        var keys: [Int] = []
        
        switch category {
            case "Dropped":
                keys = db.userData?.dropped ?? []
            case "Completed":
                keys = db.userData?.completed ?? []
            case "Watching":
                keys = db.userData?.watching ?? []
            case "Plan to Watch":
                keys = db.userData?.plan_to_watch ?? []
            default:
                keys = []
        }
        
        return keys
    }
}

#Preview {
    //environment object
    let db = Database()
    let authManager = AuthManager.shared
    
    //implemented category names are "Dropped", "Completed", "Watching", "Plan to Watch"
    CategoryRow(categoryName: "Dropped")
        .environmentObject(db)
        .environmentObject(authManager)
}
