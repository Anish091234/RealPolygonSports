//
//  ParentSelectionView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/20/23.
//

import SwiftUI

struct ParentSelectionView: View {
    @State var isCreatePlayerPresented: Bool = false
    @State var isCreateChildPresented: Bool = false
    @AppStorage("account_child_rating") var childRating = ""
    @AppStorage("account_child_age") var childAge = ""
    @AppStorage("account_child_name") var childName = ""
    @AppStorage("user_name") private var username: String = ""
    
    var body: some View {
        HStack {
            Button {
                isCreateChildPresented.toggle()
            } label: {
                Text("Add A Child")
                    .font(.custom("LexendDeca-Regular", size: 18))
            }
            .modifier(customViewModifier(roundedCornes: 6, startColor: .green, endColor: .indigo, textColor: .white))
            .padding()
            .fullScreenCover(isPresented: $isCreateChildPresented, content: CreateChild.init)
            
            Text("Or")
                .padding()
                .bold()
                .font(.custom("LexendDeca-Regular", size: 18))
            
            Button {
                isCreatePlayerPresented.toggle()
            } label: {
                Text("Add A Player")
                    .font(.custom("LexendDeca-Regular", size: 18))
            }
            .modifier(customViewModifier(roundedCornes: 6, startColor: .green, endColor: .indigo, textColor: .white))
            .padding()
            .fullScreenCover(isPresented: $isCreatePlayerPresented, content: CreatePlayer.init)
        }
        if childName != "" {
            NavigationLink {
                EditChildPlayer()
            } label: {
                Text("Edit Child: \(childName)")
                    .font(.custom("LexendDeca-Regular", size: 18))
            }
        }
        
        NavigationLink {
            EditPlayer()
        } label: {
            Text("Edit Player: \(username)")
                .font(.custom("LexendDeca-Regular", size: 18))
        }
    }
}

struct ParentSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ParentSelectionView()
    }
}
