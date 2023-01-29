//
//  LocationDetailsView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 12/31/22.
//


import SwiftUI
import MapKit
import CoreLocationUI

struct LocationDetailsView: View {
    
    let place: String
    let sport: String
    let headCoach: String
    let lat: Double
    let lng: Double
    
    var body: some View {
        VStack {
            Text(place)
                .font(.custom("LexendDeca-Regular", size: 28))
            HStack {
                
                Text("Sport: \(sport)")
                    .font(.custom("LexendDeca-Regular", size: 18))
                Text("Coach \(headCoach)")
                    .font(.custom("LexendDeca-Regular", size: 18))
            }
            
            // Images
            Group {
                if sport.lowercased() == "table tennis" {
                    Image("table tennis")
                        .resizable()
                        .frame(width: 25, height: 25)
                    
                } else if sport.lowercased() == "soccer" {
                    Image("soccer")
                        .resizable()
                        .frame(width: 25, height: 25)
                } else if sport.lowercased() == "baseball" {
                    Image("baseball")
                        .resizable()
                        .frame(width: 25, height: 25)
                } else if sport.lowercased() == "karate" {
                    Image("karate")
                        .resizable()
                        .frame(width: 25, height: 25)
                } else if sport.lowercased() == "football" {
                    Image("football")
                        .resizable()
                        .frame(width: 25, height: 25)
                } else if sport.lowercased() == "hockey" {
                    Image("hockey")
                        .resizable()
                        .frame(width: 25, height: 25)
                } else if sport.lowercased() == "swimming" {
                    Image("swimming")
                        .resizable()
                        .frame(width: 25, height: 25)
                } else if sport.lowercased() == "cheer" {
                    Image("cheer")
                        .resizable()
                        .frame(width: 25, height: 25)
                } else if sport.lowercased() == "tennis" {
                    Image("tennis")
                        .resizable()
                        .frame(width: 25, height: 25)
                } else if sport.lowercased() == "lacrosse" {
                    Image("lacrosse")
                        .resizable()
                        .frame(width: 25, height: 25)
                } else if sport.lowercased() == "fencing" {
                    Image("fencing")
                        .resizable()
                        .frame(width: 25, height: 25)
                } else {
                    Image(systemName: "mappin")
                }
            }
            
            Button {
                let url = URL(string: "maps://?saddr=&daddr=\(lat),\(lng)")
                
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                }
                
            } label: {
                HStack {
                    Text("Open In Maps")
                        .font(.custom("LexendDeca-Regular", size: 18))
                    Image(systemName: "square.and.arrow.up")
                }
            }
            .padding()
            .buttonStyle(GradientButtonStyle())
        }
    }
    
}

struct LocationDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailsView(place: "Bob", sport: "karate", headCoach: "Jeff", lat: 12.12312, lng: 231.1239)
    }
}

