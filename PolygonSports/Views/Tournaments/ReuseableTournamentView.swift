//
//  ReuseableTournamentView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/7/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct ReusableTournamentView: View {
    
    var basedOnUID: Bool = false
    //var uid: String = ""
    @Binding var tournaments: [Tournament]
    /// - View Properties
    @State var isFetching: Bool = true
    /// - Pagnation
    @State private var pagnationDoc: QueryDocumentSnapshot?
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                if isFetching {
                    ProgressView()
                        .padding(.top, 30)
                } else {
                    if tournaments.isEmpty {
                        Text("No Tournaments Found")
                            .font(.custom("LexendDeca-Regular", size: 28))
                            .foregroundColor(.gray)
                            .padding(.top, 30)
                    } else {
                        Tournaments()
                    }
                }
            }
            .padding(15)
        }
        .refreshable {
            isFetching = true
            tournaments = []
            pagnationDoc = nil
            await fetchTournaments()
        }
        .task {
            guard tournaments.isEmpty else {return}
            tournaments = []
            await fetchTournaments()
        }
    }
    
    
    @ViewBuilder
    func Tournaments() -> some View {
        ForEach(tournaments) { tournament in
            if tournament.tournamentDate >= Date() {
                TournamentCardView(tournament: tournament) { updatedTournament in
                    if let index = tournaments.firstIndex(where: { post in
                        post.id == updatedTournament.id
                    }) {
                        tournaments[index].players = updatedTournament.players
                    }
                } onDelete: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        tournaments.removeAll {tournament == $0}
                    }
                }
            }
        }
    }
    
    func fetchTournaments() async {
        do {
            var query: Query!
            
            query = Firestore.firestore().collection("Tournaments")
                .order(by: "publishedDate", descending: true)
                .limit(to: 20)
            
            let docs = try await query.getDocuments()
            
            let fetchedTournaments = docs.documents.compactMap { doc -> Tournament? in
                try? doc.data(as: Tournament.self)
            }
            
            await MainActor.run(body: {
                tournaments = fetchedTournaments
                isFetching = false
            })
        } catch {
            print(error.localizedDescription)
        }
    }

    
}

