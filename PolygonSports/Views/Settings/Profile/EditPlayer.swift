//
//  EditPlayer.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/16/23.
//

import SwiftUI

struct EditPlayer: View {
    @AppStorage("user_name") private var username: String = ""
    @AppStorage("user_rating") var userRating: String = ""
    
    @State private var editText: Bool = false
    @State private var textName: String = ""
    
    @State private var editRating: Bool = false
    @State private var textRating: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                //MARK: Edit Name
                HStack {
                    if editText {
                        TextField("", text: $textName)
                            .font(.custom("LexendDeca-Regular", size: 18))
                            .padding()
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.purple, lineWidth: 5)
                            )
                        Button {
                            username = textName
                            editText.toggle()
                        } label: {
                            Image(systemName: "checkmark.circle")
                        }
                    } else {
                        HStack {
                            Text("Name: \(username)")
                                .font(.custom("LexendDeca-Regular", size: 18))
                                .padding()
                            
                            Button {
                                editText.toggle()
                            } label: {
                                Image(systemName: "x.circle")
                            }
                            .padding()
                        }
                    }
                }
                
                
                //MARK: Edit Rating
                HStack {
                    if editRating {
                        TextField("", text: $textRating)
                            .font(.custom("LexendDeca-Regular", size: 18))
                            .padding()
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.purple, lineWidth: 5)
                            )
                        Button {
                            userRating = textRating
                            editRating.toggle()
                        } label: {
                            Image(systemName: "checkmark.circle")
                        }
                    } else {
                        HStack {
                            Text("Rating: \(userRating)")
                                .font(.custom("LexendDeca-Regular", size: 18))
                                .padding()
                            
                            Button {
                                editRating.toggle()
                            } label: {
                                Image(systemName: "x.circle")
                            }
                            .padding()
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("Edit Player")
            .padding()
        }
    }
}

struct EditPlayer_Previews: PreviewProvider {
    static var previews: some View {
        EditPlayer()
    }
}
