//
//  PolygonSportsApp.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 12/31/22.
//

import SwiftUI
import Firebase

@main
struct PolygonSportsApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthViewModel())
        }
    }
}
