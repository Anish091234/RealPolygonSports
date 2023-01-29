//
//  CoachGameView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/13/23.
//

import SwiftUI
import Firebase
import FirebaseStorage


struct CoachGameView: View {
    @State var matches:[Match] = []
    var passedTournamentID: String
    var body: some View {
        ScrollView {
            VStack {
                Text("Game Center")
                    .font(.custom("LexendDeca-Regular", size: 30))
                    .padding()
                    .bold()
                
                Divider()
                
                ForEach(matches) { match in
                    if match.tournamentID == passedTournamentID {
                        VStack {
                            HStack {
                                Text("Player 1: \(match.player1)")
                                    .font(.custom("LexendDeca-Regular", size: 18))
                                    .fontWeight(.semibold)
                                    .padding()
                                Text("Player 2: \(match.player2)")
                                    .font(.custom("LexendDeca-Regular", size: 18))
                                    .bold()
                                    .padding()
                            }
                            
                            Text("Winner: \(match.winner)")
                                .font(.custom("LexendDeca-Regular", size: 18))
                                .fontWeight(.semibold)
                                .padding()
                            
                            Text("Score: \(match.playerOneGameScore) to \(match.playerTwoGameScore)")
                                .font(.custom("LexendDeca-Regular", size: 18))
                                .fontWeight(.semibold)
                                .padding()
                                
                            Divider()
                        }
                    }
                }
                
                Spacer()
            }
        }
        .task {
            await searchPlayers()
        }
    }
    
    func searchPlayers() async {
        do {
            let documents = try await Firestore.firestore().collection("Match")
                .getDocuments()
                
            let firebaseMatches = try documents.documents.compactMap { doc -> Match? in
                try doc.data(as: Match.self)
            }
            
                matches.append(contentsOf: firebaseMatches)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

struct CoachGameView_Previews: PreviewProvider {
    static var previews: some View {
        CoachGameView(passedTournamentID: "oijfiwejfi1")
    }
}
