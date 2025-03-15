//
//  ScheduleItem.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-23.
//

import SwiftUI

struct ScheduleItem: View {
    @EnvironmentObject var db: Database
    @EnvironmentObject var authManager: AuthManager

    let animeID: String  //currently selected anime's iD

    var body: some View {
        //getting anime data
        let anime = db.animeNew[animeID]
        let animeGeneral = anime?.data?.general
        let animeFiles = anime?.data?.files
        let animeMedia = anime?.episodes

        //getting specific data
        //TODO: Figure out a way to know what episode data to show automaticaly. This is hard-coded to only show episode 1 for all shows!
        let animeEp1 = animeMedia?[0]
        let animeSplash = URL(string: animeEp1?.box_image ?? "N/A")


        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                //TODO: check if we even need this .top alignemnt
                HStack(alignment: .top) {
                    //main image
                    AsyncImage(url: animeSplash) { image in
                        image.image?
                        .resizable()
                        .scaledToFill()
                        //trying to make the image dynamically size
                        .frame(
                            minWidth: 211.2, maxWidth: .infinity,
                            minHeight: 100, maxHeight: 130
                        )
                        .clipped()
                    }

                    VStack(alignment: .leading) {
                        //I am embedding the text items in HStacks to horizontally center the text
                        HStack(alignment: .top) {
                            Spacer()
                            Text("Ep 1: \(animeEp1?.title_episode ?? "N/A")")
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
                                .fontWeight(.semibold)
                                //allows for text wrapping
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }

                        Spacer()

                        HStack {
                            //TODO: temporary fake checkmark. Plan to implement real "marking" system later
                            Text("☑")
                            
                            Spacer()
                            // TODO: Convert this to local time zone. Just showing Unix timestamp right now
                            // We have to do .description because otherwise Swift freaks out and thinks we are referencing a Swift method/var!
                            Text(animeEp1?.broadcast?.description ?? "N/A")
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

                DisclosureGroup(content: {
                    Text(animeEp1?.recap ?? "N/A")
                        .font(.caption)
                        //explicitly set text to leading so it displays correctly in ScheduleRow
                        .multilineTextAlignment(.leading)
                }) {
                    Text("\(animeGeneral?.title_english ?? "N/A")")
                        .font(.title2)
                        .fontWeight(.heavy)
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
    let db = Database()
    let authManager = AuthManager.shared

    //"163134" is ReZero
    ScheduleItem(animeID: "163134")
    .environmentObject(db)
    .environmentObject(authManager)
}
