//
//  CreateTournament.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/7/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore
import PhotosUI

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
    @AppStorage("user_center") var storedCenterName = ""
    
    /// - View Properites
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    @State private var numberOfGroups: Int = 0
    @State private var tournamentDate = Date.now
    @State private var rangeGroup1: String = ""
    @State private var rangeGroup2: String = ""
    @State private var address: String = ""
    @FocusState private var showKeybord: Bool
    
    //Picker
    @State private var numOfRepetitions: Int = 0
    @State private var tournamentStratingDate = Date.now
    
    var body: some View {
        NavigationStack {
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
                        
                        Button {
                            createTournament(num: numOfRepetitions)
                        } label: {
                            Text("Done")
                                .font(.custom("LexendDeca-Regular", size: 15))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 6)
                                .background(.black, in: Capsule())
                        }
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
                    
                    
                    DatePicker("Enter Date: ", selection: $tournamentDate)
                        .font(.custom("LexendDeca-Regular", size: 18))
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
                        Divider()
                        
                    }
                    Group {
                        TextField("Enter Address", text: $address)
                            .font(.custom("LexendDeca-Regular", size: 18))
                            .padding()
                            
                            .overlay(RoundedRectangle(cornerRadius: 50)
                                .stroke(Color(.blue), lineWidth: 2)
                            )
                            .padding()
                        
                        
                        Text("Number Of Repetitions")
                            .padding()
                            .font(.custom("LexendDeca-Regular", size: 20))
                            .bold()
                        Picker("Number of people", selection: $numOfRepetitions) {
                            ForEach(1 ..< 200) { reps in
                                Text("\(reps)")
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 100)  
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
    }
    
    func createTournament(num: Int) {
        isLoading = true
        showKeybord = false
        Task {
            do {
                
                if num > 1 {
                    for i in 0...num {
                        let currentDate = Date()
                        var dateComponent = DateComponents()
                        dateComponent.day = i * 7
                        let futureDate = Calendar.current.date(byAdding: (dateComponent), to: currentDate)
                        
                        let group1Range = Int(rangeGroup1) ?? 0
                        let group2Range = Int(rangeGroup2) ?? 0
                        
                        let tournament = Tournament(title: title, adminName: username, adminUID: userUID, publishedDate: Date(), tournamentDate: futureDate!, group1: [], group2: [], group3: [], group1End: group1Range, group2End: group2Range, address: address, center: storedCenterName)
                        try await createDocumentAtFirebase(tournament)
                        
                    }
                } else {
                    let group1Range = Int(rangeGroup1) ?? 0
                    let group2Range = Int(rangeGroup2) ?? 0
                    
                    let tournament = Tournament(title: title, adminName: username, adminUID: userUID, publishedDate: Date(), tournamentDate: tournamentDate, group1: [], group2: [], group3: [], group1End: group1Range, group2End: group2Range, address: address, center: storedCenterName)
                    try await createDocumentAtFirebase(tournament)
                }
                
                
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
