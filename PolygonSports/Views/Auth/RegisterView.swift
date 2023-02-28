//
//  RegisterView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 12/31/22.
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI
import AuthenticationServices
import FirebaseMessaging

//MARK: Register View
struct RegisterView: View {
    
    //MARK: User Details
    @State var emailID: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    @State var userBio: String = ""
    @State var userBioLink: String = ""
    @State var userProfilePicData: Data?
    @State var firebaseToken: String = ""
    //MARK: View Properties
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    //MARK: UserDefaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("account_type") var accountType: String = ""
    @AppStorage("account_email") var accountEmail: String = ""
    @AppStorage("user_image_data") var appImageData: Data!
    @State var loginStatusMessage: String = ""
    @State var accountCategory = ["Student", "Coach", "Parent"]
    @State var accountType1: String = ""
    
    var body: some View {
        VStack (spacing: 10){
            Text("Register Account")
                .font(.custom("LexendDeca-Regular", size: 28))
                .bold()
            //MARK: For smaller sizes -- optamization
            ViewThatFits {
                ScrollView(.vertical, showsIndicators: false) {
                    HelperView()
                }
                HelperView()
            }
            .padding()
            
            //MARK: Register Button
            HStack {
                Text("Already Have an account?")
                    .font(.custom("LexendDeca-Regular", size: 18))
                    .foregroundColor(.gray)
                Button("Login Now") {
                    dismiss()
                }
                .font(.custom("LexendDeca-Regular", size: 18))
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? .white : .black)
            }
            .font(.callout)
            .vAlign(.bottom)
        }
        .vAlign(.top)
        .padding(15)
        .overlay(content: {
            LoadingView(show: $isLoading)
        })
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            //MARK: Extracting UIImage from photoItem
            
            if let newValue {
                Task {
                    do {
                        guard let imageData = try await newValue.loadTransferable(type: Data.self) else {
                            return
                        }
                        await MainActor.run(body: {
                            userProfilePicData = imageData
                        })
                    } catch {
                        
                    }
                }
            }
        }
        //MARK: Displaying Alert
        .alert(errorMessage, isPresented: $showError, actions: {})
    }
    
    @ViewBuilder
    func HelperView() -> some View {
        VStack (spacing: 12){
            
            ZStack {
                if let userProfilePicData, let image = UIImage(data: userProfilePicData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image(systemName: "camera")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
            
            .frame(width: 85, height: 85)
            .clipShape(Circle())
            .onTapGesture {
                showImagePicker.toggle()
            }
            .padding(.top, 25)
            .padding()
            
            TextField("Username", text: $userName)
                .font(.custom("LexendDeca-Regular", size: 18))
                .autocorrectionDisabled()
                .border(1, .gray.opacity(0.5))
            
            TextField("Email", text: $emailID)
                .font(.custom("LexendDeca-Regular", size: 18))
                .textContentType(.emailAddress)
                .autocorrectionDisabled()
                .border(1, .gray.opacity(0.5))
            
            SecureField("Password", text: $password)
                .font(.custom("LexendDeca-Regular", size: 18))
                .textContentType(.emailAddress)
                .autocorrectionDisabled()
                .border(1, .gray.opacity(0.5))
            
            TextField("About You", text: $userBio)
                .font(.custom("LexendDeca-Regular", size: 18))
                .border(1, .gray.opacity(0.5))
            
            TextField("Link (Optional) ", text: $userBioLink)
                .font(.custom("LexendDeca-Regular", size: 18))
                .border(1, .gray.opacity(0.5))
            .padding(.top, 10)
            
            Picker("Choose Account Type", selection: $accountType1) {
                ForEach(accountCategory, id: \.self) { item in
                    Text(item)
                        .font(.custom("LexendDeca-Regular", size: 16))
                }
            }
            
            Button(action: registerUser){
                Text("Sign Up")
                    .foregroundColor(colorScheme == .dark ? .white : .white)
                    .hAlign(.center)
                    .fillView(.black)
            }
            .font(.custom("LexendDeca-Regular", size: 18))
            .background(colorScheme == .dark ? .white : .black)
            .cornerRadius(9)
        }
        .padding()
    }
    
    func registerUser() {
        print("entered Registered User")
        isLoading = true
        closeKeyboard()
        Task {
            do {
                try await Auth.auth().createUser(withEmail: emailID, password: password)
                print("Created User")
                guard let userUID = Auth.auth().currentUser?.uid else {return}
                guard let imageData = userProfilePicData else {return}
                let storageRef = Storage.storage().reference().child("Profile_Images").child(userUID)
            
                Messaging.messaging().token { token, error in
                    if let error = error {
                        print("Error fetching FCM registration token: \(error)")
                    } else if let token = token {
                        print("FCM registration token: \(token)")
                        firebaseToken = token
                    }
                }
                let _ = try await storageRef.putDataAsync(imageData)
                let downloadURL = try await storageRef.downloadURL()
                let user = User(username: userName, userBio: userBio, userBioLink: userBioLink, userUID: userUID, userEmail: emailID, userProfileURL: downloadURL, accountType: accountType1, firebaseMessageToken: firebaseToken)
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: { error in
                    if error == nil {
                        print("Saved Successfully")
                        userNameStored = userName
                        self.userUID = userUID
                        profileURL = downloadURL
                        logStatus = true
                        accountType = accountType1
                        accountEmail = emailID
                        appImageData = imageData
                    }
                })
                
                persistImageToStorage()
                storeUserInformation(imageProfileUrl: downloadURL)
                
                isLoading = false
            } catch {
                await setError(error)
            }
        }
    }
    
    //MARK: Display Errors VIA Alert
    func setError(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
    
    private func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = userProfilePicData else {return}
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                self.loginStatusMessage = "Failed to push image to Storage: \(err)"
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                
                self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                print(url?.absoluteString ?? "")
                
                guard let url = url else { return }
                self.storeUserInformation(imageProfileUrl: url)
            }
        }
    }
    
    private func storeUserInformation(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = [FirebaseConstants.email: self.emailID, FirebaseConstants.uid: uid, FirebaseConstants.profileImageUrl: imageProfileUrl.absoluteString]
        FirebaseManager.shared.firestore.collection(FirebaseConstants.users)
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    self.loginStatusMessage = "\(err)"
                    return
                }
                
                print("Success")
                
                //self.didCompleteLoginProcess()
            }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

