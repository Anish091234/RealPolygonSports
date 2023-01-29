//
//  CreateTournament.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/7/23.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct CreateTournament: View {
    
    /// - Callbacks
    var onPost: (Tournament)->()
    /// - Post Properties
    @State private var title: String = ""
    @State private var postImageData: Data?
    /// - Stored User Data From UserDefaults(AppStroage)
    @AppStorage("user_profile_url") private var profileURL: URL?
    @AppStorage("user_name") private var username: String = ""
    @AppStorage("user_UID") private var userUID: String = ""
    /// - View Properites
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    @State private var numberOfGroups: Int = 0
    @State private var ratingRange: String = ""
    @State private var tournamentDate = Date.now
    @State private var rangeGroup1: String = ""
    @State private var rangeGroup2: String = ""
    
    @FocusState private var showKeybord: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Menu {
                        Button("Cancel", role: .destructive) {
                            dismiss()
                        }
                    } label: {
                        Text("Cancel")
                            .font(.custom("LexendDeca-Regular", size: 15))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    } // Cancel Button
                    .hAlign(.leading)
                    
                    Button(action: createTournament) {
                        Text("Done")
                            .font(.custom("LexendDeca-Regular", size: 15))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 6)
                            .background(.black, in: Capsule())
                    } // Create Tournmanet Button
                    .disableWithOpacity(title == "")
                    
                } // Cancel + Create Button
                
                Divider()
                
                TextField("Title", text: $title)
                    .font(.custom("LexendDeca-Regular", size: 18))
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 50)
                        .stroke(Color(.blue), lineWidth: 2)
                    )
                    .padding()
                
                Divider()
                
                DatePicker(selection: $tournamentDate, in: ...Date.distantFuture, displayedComponents: .date) {
                    Text("Select a date")
                        .font(.custom("LexendDeca-Regular", size: 18))
                }
                .padding()
                
                Divider()
                
                Text("Select Rating Range: ")
                    .font(.custom("LexendDeca-Regular", size: 18))
                    .hAlign(.leading)
                    .bold()
                
                VStack {
                    TextField("Enter end range for group 1", text: $rangeGroup1)
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .padding()
                        .keyboardType(.numberPad)
                        .overlay(RoundedRectangle(cornerRadius: 50)
                            .stroke(Color(.blue), lineWidth: 2)
                        )
                        .padding()
                    
                    
                    
                    TextField("Enter end range for group 2", text: $rangeGroup2)
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .keyboardType(.numberPad)
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 50)
                            .stroke(Color(.blue), lineWidth: 2)
                        )
                        .padding()
                    
                    Text("Group 1: From 0 - \(rangeGroup1)")
                        .font(.custom("LexendDeca-Regular", size: 18))
                    
                    Text("Group 2: From \(rangeGroup1) to \(rangeGroup2)")
                        .font(.custom("LexendDeca-Regular", size: 18))
                    
                    Text("Group 3: From \(rangeGroup2) to ∞")
                        .font(.custom("LexendDeca-Regular", size: 18))
                }
                
                
            }
            .padding()
            .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
            .onChange(of: photoItem) { newValue in
                if let newValue {
                    Task {
                        if let rawImageData = try? await newValue.loadTransferable(type: Data.self), let image = UIImage(data: rawImageData), let compressedImageData = image.jpegData(compressionQuality: 1) {
                            await MainActor.run(body: {
                                postImageData = compressedImageData
                                photoItem = nil
                            })
                        }
                    }
                }
            }
            .overlay(content: {
                LoadingView(show: $isLoading)
            })
            .vAlign(.top)
        }
    }
    
    func createTournament() {
        isLoading = true
        showKeybord = false
        Task {
            do {
                let group1Range = Int(rangeGroup1) ?? 0
                let group2Range = Int(rangeGroup2) ?? 0
                
                
                let tournament = Tournament(title: title, adminName: username, adminUID: userUID, publishedDate: Date(), tournamentDate: tournamentDate, group1: [], group2: [], group3: [], group1End: group1Range, group2End: group2Range)
                try await createDocumentAtFirebase(tournament)
            } catch {
                await setError(error)
            }
        }
    }
    
    func createDocumentAtFirebase(_ tournament: Tournament) async throws {
        
        let doc = Firestore.firestore().collection("Tournaments").document()
        print(doc)
        let _ = try doc.setData(from: tournament, completion: { error in
            if error == nil {
                isLoading = false
                var updatedTournament = tournament
                updatedTournament.id = doc.documentID
                onPost(updatedTournament)
                dismiss()
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

struct CreateTournament_Previews: PreviewProvider {
    static var previews: some View {
        CreateTournament { _ in
            
        }
        .preferredColorScheme(.dark)
    }
}
