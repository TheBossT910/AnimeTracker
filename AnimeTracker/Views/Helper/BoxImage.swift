//
//  BoxImage.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-10-17.
//

import SwiftUI

struct BoxImage: View {
    var image: Image    //holds the image to display
    
    var body: some View {
        VStack {
            image
                //clipping the image to be a rectangle with rounded corners
                .clipShape(RoundedRectangle(cornerRadius: 10))
                //overlaying a rounded rectangle with a white border
                .overlay {
                    RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 5)
                }
                //adding a shadow
                .shadow(radius: 10)
                //moving the image upwards
//                .offset(y: -150)
        }
        .padding()
    }
}

#Preview {
    BoxImage(image: Image("ao_no_hako_box"))
}
