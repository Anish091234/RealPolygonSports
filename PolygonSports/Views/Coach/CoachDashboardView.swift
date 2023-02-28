//
//  CoachDashboard.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/18/23.
//

import SwiftUI

struct CoachDashboardView: View {
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_center") var centerName = ""
    @AppStorage ("isAddressSaved") var isAddressSaved: Bool = false
    
    @State private var totalRating: Double = 5.0
    @State private var numOfRating: Double = 1.0
    
    var body: some View {
        NavigationStack {
            
            VStack (spacing: 4) {
                Group {
                    Text("Coach Dashboard")
                        .hAlign(.leading)
                        .font(.custom("LexendDeca-Regular", size: 23))
                        .bold()
                    
                    HStack {
                        Text("Welcome \(userNameStored)")
                            .font(.custom("LexendDeca-Regular", size: 20))
                            .bold()
                            .hAlign(.leading)
                            .padding()
                        
                    }
                    
                    Text("Center: \(centerName)")
                        .font(.custom("LexendDeca-Regular", size: 18))
                        .hAlign(.leading)
                        .padding()
                }
                
                if isAddressSaved == true { // change to false!!!
                    CoachSelectionView()
                } else {
                    ScrollView (showsIndicators: false) {
                        VStack (spacing: 5) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 400)
                                    .foregroundColor(.red.opacity(0.2))
                                
                                VStack {
                                    
                                    let rating = totalRating/numOfRating
                                    
                                    switch(rating) {
                                    case 5:
                                        StarView(numOfStars: 5, isHalf: false)
                                            .hAlign(.leading)
                                            .padding()
                                    case 4.5:
                                        StarView(numOfStars: 4, isHalf: true)
                                            .hAlign(.leading)
                                            .padding()
                                    case 4:
                                        StarView(numOfStars: 4, isHalf: false)
                                            .hAlign(.leading)
                                            .padding()
                                    case 3.5:
                                        StarView(numOfStars: 3, isHalf: true)
                                            .hAlign(.leading)
                                            .padding()
                                    case 3:
                                        StarView(numOfStars: 3, isHalf: false)
                                            .hAlign(.leading)
                                            .padding()
                                    case 2.5:
                                        StarView(numOfStars: 2, isHalf: true)
                                            .hAlign(.leading)
                                            .padding()
                                    case 2:
                                        StarView(numOfStars: 2, isHalf: false)
                                            .hAlign(.leading)
                                            .padding()
                                    case 1.5:
                                        StarView(numOfStars: 1, isHalf: true)
                                            .hAlign(.leading)
                                            .padding()
                                    case 1:
                                        StarView(numOfStars: 1, isHalf: false)
                                            .hAlign(.leading)
                                            .padding()
                                    case 0.5:
                                        Image(systemName: "star.fill")
                                            .hAlign(.leading)
                                            .padding()
                                    default:
                                        Image(systemName: "star.fill")
                                            .hAlign(.leading)
                                            .padding()
                                    }
                                    
                                    let intRating = Int(numOfRating)
                                    
                                    if intRating == 1 {
                                        Text("From \(intRating) review")
                                            .hAlign(.leading)
                                            .font(.custom("LexendDeca-Regular", size: 18))
                                            .padding()
                                    } else {
                                        Text("From \(intRating) reviews")
                                            .hAlign(.leading)
                                            .font(.custom("LexendDeca-Regular", size: 18))
                                            .padding()
                                    }
                                    Spacer()
                                    
                                }
                            }
                            
                            Divider()
                            
                            NavigationLink {
                                LessonsView(isNavRequest: false)
                            } label: {
                                Text("Lessons")
                            }
                            .buttonStyle(BorderedButtonStyle())
                            
                            
                        }
                    }
                }
                Spacer()
            }
            .padding()
            
        }
    }
}

struct CoachDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        CoachDashboardView()
    }
}
