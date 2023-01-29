//
//  StudentSelectionView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/20/23.
//

import SwiftUI

struct StudentSelectionView: View {
    @State var isCreatePlayerPresented: Bool = false
    @AppStorage("user_name") private var username: String = ""
    @State private var show: Bool = false
    var body: some View {
        Button {
            isCreatePlayerPresented.toggle()
        } label: {
            Text("Add A Player")
                .font(.custom("LexendDeca-Regular", size: 18))
        }
        .modifier(customViewModifier(roundedCornes: 6, startColor: .green, endColor: .indigo, textColor: .white))
        .padding()
        .fullScreenCover(isPresented: $isCreatePlayerPresented, content: CreatePlayer.init)
        
        NavigationLink {
            EditPlayer()
        } label: {
            Text("Edit Player: \(username)")
                .font(.custom("LexendDeca-Regular", size: 18))
        }
        
        NavigationLink {
            MapView(showMenu: $show)
        } label: {
            Text("Browse Some Coaches")
                .font(.custom("LexendDeca-Regular", size: 18))
        }.navigationBarBackButtonHidden()
    }
}

struct StudentSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        StudentSelectionView()
    }
}
