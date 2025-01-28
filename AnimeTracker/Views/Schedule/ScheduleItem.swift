//
//  ScheduleItem.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-23.
//

//TODO: make it so that each data value (time, summary, title, episode name) is connected to each show/episode. It is hard-coded right now! -> Database?!

import SwiftUI

struct ScheduleItem: View {
    @EnvironmentObject var animeDataFB: AnimeDataFirebase  //object of AnimeDataFirebase, holds Firebase data
    let animeID: String  //currently selected anime's iD
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
            VStack(alignment: .leading) {
                //TODO: check if we even need this .top alignemnt
                HStack(alignment: .top) {
                    //main image
                    Image(animeSplash)
                        .resizable()
                        .scaledToFill()
                        //trying to make the image dynamically size
                        .frame(
                            minWidth: 211.2, maxWidth: .infinity,
                            minHeight: 100, maxHeight: 130
                        )
                        .clipped()

                    VStack(alignment: .leading) {
                        //I am embedding the text items in HStacks to horizontally center the text
                        HStack(alignment: .top) {
                            //TODO: The episode name being different lengths messes/breaks the picture alignment. Fix!
                            Spacer()
                            Text("Ep 1: \(animeEp1?.name_jp ?? "N/A")")
                                .font(.title3)
                                //allows for text wrapping
                                .fontWeight(.medium)
                                .fixedSize(horizontal: false, vertical: true)
                                //limits the number of lines we can display so it doesn't break out of position
                                .lineLimit(3)
                            Spacer()
                        }

                        Spacer()

                        HStack {
                            //TODO: Make this a button that leads to service providers
                            Spacer()
                            Text("Watch Now")
                                //allows for text wrapping
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }

                        Spacer()

                        HStack {
                            //TODO: temporary fake checkmark. Plan to implement real "marking" system later
                            Text("☑")
                            Spacer()
                            Text(animeEp1?.air_time ?? "N/A")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }

                        Spacer()

                    }
                    //match the sizing to the splash image sizing so the whole card stays the same dimmensions
                    .frame(maxWidth: .infinity, minHeight: 100, maxHeight: 130)

                }
                //.leading aligns HStack to left side
                .frame(alignment: .leading)
                DisclosureGroup("**\(animeGeneral?.title_eng ?? "N/A"): S1**") {
                    Text(animeEp1?.recap ?? "N/A")
                        .font(.caption)
                        //explicitly set text to leading so it displays correctly in ScheduleRow
                        .multilineTextAlignment(.leading)
                }

            }
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
    //HgChfzTmhx1Fxiw6XbWq  //Death Note
    ScheduleItem(
        animeID: "HgChfzTmhx1Fxiw6XbWq", splashImage: Image("oshi_no_ko_splash")
    )
    .environmentObject(animeDataFB)
}
