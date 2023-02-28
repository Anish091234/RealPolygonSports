//
//  CreateAnnouncementView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/4/23.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CreateNewAnnouncement: View {
    var center: Center
    /// - Callbacks
    var onPost: (Announcement)->()
    
    /// - Post Properties
    @State private var postText: String = ""
    @State private var postImageData: Data?
    @State private var postDesc: String = ""
    /// - Stored User Data From UserDefaults(AppStroage)
    
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
    @FocusState private var showKeybord: Bool
    
    var body: some View {
        VStack {
            
            //MARK: Post + Cancel Button
            HStack {
                Menu {
                    Button("Cancel", role: .destructive) {
                        dismiss()
                    }
                } label: {
                    Text("Cancel")
                        .font(.custom("LexendDeca-Regular", size: 15))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
                .hAlign(.leading)
                
                Button(action: createPost) {
                    Text("Post")
                        .font(.custom("LexendDeca-Regular", size: 16))
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 6)
                        .background(colorScheme == .dark ? .white : .black, in: Capsule())
                }
                .disableWithOpacity(postText == "")
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                Rectangle()
                    .fill(.gray.opacity(0.05))
                    .ignoresSafeArea()
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    TextField("Whats Happening?", text: $postText, axis: .vertical)
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .padding(15)
                        .focused($showKeybord)
                    
                    TextField("Description", text: $postDesc, axis: .vertical)
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .padding(15)
                        .focused($showKeybord)
                    
                    //MARK: Display Image if User selects one
                    if let postImageData, let iamge = UIImage(data: postImageData) {
                        GeometryReader {
                            let size = $0.size
                            Image(uiImage: iamge)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .overlay(alignment: .topTrailing) {
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            self.postImageData = nil
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                            .tint(.red)
                                    }
                                    .padding(10)

                                }
                        }
                        .clipped()
                        .frame(height: 220)
                    }
                }
                .padding(15)
            }
            
            Divider()
            
            //MARK: Import Image
            HStack {
                Button {
                    showImagePicker.toggle()
                } label: {
                    Image(systemName: "photo.on.rectangle")
                        .font(.title3)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
                .hAlign(.leading)
                
                Button("Done") {
                    showKeybord = false
                }
                .font(.custom("LexendDeca-Regular", size: 18))
                .foregroundColor(colorScheme == .dark ? .white : .black)

            }
            .foregroundColor(.black)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
        }
        .vAlign(.top)
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            if let newValue {
                Task {
                    if let rawImageData = try? await newValue.loadTransferable(type: Data.self), let image = UIImage(data: rawImageData), let compressedImageData = image.jpegData(compressionQuality: 0.5) {
                        await MainActor.run(body: {
                            postImageData = compressedImageData
                            photoItem = nil
                        })
                    }
                }
            }
        }
        .alert(errorMessage, isPresented: $showError, actions: {})
        .overlay {
            LoadingView(show: $isLoading)
        }
    }
    
    //MARK: Post Content to Firebase
    
    func createPost() {
        isLoading = true
        showKeybord = false
        Task {
            do {
                
                let imageReferenceID = "\(userUID)\(Date())"
                let storageRef = Storage.storage().reference().child("Post_Images").child(imageReferenceID)
                if let postImageData {
                    let _ = try await storageRef.putDataAsync(postImageData)
                    let downloadURL = try await storageRef.downloadURL()
                    
                    let announcement = Announcement(title: postText, description: postDesc, date: Date(),imageURL: downloadURL, imageReferenceID: imageReferenceID, centerID: center.id!)
                    
                    try await createDocumentAtFirebase(announcement)
                    
                } else {
                    let announcement = Announcement(title: postText, description: postDesc, date: Date(), centerID: center.id!)
                    try await createDocumentAtFirebase(announcement)
                }
            } catch {
                await setError(error)
            }
        }
    }
    
    func createDocumentAtFirebase(_ announcement: Announcement) async throws {
        
        let doc = Firestore.firestore().collection("Announcement").document()
        let _ = try doc.setData(from: announcement, completion: { error in
            if error == nil {
                isLoading = false
                var updatedAnnouncement = announcement
                updatedAnnouncement.id = doc.documentID
                onPost(updatedAnnouncement)
                dismiss()
            }
        })
    }
    
    func setError(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

struct CreateNewAnnouncement_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewAnnouncement(center: Center(title: "", headCoach: "", coaches: [], students: [], address: "", lat: 0.0, lng: 0.0, sport: "", uid: "asdfasdfsa")) {_ in
            
        }
        .preferredColorScheme(.dark)
    }
}

