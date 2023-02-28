//
//  RecentMatches.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/18/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct RecentMatches: View {
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") private var userUID: String = ""

    @State var isFetching: Bool = true
    @State var match = UserMatchDoc(name: "Bob", uid: "a1b2c3", match: ["asdfs", "asdf"], lastPlayedMatch: Date())
    @State private var matches: [Match] = []
    var body: some View {
        NavigationStack {
            VStack {
                Text("Recent Matches")
                    .font(.custom("LexendDeca-Regular", size: 25))
                    .bold()
                
                Divider()
                    .padding()
                
                ScrollView {
                    ForEach(matches) { match in
                        NavigationLink {
                            DetailedMatchView(match: match)
                        } label: {
                            Text("\(match.player1) vs \(match.player2)")
                                .font(.custom("LexendDeca-Regular", size: 20))
                                .padding()
                                .background(LinearGradient(gradient: Gradient(colors: [.teal, .mint]), startPoint: .leading, endPoint: .topTrailing))
                                .cornerRadius(32)
                        }
                        .padding()
                    }
                }
            }
        }
        .task {
            await searchUserMatchDocs()
            if matches.isEmpty {
                await searchMatchesDocs()
            }
        }
    }
    
    func searchUserMatchDocs() async {
        do {
            
            let documents = try await Firestore.firestore().collection("UserMatchDocs")
                .getDocuments()
            
            let matchDocs = try documents.documents.compactMap { doc -> UserMatchDoc? in
                try doc.data(as: UserMatchDoc.self)
            }
            
            for doc in matchDocs {
                if doc.uid == userUID {
                    match = doc
                }
            }
            
            await MainActor.run(body: {
                isFetching = false
            })
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func searchMatchesDocs() async {
        isFetching = true
        do {
            
            let documents = try await Firestore.firestore().collection("Match")
                .getDocuments()
            
            let matchDocs = try documents.documents.compactMap { doc -> Match? in
                try doc.data(as: Match.self)
            }
            
            for doc in matchDocs {
                if doc.player1 == userNameStored || doc.player2 == userNameStored {
                    matches.append(doc)
                }
            }
            
            await MainActor.run(body: {
                isFetching = false
            })
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

struct RecentMatches_Previews: PreviewProvider {
    static var previews: some View {
        RecentMatches()
    }
}
