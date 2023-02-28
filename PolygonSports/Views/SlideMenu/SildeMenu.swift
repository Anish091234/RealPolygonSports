//
//  SideMenu.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/22/23.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth

struct SlideMenu: View {
    @Binding var showMenu: Bool
    @AppStorage("user_name") private var username: String = ""
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("account_type") var accountType: String = ""
    
    @AppStorage("isOnboarding_done") var isOnboardingDone: Bool = false
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("user_rating") var userRating: String = ""
    @AppStorage("account_has_child") var childAccount: Bool = false
    @AppStorage("account_child_rating") var childRating = ""
    @AppStorage("account_child_email") var childEmail = ""
    @AppStorage("account_child_age") var childAge = ""
    @AppStorage("account_child_UUID") var childUID = ""
    @AppStorage("account_child_name") var childName = ""
    @AppStorage("hasPlayerAccount") var playerAccountRegistered = false
    @AppStorage("user_center") var centerName = ""
    
    
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
                Text(accountType)
                    .font(.custom("LexendDeca-Regular", size: 12))
                    .padding(.bottom, 20)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 45) {
                        TabButton(title: "Tournaments", image: "profile")
                        
                        TabButton(title: "Text", image: "messages")
                        
                        TabButton(title: "Dashboard", image: "gear")
                        
                        TabButton(title: "Centers", image: "Home")
                        
                    }
                }
                
                Divider()
                
                TabButton(title: "Info", image: "Info")
                
                Button {
                    logOutUser()
                } label: {
                    HStack(spacing: 14) {
                        Image("leave")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 22, height: 22)
                            .padding(.leading, 1.5)
                        
                        Text("Log Out")
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.custom("LexendDeca-Regular", size: 18))
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
        } else if title == "Dashboard" {
            NavigationLink {
                SettingsView(isFromNavigationLink: true)
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
        } else if title == "Centers" {
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
        } else if title == "Info" {
            NavigationLink {
                InfoView()
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
                SettingsView(isFromNavigationLink: true)
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
    
    func logOutUser() {
        try? Auth.auth().signOut()
        logStatus = false
        playerAccountRegistered = true
        childAccount = false
        childRating = ""
        childEmail = ""
        childAge = ""
        childUID = ""
        childName = ""
        username = ""
        userRating = ""
        userUID = ""
        centerName = ""
        profileURL = nil
        accountType = ""
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
