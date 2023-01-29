//
//  TournamentCardView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/7/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct TournamentCardView: View {
    
    var tournament: Tournament
    ///- Callbacks
    var onUpdate: (Tournament)->()
    var onDelete: ()->()
    
    /// - View Properties
    @AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("account_child_UUID") var childUID = ""
    @AppStorage("account_type") var accountType: String = ""
    @AppStorage("account_child_name") var childName = ""
    @AppStorage("hasPlayerAccount") var playerAccountRegistered = false
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @State private var docListener: ListenerRegistration?
    @State var showSheet: Bool = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(tournament.title)
                    .font(.custom("LexendDeca-Regular", size: 15))
                    .fontWeight(.semibold)
                Text("Created At: \(tournament.publishedDate.formatted(date: .numeric, time: .shortened))")
                    .font(.custom("LexendDeca-Regular", size: 11))
                
                Text("Tournament Date: \(tournament.tournamentDate.formatted(date: .numeric, time: .shortened))")
                    .font(.custom("LexendDeca-Regular", size: 11))
                
                Text("Admin Name: \(tournament.adminName)")
                    .font(.custom("LexendDeca-Regular", size: 15))
                    .fontWeight(.semibold)
                
                tournamentInteraction()
                
                Divider()
                    .padding()
            }
        }
        .hAlign(.leading)
        .padding()
        .overlay(alignment: .topTrailing, content: {
            //if tournament.adminUID == userUID {
                NavigationLink {
                    DetailedTournamentView(tournament: tournament)
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        //.font(.caption)
                        .rotationEffect(.init(degrees: -90))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .padding(8)
                        .contentShape(Rectangle())
                }
                .offset(x:8)
            //}
        })
        .onAppear {
            if docListener == nil {
                guard let tournamentID = tournament.id else {return}
                docListener = Firestore.firestore().collection("Tournaments").document(tournamentID).addSnapshotListener({ snapshot, error in
                    if let snapshot {
                        if snapshot.exists {
                            if let updatedTournament = try? snapshot.data(as: Tournament.self) {
                                onUpdate(updatedTournament)
                            }
                                
                        } else {
                            onDelete()
                        }
                    }
                })
            }
        }
    }
    
    @ViewBuilder
    func tournamentInteraction() -> some View {
        HStack(spacing: 6) {
            if accountType == "Student" {
                
                Button {
                    showSheet.toggle()
                } label: {
                    HStack {
                        Text("Join")
                            .font(.custom("LexendDeca-Regular", size: 18))
                            .fontWeight(.semibold)
                        Image(systemName: "dock.rectangle")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                }
                .blurredSheet(.init(.ultraThinMaterial), show: $showSheet) {
                    
                } content: {
                    JoinTournamentView(tournament: tournament, accountType: "Student")
                        .presentationDetents([.large, .medium,.height(150)])
                }
                    
                
                
            } else if accountType == "Parent" && childName != "" {
                
                Button {
                    showSheet.toggle()
                } label: {
                    HStack {
                        Text("Join")
                            .font(.custom("LexendDeca-Regular", size: 18))
                            .fontWeight(.semibold)
                        Image(systemName: "dock.rectangle")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                }
                .blurredSheet(.init(.ultraThinMaterial), show: $showSheet) {
                    
                } content: {
                    JoinTournamentView(tournament: tournament, accountType: "Parent")
                        .presentationDetents([.large, .medium,.height(150)])
                }
                    

            } else {
                
                Button {
                    showSheet.toggle()
                } label: {
                    HStack {
                        Text("Join")
                            .font(.custom("LexendDeca-Regular", size: 18))
                            .fontWeight(.semibold)
                        Image(systemName: "dock.rectangle")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                }
                .blurredSheet(.init(.ultraThinMaterial), show: $showSheet) {
                    
                } content: {
                    JoinTournamentView(tournament: tournament, accountType: "Coach")
                        .presentationDetents([.large, .medium,.height(150)])
                }
                    
            }
            Text("Players Joined: \(tournament.players.count)")
                .font(.custom("LexendDeca-Regular", size: 12))
        }
        .padding(.vertical, 0)
    }
    
    func setError(_ error: String) async {
        await MainActor.run(body: {
            errorMessage = error
            showError.toggle()
        })
    }
    
    func deleteTournament() {
        Task {
            do {
                guard let tournamentID = tournament.id else {return}
                try await Firestore.firestore().collection("Tournaments").document(tournamentID).delete()
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
