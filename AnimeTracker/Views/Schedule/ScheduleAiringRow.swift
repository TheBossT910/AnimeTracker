//
//  ScheduleAiringRow.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-01-26.
//

import SwiftUI

struct ScheduleAiringRow: View {
    @EnvironmentObject var animeDataFB: AnimeDataFirebase   //stores an object to hold Firebase data
    //Oshi no Ko, Attack on Titan, Boochi the Rock!
    var animeAiringIDs: [String] = ["6KaHVRxICvkkrRYsDiMY", "eqIKQyLZ7eMe8GmMOB6O", "323Prp20ZeyevdQQcyl9"]
    
    var body: some View {
        ForEach (animeAiringIDs, id: \.self) { animeAiringID in
            NavigationLink {
                AnimeDetail(animeID: animeAiringID)
            } label: {
                ScheduleAiringItem(animeID: animeAiringID)
            }
        }
    }
}

#Preview {
    //environment object
    let animeDataFB = AnimeDataFirebase(collection: "s1")
    ScheduleAiringRow()
        .environmentObject(animeDataFB)
}
