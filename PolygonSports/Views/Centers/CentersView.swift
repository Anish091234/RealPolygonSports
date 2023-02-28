//
//  CentersView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/27/23.
//

import SwiftUI
import MapKit
import FirebaseStorage
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CentersView: View {
    var center: Center
    var options = ["Announcements", "Info"]
    @AppStorage("account_type") var accountType: String = ""
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("account_child_name") var childName = ""
    @AppStorage("user_center") var centerName = ""
    
    @State var showSheet: Bool = false
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 12, longitude: 12), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State var joinDisabled: Bool = false
    @State private var selection = "Info"
    @State private var recentsAnnouncements: [Announcement] = []
    @State private var createNewPost: Bool = false
    @State var isPresented: Bool = false
    
    var body: some View {
        
        let annotation = [Location(name: center.title, coordinate: CLLocationCoordinate2D(latitude: center.lat, longitude: center.lng))]
        
        NavigationStack {
            VStack {
                Picker("Holder Text", selection: $selection) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                            .font(.custom("LexendDeca-Regular", size: 18))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selection == "Announcements" {
                    ZStack {
                        ScrollView (showsIndicators: false) {
                            VStack {
                                Text("Announcments")
                                    .font(.custom("LexendDeca-Regular", size: 18))
                                
                                Divider()
                                
                                ForEach(recentsAnnouncements) { announcement in
                                    NavigationLink {
                                        DetailedAnnouncementView(announcement: announcement)
                                    } label: {
                                        ZStack {
                                            Rectangle()
                                                .blendMode(.overlay)
                                                .frame(height: 70)
                                                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                                                .cornerRadius(9)
                                            
                                            Text(announcement.title)
                                                .bold()
                                                .foregroundColor(.white)
                                                .font(.custom("LexendDeca-Regular", size: 15))
                                        }
                                    }

                                }
                                .padding()
                            }
                        }
                        
                        if center.coaches.contains(userNameStored) {
                            Button {
                                isPresented.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle")
                                }
                            }
                            .padding(.top, 450)
                            .padding(.leading, 230)
                            .buttonStyle(GradientButtonStyle())
                        }
                        
                        Spacer()
                        
                    }
                } else {
                    ScrollView (showsIndicators: false) {
                        VStack (spacing: 12) {
                            
                            HStack {
                                Text(center.title)
                                    .bold()
                                    .font(.custom("LexendDeca-Regular", size: 18))
                                
                                Spacer()
                                
                                Button {
                                    showSheet.toggle()
                                } label: {
                                    Text("Join")
                                        .bold()
                                        .font(.custom("LexendDeca-Regular", size: 18))
                                }
                                .blurredSheet(.init(.ultraThinMaterial), show: $showSheet) {
                                    
                                } content: {
                                    JoinCenterView(center: center, accountType: accountType)
                                        .presentationDetents([.large, .medium,.height(150)])
                                }
                                .disabled(joinDisabled)
                            } // Title + Join
                            .padding()
                            
                            Divider()
                            
                            Text("Head Coach: \(center.headCoach)")
                                .hAlign(.leading)
                                .bold()
                                .font(.custom("LexendDeca-Regular", size: 20))
                                .padding()
                            
                            
                            
                            HStack {
                                
                                NavigationLink {
                                    ListPersonView(persons: center.coaches, type: "Coaches")
                                } label: {
                                    Text("Coaches")
                                        .bold()
                                    //.hAlign(.leading)
                                        .font(.custom("LexendDeca-Regular", size: 18))
                                    
                                }
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                                
                                Divider()
                                    .frame(height: 40)
                                
                                NavigationLink {
                                    ListPersonView(persons: center.students, type: "Players")
                                } label: {
                                    Text("Players")
                                        .bold()
                                    //.hAlign(.trailing)
                                        .font(.custom("LexendDeca-Regular", size: 18))
                                    
                                    
                                }
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                                
                                Divider()
                                    .frame(height: 40)
                                
                                NavigationLink {
                                    ListEventsView(center: center.title)
                                } label: {
                                    Text("Events")
                                        .font(.custom("LexendDeca-Regular", size: 18))
                                        .bold()
                                }
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                                
                            } // Coaches + Players + Events
                            
                            
                            
                            //MARK: Map
                            ZStack {
                                Map(coordinateRegion: $region, annotationItems: annotation) {
                                    MapMarker(coordinate: $0.coordinate)
                                }
                                .frame(width: 375, height: 550)
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
                                .padding(.bottom, 475)
                                .padding(.leading, 170)
                                
                            } // Map + Join Button
                            .padding()
                            
                            Spacer()
                        }
                    }
                }
            }
            .fullScreenCover(isPresented: $isPresented) {
                CreateNewAnnouncement (center: center) { post in
                    recentsAnnouncements.insert(post, at: 0)
                }
            }
        }
        
        .onAppear {
            
            getAnnoucements()
            
            if center.students.contains(userNameStored) {
                joinDisabled = true
            }
            
            if center.students.contains(childName) {
                joinDisabled = true
            }
            
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: center.lat, longitude: center.lng), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            
        }
    }
    
    func getAnnoucements()  {
        Task {
            do {
                
                let documents = try await Firestore.firestore().collection("Announcement")
                    .whereField("centerID", isGreaterThanOrEqualTo: center.id ?? "")
                    .whereField("centerID", isLessThanOrEqualTo: "\(center.id ?? "")\u{f8ff}")
                    .getDocuments()
                
                let annoucnemnts = try documents.documents.compactMap { doc -> Announcement? in
                    try doc.data(as: Announcement.self)
                }
                
                print("Annoucnments: ")
                print(annoucnemnts)
                
                await MainActor.run(body: {
                    recentsAnnouncements = annoucnemnts
                })
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct CentersView_Previews: PreviewProvider {
    static var previews: some View {
        CentersView(center: Center(title: "AnishIsCool", headCoach: "Anish", coaches: ["Bob", "Joe", "Sam"], students: ["Ham", "Bam", "Wham", "Tam"], address: "One Apple Way", lat: 12.1212, lng: 12.1212, sport: "Soccer", uid: "asdfja"))
    }
}
