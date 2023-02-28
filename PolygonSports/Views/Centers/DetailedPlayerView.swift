//
//  DetailedPlayerView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/28/23.
//


import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct DetailedPlayerView: View {
    var player: String
    @State var players: [Player] = []
    var body: some View {
        VStack {
            ForEach(players) { player in
                let playerRating: String = String(player.rating)
                let playerAge: String = String(player.age)
                
                Text("Name: \(player.name)")
                    .font(.custom("LexendDeca-Regular", size: 20))
                    .padding()
                    .fontWeight(.semibold)
                Text("Email: \(player.email)")
                    .font(.custom("LexendDeca-Regular", size: 20))
                Text("Age: \(playerAge)")
                    .font(.custom("LexendDeca-Regular", size: 20))
                    .padding()
                Text("Rating: \(playerRating)")
                    .font(.custom("LexendDeca-Regular", size: 20))
                    .padding()
                
                
                if player.isChildAccount {
                    Divider()
                    
                    Text("Parent Account:")
                        .bold()
                        .font(.custom("LexendDeca-Regular", size: 20))
                    Text("Parent Name: \(player.parentName)")
                        .font(.custom("LexendDeca-Regular", size: 20))
                        .padding()
                        .fontWeight(.semibold)
                    Text("Parent Email: \(player.parentEmail)")
                        .font(.custom("LexendDeca-Regular", size: 20))
                }
                Spacer()
            }
        }
        .task {
            if players.isEmpty {
                await searchUsers()
            }
        }
        .refreshable {
            players = []
            await searchUsers()
        }
    }
    
    func searchUsers() async {
        do {
            
            let documents = try await Firestore.firestore().collection("Player")
                .whereField("name", isGreaterThanOrEqualTo: player)
                .whereField("name", isLessThanOrEqualTo: "\(player)\u{f8ff}")
                .getDocuments()
            
            let users = try documents.documents.compactMap { doc -> Player? in
                try doc.data(as: Player.self)
            }
            
            await MainActor.run(body: {
                players = users
            })
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct DetailedPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedPlayerView(player: "Bob")
    }
}
