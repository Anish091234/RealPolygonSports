//
//  ChatMessage.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/5/23.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatMessage: Codable, Identifiable {
    @DocumentID var id: String?
    let fromId, toId, text: String
    let timestamp: Date
}

