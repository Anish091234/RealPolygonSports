//
//  Announcement.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/3/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Announcement: Identifiable, Codable, Equatable, Hashable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var date: Date
    var imageURL: URL?
    var imageReferenceID: String = ""
    var centerID: String
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case description
        case date
        case imageURL
        case imageReferenceID
        case centerID
    }
}
