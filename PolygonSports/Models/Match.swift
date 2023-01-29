//
//  Match.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/10/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Match: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var matchID: String
    var player1: String
    var player2: String
    var player1MatchScores: [Int]
    var player2MatchScores: [Int]
    var tournamentID: String
    var isMatchStarted:Bool
    var winner: String
    var playerOneGameScore: Int
    var playerTwoGameScore: Int
    var group: Int
    
    enum CodingKeys: CodingKey {
        case id
        case matchID
        case player1
        case player2
        case player1MatchScores
        case player2MatchScores
        case tournamentID
        case isMatchStarted
        case winner
        case playerOneGameScore
        case playerTwoGameScore
        case group
    }
}

