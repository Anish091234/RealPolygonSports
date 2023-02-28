//
//  Lesson.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/22/23.
//
import SwiftUI
import FirebaseFirestoreSwift

struct Lesson: Identifiable, Codable {
    @DocumentID var id: String?
    var date: Date
    var coachName: String
    var coachUID: String
    var centerName: String
    var centerUID: String
    var playerName: String
    var playerUID: String
    var duration: Int
    var isChild: Bool
    var parentName: String
    var parentUID: String
    var isAccepted: Bool
    var isStarted: Bool
    var isFinished: Bool
    var notes: String
    
    enum CodingKeys: CodingKey {
        case id
        case date
        case coachName
        case coachUID
        case centerName
        case centerUID
        case playerName
        case playerUID
        case duration
        case isChild
        case parentName
        case parentUID
    }
}
