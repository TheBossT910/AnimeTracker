//
//  FavoriteButton.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-19.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isSet: Bool
    
    var body: some View {
        Button {
            isSet.toggle()
        } label: {
            Label("Toggle favorite", systemImage: isSet ? "heart.fill" : "heart")
                .labelStyle(.iconOnly)
                .foregroundColor(isSet ? .red : .primary)
        }
    }
}

#Preview {
    FavoriteButton(isSet: .constant(true))
}
