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
//            GeometryReader { geometry in
//                Text(animeEp1?.air_time ?? "N/A")
//                    .rotationEffect(.degrees(-90), anchor: .topLeading)
//                    //assigning the height and width of the Geometry reader as the vice versa for the text frame
//                    .frame(width: geometry.size.height, height: geometry.size.width, alignment: .leading)
//            }
//            //setting thr height/width of GeometryReader. Aligns the position of the text within the HStack
//            .frame(width: 20, height: 95)
            
            
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
                        //I am embedding the text items in HStacks to horizontally center the text
                        HStack {
                            //TODO: The episode name being different lengths messes/breaks the picture alignment. Fix!
                            Spacer()
                            Text("Ep 1: \(animeEp1?.name_jp ?? "N/A")")
                                .font(.title3)
                                //allows for text wrapping
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack {
                            //TODO: Make this a button that leads to service providers
                            Spacer()
                            Text("Watch Now")
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack {
                            //TODO: temporary fake checkmark. Plan to implement real "marking" system later
                            Text("☑")
                            Spacer()
                            Text(animeEp1?.air_time ?? "N/A")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: 100);
                    
                }
                //.leading aligns HStack to left side
                .frame(alignment: .leading)   //temp comment out
                DisclosureGroup("\(animeGeneral?.title_eng ?? "N/A"): S1") {
                    Text(animeEp1?.recap ?? "N/A")
                        .font(.caption)
                    //explicitly set text to leading so it displays correctly in ScheduleRow
                        .multilineTextAlignment(.leading)
                }

            }
            //limiting the height of the frame
                    .frame(height: 200)
        }
        //explicit properties so it shows us correctly in ScheduleRow
        .padding()
        .foregroundStyle(.primary)

        
    }
}

#Preview {
    //environment object
    var animeDataFB = AnimeDataFirebase(collection: "s1")
    //OZtFGA9sVtdxtOCZZTEw  //Spy x Family
    //6KaHVRxICvkkrRYsDiMY  //Oshi no Ko
    ScheduleItem(animeID: "6KaHVRxICvkkrRYsDiMY", splashImage: Image("oshi_no_ko_splash"))
        .environmentObject(animeDataFB)
}
