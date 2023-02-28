//
//  CreateNewLessonView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/27/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CreateNewLessonView: View {

    @AppStorage("user_center") var savedCenterName = ""
    @AppStorage("user_center_uid") var savedCenterUID = ""
    @AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("account_has_child") var childAccount: Bool = false
    @AppStorage("account_child_UUID") var childUID = ""
    @AppStorage("account_child_name") var childName = ""
    
    var isRequest: Bool
    
    @State private var stringDuration: String = ""
    @State private var lessonDate = Date.now
    @State private var coaches: [String] = []
    @State private var selectedCoach: String = ""
    @State private var coachUID: String = ""
    @State private var isFetching: Bool = false
    @State private var token: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.gray)
                    .opacity(0.7)
                    .ignoresSafeArea()
                
                VStack {
                    //MARK: Title + Request Button
                    HStack {
                        Text(isRequest ? "Request A Lesson" : "Create A Lesson")
                            .font(.custom("LexendDeca-Regular", size: isRequest ? 18 : 20))
                            .hAlign(.leading)
                            .padding()
                        
                        if childAccount == true {
                            Menu {
                                Button(isRequest ? "Request as \(childName)" : "Create as \(childName)") {
                                    if isRequest {
                                        requestLesson(child: true)
                                    } else  {
                                        createLesson(child: true)
                                    }
                                }
                                
                                Button(isRequest ? "Request as \(userNameStored)" : "Create as \(userNameStored)") {
                                    if isRequest {
                                        requestLesson(child: false)
                                    } else  {
                                        createLesson(child: false)
                                    }
                                }

                            } label: {
                                Text(isRequest ? "Request" : "Create")
                                    .font(.custom("LexendDeca-Regular", size: 17))
                            }
                            .hAlign(.trailing)
                            .padding()
                            .foregroundColor(Color.black)
                            .buttonStyle(BorderedButtonStyle())
                        } else {
                            Button {
                                if isRequest {
                                    requestLesson(child: false)
                                } else  {
                                    createLesson(child: false)
                                }
                            } label: {
                                Text(isRequest ? "Request" : "Create")
                                    .font(.custom("LexendDeca-Regular", size: 17))
                            }
                            .hAlign(.trailing)
                            .padding()
                            .foregroundColor(Color.black)
                            .buttonStyle(BorderedButtonStyle())
                        }

                    }
                    Divider()
                    
                    TextField("Duration", text: $stringDuration)
                        .keyboardType(.numberPad)
                        .padding()
                        .foregroundColor(.black)
                        .background {
                            Color.white.opacity(0.8)
                        }
                        .cornerRadius(9)
                        .padding()
                    
                    DatePicker("Enter Date: ", selection: $lessonDate)
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .padding()
                        .foregroundColor(.black)
                        .background {
                            Color.white.opacity(0.8)
                        }
                        .cornerRadius(9)
                        .padding()
                    
                    HStack {
                        Text("Select Coach")
                            .foregroundColor(.black)
                            .font(.custom("LexendDeca-Regular", size: 18))
                        Picker("Coach Picker", selection: $selectedCoach) {
                            ForEach(coaches, id: \.self) { coach in
                                Text(coach)
                                    .foregroundColor(.black)
                                    .font(.custom("LexendDeca-Regular", size: 18))
                            }
                        }
                    }
                    .padding()
                    .background {
                        Color.white.opacity(0.8)
                    }
                    .cornerRadius(9)
                    .padding()
                    
                    Spacer()
                        
                }
            }
            .task {
                await getUID()
                await getToken()
                await getCoaches()
            }
        }
    }
    
    func getUID() async {
        // Filter with UID
        
        do {
            let documents = try await Firestore.firestore().collection("Coaches")
                .getDocuments()
            
            let users = try documents.documents.compactMap { doc -> Coach? in
                try doc.data(as: Coach.self)
            }
            
            for user in users {
                if user.uid == coachUID && user.centerName == savedCenterName {
                    coachUID = user.uid
                }
            }
            
            print("TOKEN: \(token)")
            
            
        } catch {
            print("Error")
            print(error.localizedDescription)
        }
    }
    
    func getCoaches() async {
        // Filter with UID
        
        do {
            let documents = try await Firestore.firestore().collection("Center")
                .getDocuments()
            
            let centers = try documents.documents.compactMap { doc -> Center? in
                try doc.data(as: Center.self)
            }
            
            for center in centers {
                if center.title == savedCenterName {
                    coaches = center.coaches
                }
            }
            
            print("Found Coachecs")
            
            
        } catch {
            print("Error")
            print(error.localizedDescription)
        }
    }
    
    func getToken() async {
        // Filter with UID
        
        do {
            let documents = try await Firestore.firestore().collection("Users")
                .getDocuments()
            
            let users = try documents.documents.compactMap { doc -> User? in
                try doc.data(as: User.self)
            }
            
            for user in users {
                if user.userUID == coachUID {
                    token = user.firebaseMessageToken
                }
            }
            
            print("TOKEN: \(token)")
            
            
        } catch {
            print("Error")
            print(error.localizedDescription)
        }
    }
    
    func requestLesson(child: Bool) {
        print("Requesting Lesson")
        
        let intDuration = Int(stringDuration)
        
        if child {
            let firebaseLesson = Lesson(date: lessonDate, coachName: selectedCoach, coachUID: coachUID, centerName: savedCenterName, centerUID: savedCenterUID, playerName: childName, playerUID: childUID, duration: intDuration ?? 0, isChild: true, parentName: userNameStored, parentUID: userUID, isAccepted: false, isStarted: false, isFinished: false, notes: "")
            print(firebaseLesson)
        } else {
            let firebaseLesson = Lesson(date: lessonDate, coachName: selectedCoach, coachUID: coachUID, centerName: savedCenterName, centerUID: savedCenterUID, playerName: userNameStored, playerUID: userUID, duration: intDuration ?? 0, isChild: false, parentName: userNameStored, parentUID: userUID, isAccepted: false, isStarted: false, isFinished: false, notes: "")
            
            print(firebaseLesson)
        }
        
        let sender = PushNotificationSender()
        sender.sendPushNotification(to: token, title: userNameStored, body: "Lesson Request")
        print("Sent Push Notification")
        
    }
    
    func createLesson(child: Bool) {
        print("Creating Lesson")
    }
    
   
}

struct CreateNewLessonView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewLessonView(isRequest: true)
    }
}
