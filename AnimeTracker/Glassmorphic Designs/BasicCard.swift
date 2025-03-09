//
//  BasicCard.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-03-08.
//

import SwiftUI

struct BasicCard: View {
    
    // default values
    var width: CGFloat = 300
    var height: CGFloat = 500
    var radius: CGFloat = 20
    
    var body: some View {
        // glassmorphic card
        RoundedRectangle(cornerRadius: radius, style: .continuous)
            .fill(Color.white.opacity(0.5))
            .background {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(.gray.opacity(0.3), lineWidth: 15)
                    .blur(radius: radius / 2)
            }
            .background(.thinMaterial.opacity(0.90))
            .frame(width: width, height: height)
            // TODO: This is causing user to see rectange corners

//            .shadow(color: Color.gray.opacity(0.3), radius: 5)
    }
}

#Preview {
    BasicCard(width: 300, height: 500, radius: 20)
}
