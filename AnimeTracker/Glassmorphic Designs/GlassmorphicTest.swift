//
//  GlassmorphicTest.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2025-03-08.
//

import SwiftUI

struct GlassmorphicTest: View {
    var body: some View {
        ZStack {
            // creating a color gradient
            Rectangle()
                .fill(
                    .linearGradient(
                        colors: [Color(red: 1, green: 0.8705882352941177, blue: 0.9137254901960784), Color(red: 0.7098039215686275, green: 1, blue: 0.9882352941176471)],
                        startPoint: .top,
                        endPoint: .bottom
                        )
                    )
            
            // random item to test card's effect
            Circle()
                .fill(Color.blue.opacity(0.7))
            
            // glassmorphic card
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.5))
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(.gray.opacity(0.3), lineWidth: 20)
                        .blur(radius: 5)
                }
                .frame(width:300, height: 500)
                .background(.thinMaterial.opacity(0.90))
//                .shadow(color: Color.gray.opacity(0.3), radius: 5)
            
            // text on card. We will have to import as ZStack and have text within a second shape of the same size in order to make it look correct
            Text("Hello, World!")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .padding()
            
        }
        .ignoresSafeArea()

    }
}

#Preview {
    GlassmorphicTest()
}
