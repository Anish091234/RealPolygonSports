//
//  EditChildPlayer.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/20/23.
//

import SwiftUI

struct EditChildPlayer: View {
    @AppStorage("account_child_name") var childName = ""
    @AppStorage("account_child_rating") var childRating = ""
    @AppStorage("account_child_age") var childAge = ""
    
    @State private var editText: Bool = false
    @State private var textName: String = ""
    
    @State private var editRating: Bool = false
    @State private var textRating: String = ""
    
    @State private var editAge: Bool = false
    @State private var textAge: String = ""
    
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
                            childName = textName
                            editText.toggle()
                        } label: {
                            Image(systemName: "checkmark.circle")
                        }
                    } else {
                        HStack {
                            Text("Name: \(childName)")
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
                            childRating = textRating
                            editRating.toggle()
                        } label: {
                            Image(systemName: "checkmark.circle")
                        }
                    } else {
                        HStack {
                            Text("Rating: \(childRating)")
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
                
                //MARK: Edit Age
                HStack {
                    if editAge {
                        TextField("", text: $textAge)
                            .font(.custom("LexendDeca-Regular", size: 18))
                            .padding()
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.purple, lineWidth: 5)
                            )
                        Button {
                            childAge = textAge
                            editAge.toggle()
                        } label: {
                            Image(systemName: "checkmark.circle")
                        }
                    } else {
                        HStack {
                            Text("Age: \(childAge)")
                                .font(.custom("LexendDeca-Regular", size: 18))
                                .padding()
                            
                            Button {
                                editAge.toggle()
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

struct EditChildPlayer_Previews: PreviewProvider {
    static var previews: some View {
        EditChildPlayer()
            .preferredColorScheme(.dark)
    }
}
