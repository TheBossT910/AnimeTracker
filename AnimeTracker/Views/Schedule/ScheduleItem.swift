//
//  ScheduleItem.swift
//  AnimeTracker
//
//  Created by Taha Rashid on 2024-11-23.
//

import SwiftUI
import Foundation

struct ScheduleItem: View {
    @EnvironmentObject var db: Database
    @EnvironmentObject var authManager: AuthManager

    let animeID: String  //currently selected anime's iD
    let weekday: String
    
    var animeEpisode: episodes {
        // grab all episodes of show (which are already loaded in)
        let allEpisodes = db.animeData[animeID]?.episodes ?? []
        
        // get the weekday as a number, and return the Unix time range for the day (start of day -> end of day)
        let weekdayAsNumber = getWeekdayAsNumber(weekday: weekday)
        let unixRange = getUnixRangeForWeekday(weekday: weekdayAsNumber)
        
        // save the start/end times of the day
        let startTime = Int(unixRange!.start)
        let endTime = Int(unixRange!.end)
        
        // episode banner image
        // initially set it as the first episode's image (so that there IS an image)
        var episodeBanner = allEpisodes.first?.box_image
        // episode count
        var episodeCount: Int = 0
        
        var airingEpisode = episodes()
        
        allEpisodes.forEach { episode in
            let broadcast = episode.broadcast ?? 0
            // increment episode count. This assumes we get the episode documents in-order/they are inputted in-order
            // TODO: add a episodeCount field in database documents! This is just a temporary solution
            episodeCount += 1
            
            // if an episode airs on the given day
            if (startTime <= broadcast && broadcast <= endTime) {
                // assign to return variable
                airingEpisode = episode
                
                // set broadcast to episode number
                // TODO: this is a temporary solution! Fix this!
                airingEpisode.broadcast = episodeCount
                
                // assign the previous banner image if there is none for the current episode
                if airingEpisode.box_image == "" {
                    airingEpisode.box_image = episodeBanner
                }
                
                // set default title if there is none
                if airingEpisode.title_episode == "" {
                    airingEpisode.title_episode = "Latest Episode"
                }
            }
            
            // update latest banner
            episodeBanner = episode.box_image
        }
        
        // return found airing episode (if any)
        return airingEpisode
    }

    var body: some View {
        //getting anime data
        let anime = db.animeData[animeID]
        let animeGeneral = anime?.data?.general

        //getting specific data
        let airingEpisode = animeEpisode
        let animeSplash = URL(string: airingEpisode.box_image ?? "N/A")


        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                //TODO: check if we even need this .top alignemnt
                HStack(alignment: .top) {
                    //main image
                    AsyncImage(url: animeSplash) { image in
                        image
                        .resizable()
                        .scaledToFill()
                        //trying to make the image dynamically size
                        .frame(
                            minWidth: 211.2, maxWidth: .infinity,
                            minHeight: 100, maxHeight: 130
                        )
                        .clipped()
                    } placeholder: {
                        Color.gray
                            .frame(
                                minWidth: 211.2, maxWidth: .infinity,
                                minHeight: 100, maxHeight: 130
                            )
                    }

                    VStack(alignment: .leading) {
                        //I am embedding the text items in HStacks to horizontally center the text
                        HStack(alignment: .top) {
                            Spacer()
                            Text("Ep \(airingEpisode.broadcast ?? 0): \(airingEpisode.title_episode ?? "N/A")")
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
                            
                            // TODO: Deal with cases where we don't have a broadcast time (and it defaults to 0 in the database itself I think... This is a large-scale problem for later)
                            // NOTE: We have to do .description because otherwise Swift freaks out and thinks we are referencing a Swift method/var!
                            let unixTime: TimeInterval = Double(airingEpisode.broadcast?.description ?? "0") ?? 0
                            let convertedTime = getFormattedTime(from: unixTime)
                            Text(convertedTime)
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
                    // TODO: Implement recap. For now, we will replace showing the recap with showing the 1st episode's description
//                    Text(airingEpisode?.recap ?? "N/A")
//                        .font(.caption)
//                        //explicitly set text to leading so it displays correctly in ScheduleRow
//                        .multilineTextAlignment(.leading)
                    
                    Text(airingEpisode.description?.toPlainText() ?? "N/A")
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
    
    // function courtesy of ChatGPT for converting time
    // TODO: create your own implementation
    func getFormattedTime(from unixTimestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: unixTimestamp)
        let formatter = DateFormatter()
        
        // Set timezone to the user's current timezone
        formatter.timeZone = TimeZone.current
        
        // Automatically use 12-hour or 24-hour format based on user settings
        formatter.dateStyle = .none
        formatter.timeStyle = .short  // Uses system setting (e.g., "2:30 PM" or "14:30")
        
        return formatter.string(from: date)
    }
}

#Preview {
    //environment object
    let db = Database()
    let authManager = AuthManager.shared

    //"163134" is ReZero
    ScheduleItem(animeID: "163134", weekday: "Sundays")
    .environmentObject(db)
    .environmentObject(authManager)
}
