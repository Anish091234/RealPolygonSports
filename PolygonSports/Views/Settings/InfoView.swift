//
//  InfoView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/9/23.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        VStack {
            Text("Polygon Sports")
                .font(.custom("LexendDeca-Regular", size: 24))
                .padding()
                .padding(.top, 200)
            Text("Made By: Anish Rangdal")
                .font(.custom("LexendDeca-Regular", size: 20))
            
            Text("Version 5.3.5")
                .font(.custom("LexendDeca-Regular", size: 18))
            
            Spacer()
            
            
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
