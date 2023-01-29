//
//  JoinTournamentView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/22/23.
//

import SwiftUI
import FirebaseStorage
import Firebase

struct JoinTournamentView: View {
    var tournament: Tournament
    var accountType: String
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_rating") var userRating: String = ""
    @AppStorage("account_child_UUID") var childUID = ""
    @AppStorage("account_type") var storedAccountType: String = ""
    @AppStorage("account_child_name") var childName = ""
    @AppStorage("hasPlayerAccount") var playerAccountRegistered = false
    @AppStorage("account_child_rating") var childRating = ""
    @State var joinedTournament: Bool = false
    var body: some View {
        Text("Name: \(userNameStored)")
            .font(.custom("LexendDeca-Regular", size: 18))
        Text("Rating: \(userRating)")
            .font(.custom("LexendDeca-Regular", size: 18))
        
        if accountType == "Student" {
            Button {
                joinTournament()
                joinedTournament.toggle()
            } label: {
                Text("Join Tournament")
                    .font(.custom("LexendDeca-Regular", size: 18))
            }
            .buttonStyle(.bordered)
            .disabled(joinedTournament)
        } else if accountType == "Parent" {
            HStack {
                Button {
                    joinTournament()
                    joinedTournament.toggle()
                } label: {
                    Text("Join as \(userNameStored)")
                        .font(.custom("LexendDeca-Regular", size: 18))
                }
                .buttonStyle(.bordered)
                .disabled(joinedTournament)
                
                Text("Or")
                    .font(.custom("LexendDeca-Regular", size: 18))
                
                Button  {
                    joinChildTournament()
                    joinedTournament.toggle()
                } label: {
                    Text("Join as \(childName)")
                        .font(.custom("LexendDeca-Regular", size: 18))
                }
                .buttonStyle(.bordered)
                .disabled(joinedTournament)
            }
            
            Text("\(childName)'s Rating: \(childRating)")
                .font(.custom("LexendDeca-Regular", size: 18))

        } else {
            Button {
                joinTournament()
                joinedTournament.toggle()
            } label: {
                Text("Join Tournament")
                    .font(.custom("LexendDeca-Regular", size: 18))
            }
            .buttonStyle(.bordered)
            .disabled(joinedTournament)
        }

    }
    func joinTournament() {
        Task {
            
            let intRating = Int(userRating) ?? 0
            
            if playerAccountRegistered {
                guard let tournamentID = tournament.id else {return}
                if tournament.players.contains(userNameStored) {
                    ///Leave the tournament
                    if intRating < tournament.group1End {
                        try await Firestore.firestore().collection("Tournaments").document(tournamentID).updateData([
                            "players" : FieldValue.arrayRemove([userNameStored]),
                            "group1" : FieldValue.arrayRemove([userNameStored]),
                            "playersUID" : FieldValue.arrayRemove([userUID])
                            ])
                    } else if intRating > tournament.group1End && intRating < tournament.group2End {
                        try await Firestore.firestore().collection("Tournaments").document(tournamentID).updateData([
                            "players" : FieldValue.arrayRemove([userNameStored]),
                            "group2" : FieldValue.arrayRemove([userNameStored]),
                            "playersUID" : FieldValue.arrayRemove([userUID])
                            ])
                    } else  {
                        try await Firestore.firestore().collection("Tournaments").document(tournamentID).updateData([
                            "players" : FieldValue.arrayRemove([userNameStored]),
                            "group3" : FieldValue.arrayRemove([userNameStored]),
                            "playersUID" : FieldValue.arrayRemove([userUID])
                            ])
                    }

                } else {
                    ///Join Tournament
                    if intRating < tournament.group1End {
                        try await Firestore.firestore().collection("Tournaments").document(tournamentID).updateData([
                            "players" : FieldValue.arrayUnion([userNameStored]),
                            "group1" : FieldValue.arrayUnion([userNameStored]),
                            "playersUID" : FieldValue.arrayUnion([userUID])
                            ])
                    } else if intRating > tournament.group1End && intRating < tournament.group2End {
                        try await Firestore.firestore().collection("Tournaments").document(tournamentID).updateData([
                            "players" : FieldValue.arrayUnion([userNameStored]),
                            "group2" : FieldValue.arrayUnion([userNameStored]),
                            "playersUID" : FieldValue.arrayUnion([userUID])
                            ])
                    } else  {
                        try await Firestore.firestore().collection("Tournaments").document(tournamentID).updateData([
                            "players" : FieldValue.arrayUnion([userNameStored]),
                            "group3" : FieldValue.arrayUnion([userNameStored]),
                            "playersUID" : FieldValue.arrayUnion([userUID])
                            ])
                    }
                }
            } else {
                await setError("No Player Profile Set. Head to settings to set this up.")
            }
        }
    }
    
    func joinChildTournament() {
        Task {
            
            let intRating = Int(childRating) ?? 0
            
            print("childName: \(childName)")
            print("ChildUID: \(childUID)")
            
            guard let tournamentID = tournament.id else {return}
            if tournament.players.contains(childName) {
                ///Leave the tournament
                if intRating < tournament.group1End {
                    try await Firestore.firestore().collection("Tournaments").document(tournamentID).updateData([
                        "players" : FieldValue.arrayRemove([childName]),
                        "group1" : FieldValue.arrayRemove([childName]),
                        "playersUID" : FieldValue.arrayRemove([childUID])
                        ])
                } else if intRating > tournament.group1End && intRating < tournament.group2End {
                    try await Firestore.firestore().collection("Tournaments").document(tournamentID).updateData([
                        "players" : FieldValue.arrayRemove([childName]),
                        "group2" : FieldValue.arrayRemove([childName]),
                        "playersUID" : FieldValue.arrayRemove([childUID])
                        ])
                } else  {
                    try await Firestore.firestore().collection("Tournaments").document(tournamentID).updateData([
                        "players" : FieldValue.arrayRemove([childName]),
                        "group3" : FieldValue.arrayRemove([childName]),
                        "playersUID" : FieldValue.arrayRemove([childUID])
                        ])
                }

            } else {
                ///Join Tournament
                if intRating < tournament.group1End {
                    try await Firestore.firestore().collection("Tournaments").document(tournamentID).updateData([
                        "players" : FieldValue.arrayUnion([childName]),
                        "group1" : FieldValue.arrayUnion([childName]),
                        "playersUID" : FieldValue.arrayUnion([childUID])
                        ])
                } else if intRating > tournament.group1End && intRating < tournament.group2End {
                    try await Firestore.firestore().collection("Tournaments").document(tournamentID).updateData([
                        "players" : FieldValue.arrayUnion([childName]),
                        "group2" : FieldValue.arrayUnion([childName]),
                        "playersUID" : FieldValue.arrayUnion([childUID])
                        ])
                } else  {
                    try await Firestore.firestore().collection("Tournaments").document(tournamentID).updateData([
                        "players" : FieldValue.arrayUnion([childName]),
                        "group3" : FieldValue.arrayUnion([childName]),
                        "playersUID" : FieldValue.arrayUnion([childUID])
                        ])
                }
            }
        }
    }
    
    func setError(_ error: String) async {
        await MainActor.run(body: {
            errorMessage = error
            showError.toggle()
        })
    }
}

