//
//  CentersView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/27/23.
//

import SwiftUI
import MapKit

struct CentersView: View {
    var center: Center
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 12, longitude: 12), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    var body: some View {
        
        let annotation = [Location(name: center.title, coordinate: CLLocationCoordinate2D(latitude: center.lat, longitude: center.lng))]
        
        NavigationStack {
            ScrollView {
                VStack (spacing: 12){
                    Text("Head Coach: \(center.headCoach)")
                        .hAlign(.leading)
                        .bold()
                        .font(.custom("LexendDeca-Regular", size: 20))
                    Divider()
                    Text("Coaches")
                        .bold()
                        .hAlign(.leading)
                        .font(.custom("LexendDeca-Regular", size: 18))
                    ForEach(center.coaches, id: \.self){ coach in
                        NavigationLink {
                            DetailedPlayerView(player: coach)
                        } label: {
                            Text(coach)
                                .hAlign(.leading)
                                .font(.custom("LexendDeca-Regular", size: 15))
                        }
                        
                    }
                    
                    Divider()
                    
                    Text("Players")
                        .bold()
                        .hAlign(.leading)
                        .font(.custom("LexendDeca-Regular", size: 18))
                    ForEach(center.students, id: \.self){ student in
                        NavigationLink {
                            DetailedPlayerView(player: student)
                        } label: {
                            Text(student)
                                .hAlign(.leading)
                                .font(.custom("LexendDeca-Regular", size: 15))
                        }
                    }
                    
                    
                    Divider()
                    
                    ZStack {
                        
                        
                        Map(coordinateRegion: $region, annotationItems: annotation) {
                            MapMarker(coordinate: $0.coordinate)
                        }
                        .frame(width: 375, height: 360)
                        .cornerRadius(12)
                        
                        Button {
                            let url = URL(string: "maps://?saddr=&daddr=\(center.lat),\(center.lng)")
                            
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
                        .buttonStyle(BorderedButtonStyle())
                        .padding(.bottom, 300)
                        .padding(.leading, 170)
                        
                    }
                    
                }
                .padding()
                
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text(center.title)
                            .bold()
                            .font(.custom("LexendDeca-Regular", size: 18))
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            print("joining center")
                        } label: {
                            Text("Join")
                                .bold()
                                .font(.custom("LexendDeca-Regular", size: 18))
                        }
                        .buttonStyle(BorderedButtonStyle())
                    }
                }
            }
        }
        .onAppear {
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: center.lat, longitude: center.lng), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        }
    }
}

struct CentersView_Previews: PreviewProvider {
    static var previews: some View {
        CentersView(center: Center(title: "AnishIsCool", headCoach: "Anish", coaches: ["Bob", "Joe", "Sam"], students: ["Ham", "Bam", "Wham", "Tam"], address: "One Apple Way", lat: 12.1212, lng: 12.1212, sport: "Soccer"))
    }
}
