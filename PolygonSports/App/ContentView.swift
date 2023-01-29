//
//  ContentView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 12/31/22.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject private var authModel: AuthViewModel
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("isOnboarding_done") var isOnboardingDone: Bool = false
    
    var body: some View {
        Group {
            if authModel.user != nil {
                MainView()
            } else {
                LoginView()
            }
        }.onAppear {
            authModel.listenToAuthState()
        }
    }
}


//if isOnboardingDone {
//    if logStatus {
//        MainView()
//            .onAppear {
//                print("Log Status \(logStatus)")
//            }
//    } else {
//        LoginView()
//            .onAppear {
//                print("Log Status \(logStatus)")
//            }
//    }
//} else {
//    OnBoardingView()
//}
