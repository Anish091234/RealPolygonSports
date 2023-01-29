//
//  CoachSelectionView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/20/23.
//

import SwiftUI

struct CoachSelectionView: View {
    @State var isPresented: Bool = false
    @AppStorage ("isAddressSaved") var isAddressSaved: Bool = false

    var body: some View {
        ZStack{ // full screen cover button for coach setup
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
                isPresented.toggle()
            } label: {
                Text("Setup For Coach")
                    .font(.custom("LexendDeca-Regular", size: 18))
                    .padding()
            }
            .disabled(isAddressSaved)
            .fullScreenCover(isPresented: $isPresented, content: CreateAnnotation.init)
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
}

struct CoachSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CoachSelectionView()
    }
}
