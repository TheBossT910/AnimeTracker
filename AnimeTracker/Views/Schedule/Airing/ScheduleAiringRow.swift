//
//  ScheduleAiringRow.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-01-26.
//

import SwiftUI

struct ScheduleAiringRow: View {
    var animeAiringIDs: [String]
    
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
    let db = Database()
    let authManager = AuthManager.shared
    
    let currentlyAiringIDs: [String] = ["163134", "164299", "169755"]
    ScheduleAiringRow(animeAiringIDs: currentlyAiringIDs)
        .environmentObject(db)
        .environmentObject(authManager)
}
