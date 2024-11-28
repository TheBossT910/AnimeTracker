//
//  ScheduleRow.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-27.
//

//To-do:
//Add the "top shows" section
//Format the day of the week properly

import SwiftUI

struct ScheduleRow: View {
    var items: [Anime]
    var day: String

    var body: some View {
        ScrollView(.vertical) {
            Text(day)
                .font(.title)
            //displays each splash image... using normal image for now
            ForEach(items, id: \.self) { anime in
                //NavigationLink allows us to navigate to AnimeDetail when clicked (when importing this view into another view)
                NavigationLink {
                    AnimeDetail(anime: anime)
                } label: {
                    ScheduleItem(splashImage: anime.image)
                }
            }
        }

    }
}

#Preview {
    let animes = AnimeData().animes
    ScheduleRow(items: animes, day: "Monday")
}
