//
//  MapView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 12/31/22.
//


import SwiftUI
import MapKit
import CoreLocationUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MapView: View {
    @State var annotations: [Center] = []
    @State var query = ""
    @State var show: Bool = false
    @StateObject private var viewModel = ContentViewModel()
    @Binding var showMenu: Bool
    @State private var showSheet: Bool = false
    var body: some View {
        NavigationStack {
            ZStack {
                Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: annotations) {
                    place in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: place.lat, longitude: place.lng)) {
                        NavigationLink {
                            CentersView(center: place)
                        } label: {
                            PlaceAnnotationView(center: place)
                        }
                    }
                }
                .ignoresSafeArea()
                
                LocationButton(.currentLocation) {
                    viewModel.requestAllowOnceLocationPermission()
                }
                .foregroundColor(.white)
                .cornerRadius(10)
                .labelStyle(.titleAndIcon)
                .symbolVariant(.fill)
                .tint(.red)
                .padding(.top, 500)
                
                Button {
                    showSheet.toggle()
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                .modifier(customViewModifier(roundedCornes: 6, startColor: .teal, endColor: .indigo, textColor: .white))
                .padding(.leading, 260)
                .padding(.bottom, 620)
                .padding()
                
            }
        }
        
        .overlay(LoadingView(show: $show))
        .task {
            show = true
            await fetchCenters()
        }
        .blurredSheet(.init(.ultraThinMaterial), show: $showSheet) {
            
        } content: {
            VStack {
                Text("Filters")
                    .font(.custom("LexendDeca-Regular", size: 20))
                    .bold()
                    .padding()
                
                TextField("Search", text: $query)
                    .modifier(customViewModifier(roundedCornes: 6, startColor: .teal, endColor: .indigo, textColor: .white))
                    .padding()
                
                Button {
                    print("Filtering")
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                .modifier(customViewModifier(roundedCornes: 6, startColor: .teal, endColor: .indigo, textColor: .white))
                .padding(.leading, 260)
                .padding(.bottom, 620)
                .padding()
                

            }
            //.presentationDetents([.large, .medium,.height(150)])

        }
    }
    func fetchCenters() async {
        do {
            var query: Query!
            
            query = Firestore.firestore().collection("Center")
            
            let docs = try await query.getDocuments()
            
            let fetchedTournaments = docs.documents.compactMap { doc -> Center? in
                try? doc.data(as: Center.self)
            }
            print(fetchedTournaments)
            await MainActor.run(body: {
                annotations = fetchedTournaments
                show = false
            })
        } catch {
            print("ERROR")
            print(error.localizedDescription)
        }
    }
}


struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(15.0)
    }
}

//MARK: Location Button
final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: -75), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestAllowOnceLocationPermission() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {
            // show an error
            return
        }
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(showMenu: .constant(true))
    }
}
