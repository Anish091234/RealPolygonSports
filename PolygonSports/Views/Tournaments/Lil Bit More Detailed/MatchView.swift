//
//  MatchView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/10/23.
//

import SwiftUI

struct MatchView: View {
    var fetchedPlayers: [String] = []
    var tournamentID: String
    var tournamentAdminUID: String
    var group: Int
    @State private var randomizedMatches:[String] = []
    @State private var IndividualPlayersMatches:[String] = []
    @State private var players: [String] = []
    @AppStorage("user_name") private var username: String = ""
    @AppStorage("account_child_name") var childName = ""
    @AppStorage("user_UID") private var userUID: String = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            ForEach(randomizedMatches, id: \.self) { match in
                HStack {
                    Text(match)
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .padding()
                    NavigationLink {
                        GameCounter(tournamentID: tournamentID, baseString: [match], group: group)
                    } label: {
                        Text("Start Game")
                            .font(.custom("LexendDeca-Regular", size: 18))
                            .padding()
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .tint(colorScheme == .dark ? .white : .black)
                            }
                            .padding()
                    }
                    
                }
            }

            
            
        }
        .task {
                        
            if randomizedMatches.count == 0 {
                await matches()
                await getSubstring(matchConversion: randomizedMatches)
            } else  {
                return
            }
            
        }
    }
    
    func getSubstring(matchConversion: [String]) async {
        for matches in matchConversion {
            let text = matches
            let regex = /Match Between: (?<player1>\w+) and (?<player2>\w+)/
            if let match = text.firstMatch(of: regex) {
                players.append(String(match.player1))
                players.append(String(match.player2))
            }
        }
    }
    
    func matches() async {
        if fetchedPlayers.count % 2 == 0 {
            var i = 0
            while i < fetchedPlayers.count-1 {
                randomizedMatches.append(contentsOf: ["Match Between: \(fetchedPlayers[i]) and \(fetchedPlayers[i+1])"])
                i+=1
            }
            
            randomizedMatches.append(contentsOf: ["Match Between: \(fetchedPlayers[0]) and \(fetchedPlayers[fetchedPlayers.count-1])"])
        } else {
            randomizedMatches.append(contentsOf: ["Odd Number Of Players 🙁"])
        }
    }
}
