//
//  CreateAnnotation.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/20/23.
//

import SwiftUI
import Firebase
import MapKit
import CoreLocation
import FirebaseStorage

struct CreateAnnotation: View {
    
    @AppStorage ("isAddressSaved") var isAddressSaved: Bool = false
    
    let geocoder = CLGeocoder()
    @State var name = ""
    @State var sport = ""
    @State var address = ""
    
    @State var lat = 0.0
    @State var lng = 0.0
    @AppStorage("user_name") private var username: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    @State var shown = false
    
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        
        ScrollView {
            VStack {
                Text("Are you a coach and want to be discovered by students? Well then you are in the right place. Polygon was built for you!")
                    .font(.custom("LexendDeca-Regular", size: 20))
                    .multilineTextAlignment(.center)
                    .padding()
                    
                Text("Lets Go!")
                    .padding()
                    .font(.custom("LexendDeca-Regular", size: 20))
                
                //MARK: TextField - Address
                ZStack{
                    LinearGradient(
                        gradient: .init(colors: [Color.white, Color.blue.opacity(0.66)]),
                        startPoint: .init(x: 0.0, y: 0.0),
                        endPoint: .init(x: 0.75, y: 0.75)
                    )
                    .mask(
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 120, height: 45, alignment: .center)
                            .blur(radius: 10)
                    )
                    .padding(.top, 20)
                    TextField("Enter Address", text: $address)
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(
                                gradient: .init(colors: [Color.white, Color.blue.opacity(0.75)]),
                                startPoint: .init(x: -0.33, y: -0.33),
                                endPoint: .init(x: 0.66, y: 0.66)
                            ))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .buttonStyle(PlainButtonStyle())
                }
                .padding()
                
                //MARK: TextField - Name
                ZStack{
                    LinearGradient(
                        gradient: .init(colors: [Color.white, Color.blue.opacity(0.66)]),
                        startPoint: .init(x: 0.0, y: 0.0),
                        endPoint: .init(x: 0.75, y: 0.75)
                    )
                    .mask(
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 120, height: 45, alignment: .center)
                            .blur(radius: 10)
                    )
                    .padding(.top, 20)
                    TextField("Enter Your Center Name", text: $name)
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(
                                gradient: .init(colors: [Color.white, Color.blue.opacity(0.75)]),
                                startPoint: .init(x: -0.33, y: -0.33),
                                endPoint: .init(x: 0.66, y: 0.66)
                            ))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .buttonStyle(PlainButtonStyle())
                }
                .padding()
                
                //MARK: TextField: Sport
                ZStack {
                    LinearGradient(
                        gradient: .init(colors: [Color.white, Color.blue.opacity(0.66)]),
                        startPoint: .init(x: 0.0, y: 0.0),
                        endPoint: .init(x: 0.75, y: 0.75)
                    )
                    .mask(
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 120, height: 45, alignment: .center)
                            .blur(radius: 10)
                    )
                    .padding(.top, 20)
                    TextField("Enter Your Sport", text: $sport)
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .padding()
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(
                                gradient: .init(colors: [Color.white, Color.blue.opacity(0.75)]),
                                startPoint: .init(x: -0.33, y: -0.33),
                                endPoint: .init(x: 0.66, y: 0.66)
                            ))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .buttonStyle(PlainButtonStyle())
                }
                .padding()
                
                Text("Please restart the app in order for the annotation to appear on the map. This is to stop bots from adding annotations")
                    .font(.custom("LexendDeca-Regular", size: 18))
                    .padding()
                
                HStack {
                    //MARK: Done Button
                    ZStack{
                        LinearGradient(
                            gradient: .init(colors: [Color.white, Color.blue.opacity(0.66)]),
                            startPoint: .init(x: 0.0, y: 0.0),
                            endPoint: .init(x: 0.75, y: 0.75)
                        )
                        .mask(
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 120, height: 45, alignment: .center)
                                .blur(radius: 10)
                        )
                        .padding(.top, 20)
                        Button {
                            geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                                if((error) != nil){
                                    print("Error with geocoder", error ?? "")
                                }
                                if let placemark = placemarks?.first {
                                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                                    lat = coordinates.latitude
                                    lng = coordinates.longitude
                                    Task {
                                        do {
                                            let center = Center(title: name, headCoach: username, coaches: [username], students: [], address: address, lat: lat, lng: lng, sport: sport)
                                            
                                            try await createDocumentAtFirebase(center)
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
                            })
                            presentationMode.wrappedValue.dismiss()
                            isAddressSaved = true
                        } label: {
                            Text("Finished")
                                .font(.custom("LexendDeca-Regular", size: 20))
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 16)
                                .padding(.trailing, 16)
                        }
                        .disabled(isAddressSaved)
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(
                                gradient: .init(colors: [Color.white, Color.blue.opacity(0.75)]),
                                startPoint: .init(x: -0.33, y: -0.33),
                                endPoint: .init(x: 0.66, y: 0.66)
                            ))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding()
                    
                    //MARK: Dismiss the full screen view button if isAddressSaved == true
                    ZStack{
                        LinearGradient(
                            gradient: .init(colors: [Color.white, Color.blue.opacity(0.66)]),
                            startPoint: .init(x: 0.0, y: 0.0),
                            endPoint: .init(x: 0.75, y: 0.75)
                        )
                        .mask(
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 120, height: 45, alignment: .center)
                                .blur(radius: 10)
                        )
                        .padding(.top, 20)
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                                .font(.custom("LexendDeca-Regular", size: 20))
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .padding(.leading, 16)
                                .padding(.trailing, 16)
                        }
                        .foregroundColor(.white)
                        .background(
                            LinearGradient(
                                gradient: .init(colors: [Color.white, Color.blue.opacity(0.75)]),
                                startPoint: .init(x: -0.33, y: -0.33),
                                endPoint: .init(x: 0.66, y: 0.66)
                            ))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Coach Setup")
        }
    }
    func createDocumentAtFirebase(_ center: Center) async throws {
        let doc = Firestore.firestore().collection("Center").document()
        print(doc)
        let _ = try doc.setData(from: center, completion: { error in
            if error == nil {
                print("Document Setting Succesfull")
            }
        })
    }
}

struct CreateAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        CreateAnnotation()
    }
}
