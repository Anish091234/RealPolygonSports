//
//  ChatUser.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/5/23.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatUser: Codable, Identifiable {
    @DocumentID var id: String?
    let uid, email, profileImageUrl: String
}
