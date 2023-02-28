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
    @State var offset: CGFloat = 0
    @State var lastStoredOffset: CGFloat = 0
    @GestureState var gestureOffset: CGFloat = 0
    
    @State var selectedTab = "message"
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    //MARK: Location For Each Curve
    @State var xAxis: CGFloat = 0
    @Namespace var animation
    
    var body: some View {
        let sideBarWidth = getRect().width - 90
        NavigationStack {
            HStack(spacing:0) {
                SlideMenu(showMenu: $showMenu)
                
                ZStack (alignment: Alignment(horizontal: .center
                                             , vertical: .bottom)) {
                    TabView(selection: $selectedTab) {
                        MapView(showMenu: $showMenu)
                            .ignoresSafeArea(.all, edges: .all)
                            .tag("map")
                        
                        MainMessagesView()
                            .ignoresSafeArea(.all, edges: .all)
                            .tag("message")
                        
                        PostsView(isFromNavigationLink: true)
                            .ignoresSafeArea(.all, edges: .all)
                            .tag("posts")
                        
                        SettingsView(isFromNavigationLink: true)
                            .ignoresSafeArea(.all, edges: .all)
                            .tag("profile")
                    }
                    
                    // Custom Tab Bar..
                    
                    HStack(spacing: 0) {
                        
                        ForEach(tabs, id: \.self) { image in
                            
                            GeometryReader { reader in
                                Button (action: {
                                    withAnimation(.spring()) {
                                        selectedTab = image
                                        xAxis = reader.frame(in: .global).minX
                                    }
                                }, label: {
                                    
                                    Image(image)
                                        .resizable()
                                        .renderingMode(.template)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(selectedTab == image ? getColor(image: image) : Color.gray)
                                        .padding(selectedTab == image ? 15 : 0)
                                        .background(Color.white.opacity(selectedTab == image ? 1 : 0) .clipShape(Circle()))
                                        .matchedGeometryEffect(id: image, in: animation)
                                        .offset(x: selectedTab == image ? (reader.frame(in: .global).minX - reader.frame(in: .global).midX) : 0 ,y: selectedTab == image ? -50: 0)
                                })
                                .onAppear(perform: {
                                    if image == tabs.first {
                                        xAxis = reader.frame(in: .global).minX
                                    }
                                })
                            }
                            .frame(width: 25, height: 30)
                            
                            if image != tabs.last{Spacer(minLength: 0)}
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical)
                    .background(Color.white.clipShape(CustomShape(xAxis: xAxis)).cornerRadius(12))
                    .padding()
                    //Bottom Edge
                    .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                }
                                             .ignoresSafeArea(.all, edges: .bottom)
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
            //.toolbar(.hidden)
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

    //MARK: Get Image Color
    func getColor(image: String) -> Color {
        switch image {
        case "map":
            return Color("color1")
            
        case "message":
            return Color("color2")
            
        case "posts":
            return Color.purple
            
        default:
            return Color.blue
            
        }
    }
    
}
//MARK: Make the Curve

struct CustomShape: Shape {
    
    var xAxis: CGFloat
    
    // Animating Curve
    var animatableData: CGFloat {
        get {return xAxis}
        set {xAxis = newValue}
        
    }
    
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            let center = xAxis
            
            path.move(to: CGPoint(x: center - 50, y: 0))
            
            let to1 = CGPoint(x: center, y: 35)
            let control1 = CGPoint(x: center - 25 , y: 0)
            let control2 = CGPoint(x: center - 25 , y: 35)
            
            let to2 = CGPoint(x: center + 50, y: 0)
            let control3 = CGPoint(x: center + 25 , y: 35)
            let control4 = CGPoint(x: center + 25 , y: 0)
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}

var tabs = ["map", "message", "posts", "profile"]

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
