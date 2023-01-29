//
//  CreateNewPost.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 12/31/22.
//


import SwiftUI
import PhotosUI
import FirebaseStorage
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CreateNewPost: View {
    
    /// - Callbacks
    var onPost: (Post)->()
    
    
    /// - Post Properties
    @State private var postText: String = ""
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
    @FocusState private var showKeybord: Bool
    
    var body: some View {
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
                guard let profileURL = profileURL else {return}
                let imageReferenceID = "\(userUID)\(Date())"
                let storageRef = Storage.storage().reference().child("Post_Images").child(imageReferenceID)
                if let postImageData {
                    let _ = try await storageRef.putDataAsync(postImageData)
                    let downloadURL = try await storageRef.downloadURL()
                    
                    let post = Post(text: postText, imageURL: downloadURL, imageReferenceID: imageReferenceID, userName: username, userUID: userUID, userProfileURL: profileURL)
                    
                    try await createDocumentAtFirebase(post)
                    
                } else {
                    let post = Post(text: postText, userName: username, userUID: userUID, userProfileURL: profileURL)
                    try await createDocumentAtFirebase(post)
                }
            } catch {
                await setError(error)
            }
        }
    }
    
    
    func createDocumentAtFirebase(_ post: Post) async throws {
        
        let doc = Firestore.firestore().collection("Posts").document()
        let _ = try doc.setData(from: post, completion: { error in
            if error == nil {
                isLoading = false
                var updatedPost = post
                updatedPost.id = doc.documentID
                onPost(updatedPost)
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

struct CreateNewPost_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewPost {_ in
            
        }
        .preferredColorScheme(.dark)
    }
}

