//
//  StarView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/27/23.
//

import SwiftUI

struct StarView: View {
    
    let numOfStars: Int
    let isHalf: Bool
    
    var body: some View {
        HStack {
            ForEach(0..<numOfStars) { index in
                Image(systemName: "star.fill")
            }
            if isHalf {
                Image(systemName: "star.leadinghalf.filled")
            }
        }
    }
}

struct StarView_Previews: PreviewProvider {
    static var previews: some View {
        StarView(numOfStars: 4, isHalf: true)
    }
}
