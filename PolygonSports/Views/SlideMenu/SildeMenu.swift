//
//  SideMenu.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/22/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct SlideMenu: View {
    @Binding var showMenu: Bool
    @AppStorage("user_name") private var username: String = ""
    @AppStorage("user_image_data") var appImageData: Data!
    @AppStorage("user_profile_url") var profileURL: URL?
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                
                WebImage(url: profileURL).placeholder{
                    Image(systemName: "photo")
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 65, height: 65)
                .clipShape(Circle())
                
                Text(username)
                    .font(.title2.bold())
                    .font(.custom("LexendDeca-Regular", size: 23))
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 45) {
                        TabButton(title: "Tournaments", image: "profile")
                        
                        TabButton(title: "Text", image: "messages")
                        
                        TabButton(title: "Settings", image: "gear")
                        
                        TabButton(title: "Centers", image: "Home")
                        
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.leading)
            
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(width: getRect().width - 90)
        .frame(maxHeight: .infinity)
        .background(
            Color.primary.opacity(0.04)
                .ignoresSafeArea(.container, edges: .vertical)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    func TabButton(title: String, image: String) -> some View{
        if title == "Tournaments" {
            NavigationLink {
                TournamentView()
            } label: {
                HStack(spacing: 14) {
                    Image(image)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 22, height: 22)
                    
                    Text(title)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("LexendDeca-Regular", size: 18))
                }
            }
        } else if title == "Text" {
            NavigationLink {
                MainMessagesView()
            } label: {
                HStack(spacing: 14) {
                    Image(image)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 22, height: 22)
                    
                    Text(title)
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
            }
        } else if title == "Settings" {
            NavigationLink {
                ProfileView()
            } label: {
                HStack(spacing: 14) {
                    Image(image)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 22, height: 22)
                    
                    Text(title)
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        } else {
            NavigationLink {
                ListCenterView()
            } label: {
                HStack(spacing: 14) {
                    Image(image)
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 22, height: 22)
                    
                    Text(title)
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        
    }
}

struct SlideMenu_Previews: PreviewProvider {
    static var previews: some View {
        SlideMenu(showMenu: .constant(true))
    }
}

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}
