//
//  SearchTournamentView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/8/23.
//

import SwiftUI
import FirebaseFirestore

struct SearchTournamentView: View {
    
    @State private var fetchedTournaments: [Tournament] = []
    @State private var searchText: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            ForEach(fetchedTournaments) { tournament in
                NavigationLink {
                    //ResusableProfileContent(user: user)
                    DetailedTournamentView(tournament: tournament)
                    
                } label: {
                    Text(tournament.title)
                        .font(.custom("LexendDeca-Regular", size: 15))
                        .hAlign(.leading)
                }

            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText)
        .navigationTitle("Search Tournaments")
        .onSubmit(of: .search, {
            /// - Fetch Users From Firebase
            Task {
                await searchTournaments()
            }
        })
        .onChange(of: searchText, perform: { newValue in
            if newValue.isEmpty {
                fetchedTournaments = []
            }
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Cancel") {
                    dismiss()
                }
                .tint(.black)
            }
        }
    }
    
    func searchTournaments() async {
        do {
            
            let documents = try await Firestore.firestore().collection("Tournaments")
                .whereField("title", isGreaterThanOrEqualTo: searchText)
                .whereField("title", isLessThanOrEqualTo: "\(searchText)\u{f8ff}")
                .getDocuments()
            
            let tournaments = try documents.documents.compactMap { doc -> Tournament? in
                try doc.data(as: Tournament.self)
            }
            
            await MainActor.run(body: {
                fetchedTournaments = tournaments
            })
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct SearchTournamentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchTournamentView()
    }
}
