//
//  ReuseablePostsView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 12/31/22.
//


import SwiftUI
import Firebase

struct ReuseablePostsView: View {
    var basedOnUID: Bool = false
    var uid: String = ""
    @Binding var posts: [Post]
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
                    if posts.isEmpty {
                        Text("No Posts Found")
                            .font(.custom("LexendDeca-Regular", size: 12))
                            .foregroundColor(.gray)
                            .padding(.top, 30)
                    } else {
                        Posts()
                    }
                }
            }
            .padding(15)
        }
        .refreshable {
            isFetching = true
            posts = []
            pagnationDoc = nil
            await fetchPosts()
        }
        .task {
            guard posts.isEmpty else {return}
            posts = []
            await fetchPosts()
        }
    }
    
    @ViewBuilder
    func Posts() -> some View {
        ForEach(posts) { post in
            PostCardView(post: post) { updatedPost in
                if let index = posts.firstIndex(where: { post in
                    post.id == updatedPost.id
                }) {
                    posts[index].likedIDs = updatedPost.likedIDs
                    posts[index].dislikedIDs = updatedPost.dislikedIDs
                }
            } onDelete: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    posts.removeAll {post == $0}
                }
            }
        }
    }
    
    //MARK: Fetching Posts
    
    func fetchPosts() async {
        do {
            var query: Query!
            
            query = Firestore.firestore().collection("Posts")
                .order(by: "publishedDate", descending: true)
                .limit(to: 20)
            
            let docs = try await query.getDocuments()
            
            let fetchedPosts = docs.documents.compactMap { doc -> Post? in
                try? doc.data(as: Post.self)
            }
            
            await MainActor.run(body: {
                posts = fetchedPosts
                isFetching = false
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ReuseablePostsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

