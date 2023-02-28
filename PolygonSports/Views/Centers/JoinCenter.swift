//
//  JoinTournament.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/28/23.
//

import SwiftUI
import FirebaseStorage
import Firebase

struct JoinCenterView: View {
    var center: Center
    var accountType: String
    @State var errorMessage: String = ""
    @State var showError: Bool = false
    @AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_rating") var userRating: String = ""
    @AppStorage("account_child_UUID") var childUID = ""
    @AppStorage("account_type") var storedAccountType: String = ""
    @AppStorage("account_child_name") var childName = ""
    @AppStorage("hasPlayerAccount") var playerAccountRegistered = false
    @AppStorage("account_child_rating") var childRating = ""
    @AppStorage("user_center") var storedCenterName = ""
    @State var joinedCenter: Bool = false
    var body: some View {
        Text("Name: \(userNameStored)")
            .font(.custom("LexendDeca-Regular", size: 18))
        Text("Rating: \(userRating)")
            .font(.custom("LexendDeca-Regular", size: 18))
        
        if accountType == "Student" {
            Button {
                joinCenter()
                joinedCenter.toggle()
            } label: {
                Text("Join Center")
                    .font(.custom("LexendDeca-Regular", size: 18))
            }
            .buttonStyle(.bordered)
            .disabled(joinedCenter)
        } else if accountType == "Parent" {
            if childName == "" {
                // No Child Set
                Button {
                    joinCenter()
                    joinedCenter.toggle()
                } label: {
                    Text("Join Center")
                        .font(.custom("LexendDeca-Regular", size: 18))
                }
                .buttonStyle(.bordered)
                .disabled(joinedCenter)
            } else {
                // Child Set
                HStack {
                    Button {
                        joinCenter()
                        joinedCenter.toggle()
                    } label: {
                        Text("Join as \(userNameStored)")
                            .font(.custom("LexendDeca-Regular", size: 18))
                    }
                    .buttonStyle(.bordered)
                    .disabled(joinedCenter)
                    
                    Text("Or")
                        .font(.custom("LexendDeca-Regular", size: 18))
                    
                    Button  {
                        joinChildCenter()
                        joinedCenter.toggle()
                    } label: {
                        Text("Join as \(childName)")
                            .font(.custom("LexendDeca-Regular", size: 18))
                    }
                    .buttonStyle(.bordered)
                    .disabled(joinedCenter)
                }
                
                Text("\(childName)'s Rating: \(childRating)")
                    .font(.custom("LexendDeca-Regular", size: 18))
            }
            
        } else {
            Button {
                joinCenter()
                joinedCenter.toggle()
            } label: {
                Text("Join Center")
                    .font(.custom("LexendDeca-Regular", size: 18))
            }
            .buttonStyle(.bordered)
            .disabled(joinedCenter)
        }
        
    }
    func joinCenter() {
        Task {
            guard let centerID = center.id else {return}
            if center.students.contains(userNameStored) {
                ///Leave the tournament
                
                try await Firestore.firestore().collection("Center").document(centerID).updateData([
                    "students" : FieldValue.arrayRemove([userNameStored])
                ])
                
            } else {
                ///Join Tournament
                
                try await Firestore.firestore().collection("Center").document(centerID).updateData([
                    "students" : FieldValue.arrayUnion([userNameStored])
                ])
            }
            storedCenterName = center.title
        }
    }
    
    func joinChildCenter() {
        Task {
            print("childName: \(childName)")
            print("ChildUID: \(childUID)")
            
            guard let centerID = center.id else {return}
            if center.students.contains(childName) {
                ///Leave the tournament
                try await Firestore.firestore().collection("Center").document(centerID).updateData([
                    "students" : FieldValue.arrayRemove([childName])
                ])
            } else {
                ///Join Tournament
                
                try await Firestore.firestore().collection("Center").document(centerID).updateData([
                    "students" : FieldValue.arrayUnion([childName])
                ])
            }
        }
        storedCenterName = center.title
    }
    
    func setError(_ error: String) async {
        await MainActor.run(body: {
            errorMessage = error
            showError.toggle()
        })
    }
}



struct JoinCenterView_Previews: PreviewProvider {
    static var previews: some View {
        JoinCenterView(center: Center(title: "poop", headCoach: "poop", coaches: [], students: [], address: "poop", lat: 12.12, lng: 12.12, sport: "poop", uid: "asdfa"), accountType: "Student")
    }
}
