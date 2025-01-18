//
//  ScheduleItem.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-23.
//

//TODO: make it so that each data value (time, summary, title, episode name) is connected to each show/episode. It is hard-coded right now! -> Database?!

import SwiftUI

struct ScheduleItem: View {
    @EnvironmentObject var animeDataFB: AnimeDataFirebase   //object of AnimeDataFirebase, holds Firebase data
    let animeID: String //currently selected anime's iD
    var splashImage: Image  //holds image to be displayed
    
    var body: some View {
        //getting Firebase data objects
        let animeFB = animeDataFB.animes[animeID]
        let animeGeneral = animeFB?["general"] as? general
        let animeFiles = animeFB?["files"] as? files
        let animeMedia = animeFB?["media"] as? media
        
        //getting specific data
        let animeSplash = animeFiles?.splash_image ?? "N/A"
        //TODO: Figure out a way to know what episode data to show automaticaly. This is hard-coded to only show episode 1 for all shows!
        let animeEp1 = animeMedia?.episodes?["1"] as? mediaContent
        
        HStack(alignment: .bottom) {
            //roatating the time vertically
            GeometryReader { geometry in
                Text(animeEp1?.air_time ?? "N/A")
                    .rotationEffect(.degrees(-90), anchor: .topLeading)
                    //assigning the height and width of the Geometry reader as the vice versa for the text frame
                    .frame(width: geometry.size.height, height: geometry.size.width, alignment: .leading)
            }
            //setting thr height/width of GeometryReader. Aligns the position of the text within the HStack
            .frame(width: 20, height: 95)
            
            
            VStack(alignment: .leading) {
                //TODO: check if we even need this .top alignemnt
                HStack(alignment: .top) {
                    //main image
                    Image(animeSplash)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 211.2, height: 100)
                        .clipped()
                    
                    VStack(alignment: .leading) {
                        //TODO: The title being different lengths messes with the picture alignment
                        Text("\(animeGeneral?.title_eng ?? "N/A"): S1")
                            .font(.title3)
                        HStack {
                            //temporary fake checkmark. Plan to implement real "marking" system later
                            Text("☑")
                            Text("Ep 1: \(animeEp1?.name_jp ?? "N/A")")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        Text("Watch Now")
                        Spacer()
                    }
                    .frame(height: 100)
                    
                }
                .fixedSize(horizontal: true, vertical: false)
                //.leading aligns HStack to left side
                .frame(width: 350, alignment: .leading)
                Text(animeEp1?.recap ?? "N/A")
                    .font(.caption)
                    //explicitly leading so it shows us correctly in ScheduleRow
                    .multilineTextAlignment(.leading)

            }
            //limiting the height of the frame
            //        .frame(height: 200)
        }
        //explicit properties so it shows us correctly in ScheduleRow
        .padding(.bottom)
        .foregroundStyle(.primary)

        
    }
}

#Preview {
    //environment object
    var animeDataFB = AnimeDataFirebase(collection: "s1")
    ScheduleItem(animeID: "6KaHVRxICvkkrRYsDiMY", splashImage: Image("oshi_no_ko_splash"))
        .environmentObject(animeDataFB)
}
