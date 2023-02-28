//
//  UpcomingEventsView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/19/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct UpcomingEventsView: View {
    @State private var isFetching: Bool = true
    @State private var pagnationDoc: QueryDocumentSnapshot?
    @State private var tournaments: [Tournament] = []
    @AppStorage("user_UID") private var userUID: String = ""
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    if isFetching {
                        ProgressView()
                            .padding(.top, 30)
                    } else {
                        if tournaments.isEmpty {
                            Text("No Events Found")
                                .font(.custom("LexendDeca-Regular", size: 25))
                                .foregroundColor(.gray)
                                .padding(.top, 30)
                        } else {
                            Tournaments()
                        }
                    }
                }
                .padding(15)
            }
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
        
        Text("Upcoming Events")
            .font(.custom("LexendDeca-Regular", size: 28))
            .bold()
        ForEach(tournaments) { tournament in
            if tournament.tournamentDate >= Date() && tournament.playersUID.contains(userUID) {
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

struct UpcomingEventsView_Previews: PreviewProvider {
    static var previews: some View {
        UpcomingEventsView()
    }
}
