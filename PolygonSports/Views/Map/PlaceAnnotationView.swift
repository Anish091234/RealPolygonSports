//
//  PlaceAnnotationView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 12/31/22.
//


import SwiftUI

struct PlaceAnnotationView: View {
    @State private var showTitle = true
    
    var center: Center
    
    var body: some View {
        
        VStack(spacing: 0) {
            Text("\(center.title) : \(center.sport)")
                .font(.custom("LexendDeca-Regular", size: 16))
                .padding(5)
                .background(Color(.white))
                .cornerRadius(10)
                .opacity(showTitle ? 0 : 1)
            
            if center.sport.lowercased() == "table tennis" {
                
                NavigationLink {
                    CentersView(center: center)
                } label: {
                    Image("table tennis")
                        .resizable()
                        .frame(width: 25, height: 25)
                }

            } else if center.sport.lowercased() == "soccer" {
                NavigationLink {
                    CentersView(center: center)
                } label: {
                    Image("soccer")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
            } else if center.sport.lowercased() == "baseball" {
                NavigationLink {
                    CentersView(center: center)
                } label: {
                    Image("baseball")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                
            } else if center.sport.lowercased() == "karate" {
                NavigationLink {
                    CentersView(center: center)
                } label: {
                    Image("karate")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
            } else if center.sport.lowercased() == "football" {
                NavigationLink {
                    CentersView(center: center)
                } label: {
                    Image("football")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
            }
            
            Image(systemName: "arrowtriangle.down.fill")
                .font(.caption)
                .foregroundColor(.red)
                .offset(x: 0, y: -5)
        }
        .onTapGesture {
            withAnimation(.easeInOut) {
                showTitle.toggle()
            }
        }
        
    }
}

struct PlaceAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceAnnotationView(center: Center(title: "Bpb", headCoach: "Bob", coaches: ["Bob"], students: ["Bob"], address: "252 ewifjwoie", lat: 12.12, lng: 12.12, sport: "Soccer"))
            .background(Color.gray)
    }
}


