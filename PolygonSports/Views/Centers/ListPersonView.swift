//
//  ListPersonView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/3/23.
//

import SwiftUI

struct ListPersonView: View {
    var persons: [String]
    var type: String
    var body: some View {
        VStack {
            
            Text(type)
                .font(.custom("LexendDeca-Regular", size: 24))
                .bold()
            
            List {
                ForEach(persons, id: \.self) { person in
                    Text(person)
                        .font(.custom("LexendDeca-Regular", size: 18))
                }
            }
        }
    }
}

struct ListPersonView_Previews: PreviewProvider {
    static var previews: some View {
        ListPersonView(persons: ["Bob", "Joe", "Fog", "Mob", "Jog"], type: "Players")
            .preferredColorScheme(.dark)
    }
}
