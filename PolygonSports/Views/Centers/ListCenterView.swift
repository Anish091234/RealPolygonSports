//
//  ListCenterView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/28/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct ListCenterView: View {
    @State var centers:[Center] = []
    @State var isFetching: Bool = true
    @State private var pagnationDoc: QueryDocumentSnapshot?
    var body: some View {
        ScrollView (.vertical, showsIndicators: false) {
            LazyVStack {
                if isFetching {
                    ProgressView()
                        .padding(.top, 30)
                } else {
                    if centers.isEmpty {
                        Text("No Centers Found")
                            .font(.custom("LexendDeca-Regular", size: 28))
                            .foregroundColor(.gray)
                            .padding(.top, 30)
                    } else {
                        Centers()
                    }
                }
            }
        }
        .refreshable {
            isFetching = true
            centers = []
            pagnationDoc = nil
            await fetchTournaments()
        }
        .task {
            guard centers.isEmpty else {return}
            centers = []
            await fetchTournaments()
        }
    }
    
    @ViewBuilder
    func Centers() -> some View {
        ForEach(centers) { center in
            NavigationLink {
                withAnimation(.easeInOut) {
                    CentersView(center: center)
                }
            } label: {
                ZStack {
                    Rectangle()
                        .blendMode(.overlay)
                        .frame(height: 70)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(9)
                    
                    Text(center.title)
                        .bold()
                        .foregroundColor(.white)
                        .font(.custom("LexendDeca-Regular", size: 15))
                }
            }
            .padding()
        }
        
    }
    
    
    func fetchTournaments() async {
        do {
            var query: Query!
            
            query = Firestore.firestore().collection("Center")
            
            let docs = try await query.getDocuments()
            
            let fetchedCenters = docs.documents.compactMap { doc -> Center? in
                try? doc.data(as: Center.self)
            }
            
            print("----------Found Centers----------")
            
            await MainActor.run(body: {
                centers = fetchedCenters
                isFetching = false
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
}


struct ListCenterView_Previews: PreviewProvider {
    static var previews: some View {
        ListCenterView()
    }
}
