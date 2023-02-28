//
//  DetailedTournamentView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/8/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct DetailedTournamentView: View {
    var tournament: Tournament
    @AppStorage("user_UID") private var userUID: String = ""
    @Environment(\.colorScheme) var colorScheme
    @State private var fetchedPlayers: [Player] = []
    @State private var ratingRange: [String] = []
    @State var localgroup1: [String] = []
    @State var localgroup2: [String] = []
    @State var localgroup3: [String] = []
    @State var isGroup1Empty: Bool = false
    @State var isGroup2Empty: Bool = false
    @State var isGroup3Empty: Bool = false
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Group {
                    HStack {
                        VStack {
                            Text(tournament.title)
                                .font(.custom("LexendDeca-Regular", size: 24))
                                .hAlign(.leading)
                                
                                .fontWeight(.semibold)
                            Text(tournament.publishedDate.formatted(.dateTime.day().month()))
                                .font(.custom("LexendDeca-Regular", size: 18))
                                .hAlign(.leading)
                        }
                        
                        Text(tournament.adminName)
                            .font(.custom("LexendDeca-Regular", size: 15))
                            .padding()
                    }
                    .padding()
                    
                    Text("Tournament Date: \n \(tournament.tournamentDate.formatted(.dateTime.day().month()))")
                        .font(.custom("LexendDeca-Regular", size: 16))
                        .padding()
                        .hAlign(.leading)
                }
                
                Text("Players Joined:")
                    .font(.custom("LexendDeca-Regular", size: 18))
                    .bold()
                    .padding()
                    .hAlign(.leading)
                
                Divider()
                
                //MARK: Group 1
                Group {
                    Text("Group 1:")
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .hAlign(.leading)
                        .padding()
                    ForEach(tournament.group1, id: \.self) { player in
                        Text(player)
                            .font(.custom("LexendDeca-Regular", size: 18))
                    }
                    
                    if tournament.group1.isEmpty {
                        Text("")
                    } else {
                        NavigationLink {
                            MatchView(fetchedPlayers: tournament.group1, tournamentID: tournament.id ?? "", tournamentAdminUID: tournament.adminUID, group: 1)
                        } label: {
                            Text("Start Matches For Group 3")
                                .font(.custom("LexendDeca-Regular", size: 18))
                        }
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                        .padding()
                        .background(colorScheme == .dark ? .white : .black)
                        .cornerRadius(12)
                        .padding()
                        
                    }
                }
                
                Divider()
                
                //MARK: Group 2
                Group {
                    
                    Text("Group 2:")
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .hAlign(.leading)
                        .padding()
                    ForEach(tournament.group2, id: \.self) { player in
                        Text(player)
                            .font(.custom("LexendDeca-Regular", size: 18))
                    }
                    
                    if tournament.group2.isEmpty {
                        Text("")
                        
                    } else {
                        NavigationLink {
                            MatchView(fetchedPlayers: tournament.group2, tournamentID: tournament.id ?? "", tournamentAdminUID: tournament.adminUID, group: 2)
                        } label: {
                            Text("Start Matches For Group 3")
                                .font(.custom("LexendDeca-Regular", size: 18))
                        }
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                        .padding()
                        .background(colorScheme == .dark ? .white : .black)
                        .cornerRadius(12)
                        .padding()
                    }
                }
                
                Divider()
                
                //MARK: Group 3
                Group {
                    Text("Group 3:")
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .hAlign(.leading)
                        .padding()
                    ForEach(tournament.group3, id: \.self) { player in
                        Text(player)
                            .font(.custom("LexendDeca-Regular", size: 18))
                    }
                    
                    if tournament.group3.isEmpty {
                        Text("")
                    } else {
                        NavigationLink {
                            MatchView(fetchedPlayers: tournament.group3, tournamentID: tournament.id ?? "", tournamentAdminUID: tournament.adminUID, group: 3)
                        } label: {
                            Text("Start Matches For Group 3")
                                .font(.custom("LexendDeca-Regular", size: 18))
                        }
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                        .padding()
                        .background(colorScheme == .dark ? .white : .black)
                        .cornerRadius(12)
                        .padding()
                        .disabled(isGroup3Empty)
                    }
                }
                
                Divider()
                if userUID == tournament.adminUID {
                    NavigationLink {
                        CoachGameView(passedTournamentID: tournament.id ?? "")
                    } label: {
                        Text("Game Center")
                            .font(.custom("LexendDeca-Regular", size: 24))
                    }
                }
            }
        }
        .task {
            await searchPlayers()
            
            if localgroup1.isEmpty && localgroup2.isEmpty && localgroup3.isEmpty {
                await getGroups(fetchedPlayers: fetchedPlayers)
            }
        }
    }
    
    func searchPlayers() async {
        do {
            let documents = try await Firestore.firestore().collection("Players")
                .getDocuments()
    
            let players = try documents.documents.compactMap { doc -> Player? in
                try doc.data(as: Player.self)
            }
    
            fetchedPlayers = players
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getGroups(fetchedPlayers: [Player]) async {
        do  {
            for player in fetchedPlayers {
                if tournament.group1.contains(player.name) {
                    localgroup1.append(player.name)
                } else if tournament.group2.contains(player.name) {
                    localgroup2.append(player.name)
                } else if tournament.group3.contains(player.name){
                    localgroup3.append(player.name)
                }
            }
            
            if localgroup1.isEmpty {
                print("Group 1 isEmpty")
                isGroup1Empty = true
            }
            
            if localgroup2.isEmpty {
                print("Group 2 isEmpty")
                isGroup2Empty = true
            }
            
            if localgroup3.isEmpty {
                print("Group 3 isEmpty")
                isGroup3Empty = true
            }
        }
    }
}

struct DetailedTournament_Previews: PreviewProvider {
    static var previews: some View {
        DetailedTournamentView(tournament: Tournament(title: "League 1", adminName: "Anish Rangdal", adminUID: "123123123", publishedDate: Date(), tournamentDate: Date(), group1: ["Bob", "John"], group2: ["Thug", "Hamilton"], group3: ["Jefferson", "Wakanda"], group1End: 1000, group2End: 2000, address: "123 Main Street", center: "Apple is cool"))
        
    }
}

