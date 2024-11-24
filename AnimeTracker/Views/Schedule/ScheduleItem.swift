//
//  ScheduleItem.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-23.
//

import SwiftUI

struct ScheduleItem: View {
    var splashImage: Image {
        Image("oshi_no_ko_splash")
    }
    
    
    var body: some View {
        HStack(alignment: .bottom) {
            //roatating the time vertically
            GeometryReader { geometry in
                Text("9:00 am")
                    .rotationEffect(.degrees(-90), anchor: .topLeading)
                    //assigning the height and width of the Geometry reader as the vice versa for the text frame
                    .frame(width: geometry.size.height, height: geometry.size.width, alignment: .leading)
            }
            //setting thr height/width of GeometryReader. Aligns the position of the text within the HStack
            .frame(width: 20, height: 95)
            

            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    //main image
                    splashImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 211.2, height: 100)
                        .clipped()
                    
                    VStack(alignment: .leading) {
                        Text("Oshi no Ko: S2")
                            .font(.title3)
                        HStack {
                            //temporary fake checkmark. Plan to implement real "marking" system later
                            Text("☑")
                            Text("Ep 8: 迷う")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        Text("Watch Now")
                        Spacer()
                    }
                    .frame(height: 100)
                    
                }
                .fixedSize(horizontal: true, vertical: false)
                .frame(width: 350)
                Text("Recap: Aqua shines in the Tokyo Blade play, channeling his pain into a powerful performance while reflecting on Ai's tragic past. A vivid scene imagines a world where Ai survives, adding emotional depth and fueling Aqua's drive for answers")
                    .font(.caption)

            }
            //limiting the height of the frame
            //        .frame(height: 200)
        }
        
    }
}

#Preview {
    ScheduleItem()
}
