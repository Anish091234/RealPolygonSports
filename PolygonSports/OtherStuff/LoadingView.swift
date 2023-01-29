//
//  LoadingView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 12/31/22.
//

import SwiftUI

struct LoadingView: View {
    @Binding var show: Bool
    var body: some View {
        ZStack {
            if show {
                Group {
                    Rectangle()
                        .fill(.black.opacity(0.25))
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .padding(15)
                        .background(.white, in: RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous))
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: show)
    }
}
