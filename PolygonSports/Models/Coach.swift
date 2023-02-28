//
//  Coach.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/27/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Coach: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var uid: String
    var centerName: String
    var centerUID: String
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case uid
        case centerName
        case centerUID
    }
}


