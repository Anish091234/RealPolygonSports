//
//  LoginView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 12/31/22.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import AuthenticationServices

struct LoginView: View {
    
    //MARK: User Details
    @State var emailID: String = ""
    @State var password: String = ""
    
    //MARK: View Properties
    @State var createAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    
    //MARK: User defaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var authModel: AuthViewModel

    var body: some View {
        VStack (spacing: 10){
            Text("Lets Sign You In")
                .font(.custom("LexendDeca-Regular", size: 30))
                .bold()
            Text("Welcome Back")
                .font(.custom("LexendDeca-Regular", size: 18))
                .hAlign(.leading)
                .padding()
                .bold()
            
            VStack (spacing: 12){
                TextField("Email", text: $emailID)
                    .font(.custom("LexendDeca-Regular", size: 18))
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .padding(.top, 25)
                SecureField("Password", text: $password)
                    .font(.custom("LexendDeca-Regular", size: 18))
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                
                Button {
                    resetPassword()
                } label: {
                    Text("Reset Pasword?")
                        .font(.custom("LexendDeca-Regular", size: 16))
                        .fontWeight(.medium)
                        .tint(colorScheme == .dark ? .black : .white)
                        .hAlign(.trailing)
                }
                
                Button {
                    loginUser()
                } label: {
                    Text("Sign In")
                }
                .font(.custom("LexendDeca-Regular", size: 20))
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .hAlign(.center)
                .fillView(colorScheme == .dark ? .white : .black)
                .padding(.top, 10)
                
                //SignInWithApple()
                
            }
            .padding(.leading, 10)
            .padding(.trailing, 10)
            
            //MARK: Register Button
            HStack {
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                Button("Register Now") {
                    createAccount.toggle()
                }
                .font(.custom("LexendDeca-Regular", size: 18))
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? .white : .black)
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(.top, 15)
        .fullScreenCover(isPresented: $createAccount) {
            RegisterView()
        }
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        //MARK: Displaying Alert
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
    func loginUser() {
        isLoading = true
        closeKeyboard()
        Task {
            do {
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("User Found")
                isLoading = false
                try await fetchUser()
            } catch {
                await setError(error)
            }
        }
    }
    
    func resetPassword() {
        Task {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("Link Sent")
            } catch {
                await setError(error)
            }
        }
    }
    
    func fetchUser() async throws {
        print("entered fetch users")
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        await MainActor.run(body: {
            userUID = userID
            userNameStored = user.username
            profileURL = user.userProfileURL
            logStatus = true
        })
        print(logStatus)
    }
    
    //MARK: Display Errors VIA Alert
    func setError(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
    }
}




