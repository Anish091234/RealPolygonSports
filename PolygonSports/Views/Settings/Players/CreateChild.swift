//
//  CreateChild.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/9/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct CreateChild: View {
    
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
    @AppStorage("account_email") var accountEmail: String = ""
    @AppStorage("account_has_child") var childAccount: Bool = false
    @AppStorage("account_child_name") var childName = ""
    @AppStorage("account_child_rating") var childRating = ""
    @AppStorage("account_child_email") var childEmail = ""
    @AppStorage("account_child_age") var childAge = ""
    @AppStorage("account_child_UUID") var childUID = ""
    //@AppStorage("children") var children: [Player] = []
    @State private var childUID1 = ""
    var body: some View {
        VStack {
            
            Menu {
                Button("Cancel", role: .destructive) {
                    dismiss()
                }
                
            } label: {
                Text("Cancel")
                    .font(.custom("LexendDeca-Regular", size: 15))
                    .foregroundColor(.black)
                
            }
            .buttonStyle(BorderedButtonStyle())
            .hAlign(.leading)
            
            Text("Add A Child")
                .font(.custom("LexendDeca-Regular", size: 18))
                .bold()
                .padding()
            
            Text("Adding a child is simple and easy, and you can enter them into tournaments and more!")
                .font(.custom("LexendDeca-Regular", size: 18))
                .fontWeight(.semibold)
            
            TextField("Child's Name", text: $name)
                .font(.custom("LexendDeca-Regular", size: 18))
                .autocorrectionDisabled()
                .modifier(customViewModifier(roundedCornes: 6, startColor: .orange, endColor: .purple, textColor: .white))
                .padding()
            
            TextField("Child's Email (You may put your own)", text: $email)
                .font(.custom("LexendDeca-Regular", size: 18))
                .autocorrectionDisabled()
                .modifier(customViewModifier(roundedCornes: 6, startColor: .green, endColor: .indigo, textColor: .white))
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
                createChild()
            }
            .modifier(customViewModifier(roundedCornes: 6, startColor: .orange, endColor: .purple, textColor: .white))
            .font(.custom("LexendDeca-Regular", size: 18))
            
        }
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
    }
    
    func createChild() {
        isLoading = true
        showKeybord = false
        Task {
            do {
                //let tournament = Tournament(title: title, adminName: username, adminUID: userUID, publishedDate: Date(), tournamentDate: tournamentDate)
                
                let playerAge = Int(age)
                let playerRating = Int(rating)
                childUID1 = UUID().uuidString
                
                let child = Player(id: childUID1, name: name, email: email, rating: playerRating ?? 0, age: playerAge ?? 0, isChildAccount: true, parentAccountUID: userUID, parentName: username, parentEmail: accountEmail, playerUID: childUID1)
                
                try await createDocumentAtFirebase(child)
            } catch {
                await setError(error)
            }
        }
    }
    
    func createDocumentAtFirebase(_ player: Player) async throws {
        print(childUID1)
        let doc = Firestore.firestore().collection("Players").document()
        let _ = try doc.setData(from: player, completion: { error in
            if error == nil {
                isLoading = false
                dismiss()
                childAccount = true
                childName = name
                childEmail = email
                childAge = age
                childRating = rating
                childUID = childUID1
            }
        })
    }
    
    func setError(_ error: Error)async{
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
    
}

struct CreateChild_Previews: PreviewProvider {
    static var previews: some View {
        CreateChild()
    }
}


