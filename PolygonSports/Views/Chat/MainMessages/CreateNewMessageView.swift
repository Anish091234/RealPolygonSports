//
//  CreateNewMessageView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/5/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestore

class CreateNewMessageViewModel: ObservableObject {
    
    @Published var users = [ChatUser]()
    @Published var errorMessage = ""
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        FirebaseManager.shared.firestore.collection("users")
            .getDocuments { documentsSnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to fetch users: \(error)"
                    print("Failed to fetch users: \(error)")
                    return
                }
                
                documentsSnapshot?.documents.forEach({ snapshot in
                    let user = try? snapshot.data(as: ChatUser.self)
                    if user?.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        //self.users.append(user!)
                        self.users.append(user ?? ChatUser(uid: "", email: "", profileImageUrl: ""))
                    }
                    
                })
            }
    }
}

struct CreateNewMessageView: View {
    
    let didSelectNewUser: (ChatUser) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = CreateNewMessageViewModel()
    @State private var searchText: String = ""
    var body: some View {
        NavigationView {
            ScrollView {
                Text(vm.errorMessage)
                    .font(.custom("LexendDeca-Regular", size: 18))
                
                ForEach(vm.users) { user in
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                    } label: {
                        HStack(spacing: 16) {
                            WebImage(url: URL(string: user.profileImageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipped()
                                .cornerRadius(50)
                                .overlay(RoundedRectangle(cornerRadius: 50)
                                            .stroke(Color(.label), lineWidth: 2)
                                )
                            Text(user.email)
                                .font(.custom("LexendDeca-Regular", size: 18))
                                .foregroundColor(Color(.label))
                            Spacer()
                        }.padding(.horizontal)
                    }
                    Divider()
                        .padding(.vertical, 8)
                }
                .searchable(text: $searchText)
                .onSubmit(of: .search) {
                    Task {
                        await searchSpecificUser()
                    }
                }
                .onChange(of: searchText) { newValue in
                    if newValue.isEmpty {
                        vm.users = []
                    }
                }
            }.navigationTitle("New Message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                                .font(.custom("LexendDeca-Regular", size: 18))
                        }
                    }
                }
        }
    }
    
    func searchSpecificUser() async {
        do {
            
            let documents = try await Firestore.firestore().collection("users")
                .whereField("email", isGreaterThanOrEqualTo: searchText)
                .whereField("email", isLessThanOrEqualTo: "\(searchText)\u{f8ff}")
                .getDocuments()
            
            let users = try documents.documents.compactMap { doc -> ChatUser? in
                try doc.data(as: ChatUser.self)
            }
            
            await MainActor.run(body: {
                vm.users = users
            })
            
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct CreateNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        //CreateNewMessageView()
        MainMessagesView()
    }
}

