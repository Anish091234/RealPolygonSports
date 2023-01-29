//
//  OnBoardingView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/2/23.
//

import SwiftUI

struct OnBoardingView: View {
    @AppStorage("isOnboarding_done") var isOnboardingDone: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome To Polygon")
                    .bold()
                    .font(.custom("LexendDeca-Regular", size: 18))
                    .padding(.top, 20)
                Text("Polygon allows you to find new coaches as a student, or become found as a coach")
                    .padding()
                    .font(.custom("LexendDeca-Regular", size: 20))
                    .padding(.top, 100)
                Spacer()
                NavigationLink {
                    LoginView()
                } label: {
                    Button {
                        isOnboardingDone = true
                    } label: {
                        Text("Lets Get Started!")
                            .font(.custom("LexendDeca-Regular", size: 22))
                    }.buttonStyle(GradientButtonStyle())

                }
                .navigationBarBackButtonHidden(true)
                .padding()

                Spacer()
            }
        }
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
