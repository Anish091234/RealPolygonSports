//
//  ReuseablePlayerView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/9/23.
//

import SwiftUI

struct ReuseablePlayerView: View {
    
    var player: Player
    
    var body: some View {
        
        let playerRating: String = String(player.rating)
        let playerAge: String = String(player.age)
        VStack {
            Text("Player")
                .font(.custom("LexendDeca-Regular", size: 28))
                .bold()
                
            Text("Name: \(player.name)")
                .font(.custom("LexendDeca-Regular", size: 20))
                .padding()
                .fontWeight(.semibold)
            Text("Email: \(player.email)")
                .font(.custom("LexendDeca-Regular", size: 20))
            Text("Age: \(playerAge)")
                .font(.custom("LexendDeca-Regular", size: 20))
                .padding()
            Text("Rating: \(playerRating)")
                .font(.custom("LexendDeca-Regular", size: 20))
                .padding()
            
            
            if player.isChildAccount {
                Divider()
                
                Text("Parent Account:")
                    .bold()
                    .font(.custom("LexendDeca-Regular", size: 20))
                Text("Parent Name: \(player.parentName)")
                    .font(.custom("LexendDeca-Regular", size: 20))
                    .padding()
                    .fontWeight(.semibold)
                Text("Parent Email: \(player.parentEmail)")
                    .font(.custom("LexendDeca-Regular", size: 20))
            }
            Spacer()
        }
    }
}

struct ReuseablePlayerView_Previews: PreviewProvider {
    static var previews: some View {
        ReuseablePlayerView(player: Player(name: "Anish", email: "anish1@gmail.com", rating: 1000,age: 15, isChildAccount: false, parentAccountUID: "", parentName: "", parentEmail: "", playerUID: "123123123"))
        
        ReuseablePlayerView(player: Player(name: "Ishan", email: "ishan@gmail.com", rating: 1200,age: 10, isChildAccount: true, parentAccountUID: "123123123", parentName: "Gopal", parentEmail: "gopal@gmail.com", playerUID: "123123123"))
    }
}
