//
//  MainView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 12/31/22.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject private var authModel: AuthViewModel
    @State var showMenu: Bool = false
    @State var currentTab: String = ""
    @State var offset: CGFloat = 0
    @State var lastStoredOffset: CGFloat = 0
    @GestureState var gestureOffset: CGFloat = 0
    
    var body: some View {
        let sideBarWidth = getRect().width - 90
        NavigationStack {
            HStack(spacing:0) {
                SlideMenu(showMenu: $showMenu)
                
                VStack(spacing: 0) {
                    TabView() {
                        
                        MainMessagesView()
                            .tabItem {
                                Label("Chat", systemImage: "bubble.left")
                            }
                        
                        MapView(showMenu: $showMenu)
                            .tabItem {
                                Label("Map", systemImage: "map")
                            }
                        
                        PostsView()
                            .tabItem {
                                Label("Posts", systemImage: "rectangle.on.rectangle")
                            }
                        
                        ProfileView()
                            .tabItem {
                                Label("Settings", systemImage: "gear")
                            }
                    }
                }
                .frame(width: getRect().width)
                .overlay(
                    Rectangle()
                        .fill (
                            Color.primary
                                .opacity(Double((offset / sideBarWidth) / 5))
                            
                        )
                        .ignoresSafeArea(.container, edges: .vertical)
                        .onTapGesture {
                            withAnimation{
                                showMenu.toggle()
                            }
                        }
                )
            }
            .frame(width: getRect().width + sideBarWidth)
            .offset(x: -sideBarWidth / 2)
            .offset(x: offset > 0 ? offset : 0)
            .gesture(
                DragGesture().updating($gestureOffset, body: { value, out, _ in
                    out = value.translation.width
                })
                .onEnded(onEnd(value: ))
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden)
        }
        .animation(.easeOut, value: offset == 0)
        .onChange(of: showMenu) { newValue in
            if showMenu && offset == 0 {
                offset = sideBarWidth
                lastStoredOffset = offset
            }
            
            if !showMenu && offset == sideBarWidth {
                offset = 0
                lastStoredOffset = 0
            }
        }
        .onChange(of: gestureOffset) { newValue in
            onChange()
        }
    }
    func onChange(){
        let sideBarWidth = getRect().width - 90
        offset = (gestureOffset != 0) ? (gestureOffset+lastStoredOffset < sideBarWidth ? gestureOffset + lastStoredOffset : offset) : offset
    }
    
    func onEnd(value: DragGesture.Value) {
        let sideBarWidth = getRect().width - 90
        
        let translation = value.translation.width
        
        withAnimation {
            if translation > 0 {
                if translation > (sideBarWidth / 2) {
                    offset = sideBarWidth
                    showMenu = true
                } else {
                    
                    if offset == sideBarWidth {
                        return
                    }
                    
                    offset = 0
                    showMenu = false
                }
            } else {
                if -translation > (sideBarWidth / 2) {
                    offset = 0
                    showMenu = false
                } else {
                    
                    if offset == 0 || !showMenu {
                        return
                    }
                    
                    offset = sideBarWidth
                    showMenu = true
                }
            }
        }
        
        lastStoredOffset = offset
        
    }
    
    @ViewBuilder
    func TabButton(image: String) -> some View {
        Button {
            withAnimation {currentTab = image}
        } label: {
            Image(image)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 23, height: 23)
                .foregroundColor(currentTab == image ? .primary : .gray)
                .frame(maxWidth: .infinity)
        }
        
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
