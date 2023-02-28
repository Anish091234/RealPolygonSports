//
//  DetailedMatchView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/19/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct DetailedMatchView: View {
    
    var match: Match

    var body: some View {
        VStack {
            Text("\(match.player1) vs \(match.player2)")
                .font(.custom("LexendDeca-Regular", size: 25))
                .padding(.bottom, 300)
                .bold()
            
            Text("\(match.playerOneGameScore) to \(match.playerTwoGameScore)")
                .font(.custom("LexendDeca-Regular", size: 20))
                .padding(.bottom, 100)

        }
    }
    
}

struct DetailedMatchView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedMatchView(match: Match(matchID: "", player1: "", player2: "", player1MatchScores: [1], player2MatchScores: [1], tournamentID: "", isMatchStarted: true, winner: "", playerOneGameScore: 1, playerTwoGameScore: 2, group: 1))
    }
}
