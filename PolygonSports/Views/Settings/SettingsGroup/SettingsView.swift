//
//  SettingsView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/18/23.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Firebase

struct SettingsView: View {
    
    var isFromNavigationLink: Bool
    var options = ["Posts", "Account Settings"]
    
    //MARK: My Profile Data
    @State private var myProfile: User?
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @State var isLoading: Bool = false
    @State var isPresented: Bool = false
    @State var isCreateChildPresented: Bool = false
    @State var isCreatePlayerPresented: Bool = false
    @State var selection: String = "Account Settings"
    @State var accountCategory = ["Student", "Coach", "Parent"]
    @State var accountType1: String = ""
    @State private var posts: [Post] = []
    @State private var isNotCoach: Bool = false
    
    @AppStorage("user_match_doc_url") var matchDocURL: String = ""
    @AppStorage("isOnboarding_done") var isOnboardingDone: Bool = false
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("account_type") var accountType: String = ""
    @AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_rating") var userRating: String = ""
    @AppStorage("account_has_child") var childAccount: Bool = false
    @AppStorage("account_child_rating") var childRating = ""
    @AppStorage("account_child_email") var childEmail = ""
    @AppStorage("account_child_age") var childAge = ""
    @AppStorage("account_child_UUID") var childUID = ""
    @AppStorage("account_child_name") var childName = ""
    @AppStorage("hasPlayerAccount") var playerAccountRegistered = false
    @AppStorage("user_center") var centerName = ""
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_match_document_exists") var matchDocumentExists: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                //MARK: Background
                Group {
                    Color("backgroundColor")
                        .ignoresSafeArea()
                    VStack {
                        Circle()
                            .frame(width: 150.0, height: 150.0)
                            .offset(x: 180, y: -320)
                        
                        Circle()
                            .frame(width: 150.0, height: 150.0)
                            .offset(x: -180, y: -200)
                    }
                    .foregroundColor(.secondary)
                    
                    GeometryReader { gr in
                        VStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color.secondary)
                                .frame(height: gr.size.height * 0.6)
                                .offset(y: 40)
                        }
                    }
                }
                
                //MARK: Menu (logout + background)
                Menu {
                    Button("Log Out") {
                        logOutUser()
                        isOnboardingDone = false
                    }
                    
                    Button("Delete Account") {
                        deleteAccount()
                        isOnboardingDone = false
                    }
                    
                } label: {
                    Image(systemName: "gear")
                        .rotationEffect(.init(degrees: 90))
                        .tint(colorScheme == .dark ? .white : .black)
                        .scaleEffect(1.2)
                }
                .padding(.bottom, 745)
                .padding(.leading, 300)

                
                VStack(spacing: 16.0) {
                    
                    //MARK: User Text
                    VStack {
                        WebImage(url: profileURL).placeholder{
                            Image(systemName: "photo")
                                .foregroundColor(.white)
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 65, height: 65)
                        .clipShape(Circle())
                        
                        Text(userNameStored)
                            .font(.custom("LexendDeca-Regular", size: 30))
                            .foregroundColor(.white)
                            .bold()
                        Text(accountType)
                            .font(.custom("LexendDeca-Regular", size: 12))
                            .foregroundColor(.white)
                            .padding(.bottom, 20)
                    }
                    
                    //MARK: Navigation Rectangles
                    ScrollView(showsIndicators: false) {
                        
                        //MARK: Recent Matches(done) + Manage Players(not done)
                        HStack(spacing: 16.0) {
                            
                            //MARK: Recent Matches
                            NavigationLink {
                                RecentMatches()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.black)
                                        .frame(width: 160, height: 160)
                                    
                                    Text("Recent \n Matches")
                                        .font(.custom("LexendDeca-Regular", size: 17))
                                        .foregroundColor(Color.white)
                                        .bold()
                                }
                            }

                            //MARK: Manage Players
                            NavigationLink {
                                ManagePlayersView()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.black)
                                        .frame(width: 160, height: 160)
                                    
                                    Text("Manage Players")
                                        .font(.custom("LexendDeca-Regular", size: 17))
                                        .foregroundColor(Color.white)
                                        .bold()
                                }
                            }
                        }
                        
                        //MARK: Upcoming Events(not done) + Your Posts(done)
                        HStack(spacing: 16.0) {
                            //MARK: Upcoming Events
                            NavigationLink {
                                UpcomingEventsView()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.black)
                                        .frame(width: 160, height: 160)
                                    
                                    Text("Upcoming \n Events")
                                        .font(.custom("LexendDeca-Regular", size: 20))
                                        .foregroundColor(Color.white)
                                        .bold()
                                }
                            }

                            //MARK: Posts
                            NavigationLink {
                                ViewRecentPostsView(posts: $posts)
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.black)
                                        .frame(width: 160, height: 160)
                                    
                                    Text("Posts")
                                        .font(.custom("LexendDeca-Regular", size: 20))
                                        .foregroundColor(Color.white)
                                        .bold()
                                }
                            }
                        }
                        
                        //MARK: Coach(not done) + Lessons
                        HStack(spacing: 16.0) {
                            
                            //MARK: Coach
                            NavigationLink {
                                CoachDashboardView()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.black)
                                        .frame(width: 160, height: 160)
                                    
                                    Text("Coach \n Dashboard")
                                        .font(.custom("LexendDeca-Regular", size: 20))
                                        .foregroundColor(Color.white)
                                        .bold()
                                }
                            }
                            .disabled(isNotCoach)

                            NavigationLink {
                                LessonsView(isNavRequest: true)
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.black)
                                        .frame(width: 160, height: 160)
                                    
                                    Text("Lessons")
                                        .font(.custom("LexendDeca-Regular", size: 20))
                                        .foregroundColor(Color.white)
                                        .bold()
                                }
                            }
                        }
                    }
                }
                .padding(.all)
                .padding(.top, isFromNavigationLink ? 55 : 0)
                
                
            }
            .overlay(content: {
                LoadingView(show: $isLoading)
            })
            .alert(errorMessage, isPresented: $showError, actions: {})
            .task {
                if myProfile != nil {return}
                await fetchUserData()
                if accountType == "Coach" {
                    isNotCoach = false
                } else {
                    isNotCoach = true
                }
                
            }
        }
    }
    
    func fetchUserData() async {
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        let user = try? await Firestore.firestore().collection("Users").document(userUID).getDocument(as: User.self)
        await MainActor.run(body: {
            myProfile = user
        })
    }
    
    func setError(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
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
        matchDocumentExists = false
        userNameStored = ""
        userRating = ""
        userUID = ""
        centerName = ""
        matchDocURL = ""
    }
    
    func deleteAccount() {
        isLoading = true
        Task {
            do {
                guard let userUID = Auth.auth().currentUser?.uid else {return}
                let refrence = Storage.storage().reference().child("Profile_Images").child(userUID)
                try await refrence.delete()
                try await Firestore.firestore().collection("Users").document(userUID).delete()
                try await Auth.auth().currentUser?.delete()
                logStatus = false
                isLoading = false
            } catch {
                await setError(error)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isFromNavigationLink: false)
        //.preferredColorScheme(.dark)
    }
}

