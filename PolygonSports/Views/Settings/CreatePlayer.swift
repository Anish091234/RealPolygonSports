//
//  CreatePlayer.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/10/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct CreatePlayer: View {
    
    @State var name: String = ""
    @State var email: String = ""
    @State var age: String = ""
    @State var rating: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @Environment(\.dismiss) private var dismiss
    @FocusState private var showKeybord: Bool
    @AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("user_name") private var username: String = ""
    @AppStorage("hasPlayerAccount") var playerAccountRegistered = false
    @AppStorage("account_email") var accountEmail: String = ""
    @AppStorage("user_rating") var userRating: String = ""
    var body: some View {
        VStack {
            
            Menu {
                Button("Cancel", role: .destructive) {
                    dismiss()
                }
                .font(.custom("LexendDeca-Regular", size: 15))
                
            } label: {
                Text("Cancel")
                    .font(.custom("LexendDeca-Regular", size: 15))
                    .foregroundColor(.black)
                
            }
            .buttonStyle(BorderedButtonStyle())
            .hAlign(.leading)
            
            Text("Add A Player")
                .font(.custom("LexendDeca-Regular", size: 18))
                .bold()
                .padding()
            
            Text("Adding a player is simple and easy, and you can enter into tournaments and more!")
                .font(.custom("LexendDeca-Regular", size: 18))
                .fontWeight(.semibold)
            
            Text("Name: \(username)")
                .font(.custom("LexendDeca-Regular", size: 18))
                .fontWeight(.medium)
                .padding()
            Text("Email: \(accountEmail)")
                .font(.custom("LexendDeca-Regular", size: 18))
                .fontWeight(.medium)
                .padding()
            TextField("Age", text: $age)
                .font(.custom("LexendDeca-Regular", size: 18))
                .autocorrectionDisabled()
                .modifier(customViewModifier(roundedCornes: 6, startColor: .yellow, endColor: .cyan, textColor: .white))
                .padding()
            TextField("Rating", text: $rating)
                .font(.custom("LexendDeca-Regular", size: 18))
                .autocorrectionDisabled()
                .modifier(customViewModifier(roundedCornes: 6, startColor: .red, endColor: .mint, textColor: .white))
                .padding()
            
            Button("Done") {
                print(username)
                print(accountEmail)
                print(age)
                print(rating)
                createPlayer()
            }
            .font(.custom("LexendDeca-Regular", size: 18))
            .modifier(customViewModifier(roundedCornes: 6, startColor: .orange, endColor: .purple, textColor: .white))
            
        }
        .alert(errorMessage, isPresented: $showError, actions: {})
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
    }
    
    func createPlayer() {
        isLoading = true
        showKeybord = false
        Task {
            do {
                let playerAge = Int(age)
                let playerRating = Int(rating)
                
                userRating = rating
                
                let child = Player(id: userUID, name: username, email: accountEmail, rating: playerRating ?? 0, age: playerAge ?? 0, isChildAccount: false, parentAccountUID: userUID, parentName: "", parentEmail: "", playerUID: "")
                
                try await createDocumentAtFirebase(child)
                
            } catch {
                await setError(error)
            }
        }
    }
    
    func setError(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
    
    func createDocumentAtFirebase(_ player: Player) async throws {

        let doc = Firestore.firestore().collection("Players").document()
        let _ = try doc.setData(from: player, completion: { error in
            if error == nil {
                isLoading = false
                playerAccountRegistered = true
                dismiss()

            }
        })
    }
    
}

struct CreatePlayer_Previews: PreviewProvider {
    static var previews: some View {
        CreatePlayer()
    }
}

