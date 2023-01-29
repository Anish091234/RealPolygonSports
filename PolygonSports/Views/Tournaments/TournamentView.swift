//
//  TournamentView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/7/23.
//

import SwiftUI
import FirebaseAuth

struct TournamentView: View {
    
    @State private var createNewPost: Bool = false
    @State private var recentTournaments:[Tournament] = []
    @AppStorage("user_UID") private var userUID: String = ""
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ReusableTournamentView(tournaments: $recentTournaments)
                .hAlign(.center).vAlign(.center)
                .overlay(alignment: .bottomTrailing) {
                    Button {
                        createNewPost.toggle()
                    } label: {
                        Text("Create Tournament")
                            .font(.custom("LexendDeca-Regular", size: 20))
                            .fontWeight(.semibold)
                            .tint(colorScheme == .dark ? .black : .white)
                            .padding(13)
                            .background(colorScheme == .dark ? .white : .black, in: Capsule())
                    }.padding(15)
                    
                }
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            SearchTournamentView()
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .tint(colorScheme == .dark ? .white : .black)
                                .scaleEffect(0.9)
                        }
                    }
                })
                .navigationTitle("Tournaments")
        }
        .fullScreenCover(isPresented: $createNewPost) {
            CreateTournament { tournament in
                recentTournaments.insert(tournament, at: 0)
            }
        }
        
    }
}

struct Tournamentiew_Previews: PreviewProvider {
    static var previews: some View {
        TournamentView()
    }
}

