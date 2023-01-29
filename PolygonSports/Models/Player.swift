//
//  Player.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/9/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Player: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var name: String
    var email:String
    var rating: Int
    var age: Int
    var isChildAccount: Bool
    var parentAccountUID:String
    var parentName: String
    var parentEmail: String
    var playerUID: String
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case email
        case rating
        case age
        case isChildAccount
        case parentAccountUID
        case parentName
        case parentEmail
        case playerUID
    }
}
