//
//  ListEventsView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/29/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ListEventsView: View {
    var center: String
    @State private var tournaments: [Tournament] = []
    var body: some View {
        VStack {
            ReusableTournamentView(tournaments: $tournaments)
                .hAlign(.center).vAlign(.center)
        }
        .task {
            if tournaments.isEmpty {
                await searchEvents()
            }
        }
    }
    
    func searchEvents() async {
        do {
            let documents = try await Firestore.firestore().collection("Tournaments")
                .whereField("center", isGreaterThanOrEqualTo: center)
                .whereField("center", isLessThanOrEqualTo: "\(center)\u{f8ff}")
                .getDocuments()
            
            let firebaseTournaments = try documents.documents.compactMap { doc -> Tournament? in
                try doc.data(as: Tournament.self)
            }
            
            await MainActor.run(body: {
                tournaments = firebaseTournaments
            })
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ListEventsView_Previews: PreviewProvider {
    static var previews: some View {
        ListEventsView(center: "Apple Park")
    }
}
