//
//  Tournament.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/7/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Tournament: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var title: String
    var players: [String] = []
    var playersUID: [String] = []
    var adminName: String
    var adminUID: String
    var publishedDate: Date = Date()
    var tournamentDate: Date = Date()
    var group1: [String] = []
    var group2: [String] = []
    var group3: [String] = []
    var group1End: Int
    var group2End: Int
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case players
        case playersUID
        case adminName
        case adminUID
        case publishedDate
        case tournamentDate
        case group1
        case group2
        case group3
        case group1End
        case group2End
    }
}

