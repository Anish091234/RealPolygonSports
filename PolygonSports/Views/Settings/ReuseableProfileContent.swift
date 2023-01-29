//
//  ReuseableProfileContent.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 12/31/22.
//


import SwiftUI
import SDWebImageSwiftUI
struct ResusableProfileContent: View {
    var user: User
    
    @State private var fetchedPosts: [Post] = []
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack{
                HStack(spacing: 12) {
                    WebImage(url: user.userProfileURL).placeholder{
                        Image(systemName: "photo")
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    
                    VStack(alignment: .trailing,spacing: 6) {
                        Text(user.username)
                            .font(.custom("LexendDeca-Regular", size:20))
                            .fontWeight(.semibold)
                        
                        Text(user.userBio)
                            .font(.custom("LexendDeca-Regular", size: 12))
                            .foregroundColor(.gray)
                            .lineLimit(3)
                        
                        if let bioLink = URL(string: user.userBioLink) {
                            Link(user.userBioLink, destination: bioLink)
                                .font(.callout)
                                .tint(.blue)
                                .lineLimit(1)
                        }
                    }
                    .hAlign(.trailing)
                }
                
                Text("Posts")
                    .font(.custom("LexendDeca-Regular", size: 22))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .hAlign(.leading)
                    .padding(.vertical, 15)
                
                ReuseablePostsView(basedOnUID: true, uid: user.userUID, posts: $fetchedPosts)
            }
            .padding()
        }
    }
}

