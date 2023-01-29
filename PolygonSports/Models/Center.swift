//
//  Center.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/23/23.
//

import Foundation
import FirebaseFirestoreSwift
import CoreLocation

struct Center: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var title: String
    var headCoach: String
    var coaches:[String]
    var students: [String]
    var address:String
    var lat: Double
    var lng: Double
    var sport: String
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case headCoach
        case coaches
        case students
        case address
        case lat
        case lng
        case sport
    }
}
