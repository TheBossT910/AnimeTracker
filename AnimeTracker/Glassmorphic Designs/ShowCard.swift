//
//  ShowCard.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-03-08.
//

import SwiftUI

struct ShowCard: View {
    var width: CGFloat = 168
    var height: CGFloat = 276
    
    var body: some View {
        ZStack {
            BasicCard(width: width, height: height, radius: 12)
            VStack(alignment: .center) {
                Spacer()
    
                VStack(alignment: .leading) {
                    // title
                    Spacer()
                    Text("SOLO LEVELING: REAWAKENED")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                // buttons
                HStack(alignment: .top) {
                    // details button
                    BasicCard(width: 70, height: 31, radius: 5)
                    // watch now button
                    BasicCard(width: 70, height: 57, radius: 10)
                }
                .padding()
            }
            .frame(width: width, height: height)
        }
        
    }
}

#Preview {
    ShowCard()
}
