//
//  UserMatchDoc.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/18/23.
//

import Foundation
import FirebaseFirestoreSwift

struct UserMatchDoc: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var name: String
    var uid: String
    var match: [String?]
    var lastPlayedMatch: Date
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case uid
        case match
        case lastPlayedMatch
    }
}
