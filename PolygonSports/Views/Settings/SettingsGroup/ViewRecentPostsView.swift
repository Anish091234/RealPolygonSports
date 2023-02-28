//
//  ViewRecentPostsView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/18/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ViewRecentPostsView: View {
    
    var basedOnUID: Bool = false
    var uid: String = ""
    @Binding var posts: [Post]
    @State var isFetching: Bool = true
    @State private var pagnationDoc: QueryDocumentSnapshot?
    @AppStorage("user_UID") private var userUID: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                ScrollView (showsIndicators: false) {
                    LazyVStack {
                        if isFetching {
                            ProgressView()
                                .padding(.top, 30)
                        } else {
                            if posts.isEmpty {
                                Text("No Posts Found")
                                    .font(.custom("LexendDeca-Regular", size: 12))
                                    .foregroundColor(.white)
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
        }
    }
    
    @ViewBuilder
    func Posts() -> some View {
        VStack {
            Text("Recent Posts")
                .bold()
                .font(.custom("LexendDeca-Regular", size: 25))
            
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
                
                for fetchedPost in fetchedPosts {
                    if fetchedPost.userUID == userUID {
                        posts.append(fetchedPost)
                    }
                }
                
                isFetching = false
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ViewRecentPostsView_Previews: PreviewProvider {
    static var previews: some View {
        ViewRecentPostsView(posts: .constant([Post(text: "", userName: "", userUID: "", userProfileURL: URL(string: "")!)]))
    }
}
