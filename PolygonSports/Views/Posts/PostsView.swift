//
//  PostsView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 12/31/22.
//


import SwiftUI

struct PostsView: View {
    
    var isFromNavigationLink: Bool
    @State private var recentsPosts: [Post] = []
    @State private var createNewPost: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                ReuseablePostsView(posts: $recentsPosts)
                    .hAlign(.center).vAlign(.center)
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink {
                                SearchUserView()
                            } label: {
                                Image(systemName: "magnifyingglass")
                                    .tint(colorScheme == .dark ? .white : .black)
                                    .scaleEffect(0.9)
                            }

                        }
                    })
                    .navigationTitle("Posts")
                    .padding(.top, isFromNavigationLink ? 55 : 0)
                
                Button {
                    createNewPost.toggle()
                } label: {
                    Image(systemName: "plus")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                        .padding(13)
                        .background(colorScheme == .dark ? .white : .black, in: Circle())
                }.padding(15)
                    .padding(.top, 500)
                    .padding(.leading, 300)
            }
            .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $createNewPost) {
            CreateNewPost { post in
                recentsPosts.insert(post, at: 0)
            }
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView(isFromNavigationLink: true)
            .preferredColorScheme(.dark)
    }
}

