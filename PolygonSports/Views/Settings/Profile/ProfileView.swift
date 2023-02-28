//
//  ProfileView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 12/31/22.
//


import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import Firebase

struct ProfileView: View {
    //MARK: My Profile Data
    var isFromNavigationLink: Bool
    
    @State private var myProfile: User?
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @State var isLoading: Bool = false
    @State var isPresented: Bool = false
    @State var isCreateChildPresented: Bool = false
    @State var isCreatePlayerPresented: Bool = false
    @State var selection: String = "Account Settings"
    @Environment(\.colorScheme) var colorScheme
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
    var options = ["Posts", "Account Settings"]
    @State var accountCategory = ["Student", "Coach", "Parent"]
    @State var accountType1: String = ""
    @AppStorage("user_image_data") var appImageData: Data!
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color.gray.opacity(0.4)
                VStack {
                                        
                    ScrollView(showsIndicators: false) {
                        
                        VStack {
                                    
                            Picker("Holder Text", selection: $selection) {
                                ForEach(options, id: \.self) { option in
                                    Text(option)
                                        .font(.custom("LexendDeca-Regular", size: 18))
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            if selection == "Posts" {
                                if let myProfile {
                                    ResusableProfileContent(user: myProfile)
                                        .refreshable {
                                            self.myProfile = nil
                                            await fetchUserData()
                                        }
                                        .padding()
                                } else {
                                    ProgressView()
                                        .padding()
                                }
                            } else  {
                                
                                if accountType == "" {
                                    Picker("Choose Account Type", selection: $accountType1) {
                                        ForEach(accountCategory, id: \.self) { item in
                                            Text(item)
                                                .font(.custom("LexendDeca-Regular", size: 18))
                                        }
                                    }.onChange(of: accountType1) { newValue in
                                        accountType = newValue
                                    }
                                } else {
                                    Text("Account Type: \(accountType)")
                                        .font(.custom("LexendDeca-Regular", size: 18))
                                        .bold()
                                        .font(.title3)
                                }
                                
                                if accountType == "Student" {
                                    
                                    StudentSelectionView()
                                    
                                } else if accountType == "Parent" {
                                    
                                    ParentSelectionView()
                                    
                                } else { //Coach Account Type
                                    
                                    CoachSelectionView()
                                    
                                }
                            }
                        }
                        .padding()
                    }
                    .padding(.top, isFromNavigationLink ? 40 : 0)
                }
            }
            
            .navigationTitle("My Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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
                            .scaleEffect(0.8)
                    }
                }
            }
        }
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        .alert(errorMessage, isPresented: $showError, actions: {})
        .task {
            if myProfile != nil {return}
            await fetchUserData()
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
        appImageData = nil
        userNameStored = ""
        userRating = ""
        userUID = ""
        centerName = ""
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isFromNavigationLink: false)
    }
}
