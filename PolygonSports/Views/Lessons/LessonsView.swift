//
//  LessonsView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/27/23.
//

import SwiftUI
import Firebase

struct LessonsView: View {
    
    @State private var fetchedLessons: [Lesson] = []
    var isNavRequest: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                
                //MARK: Header
                HStack {
                    Text("Lessons")
                        .font(.custom("LexendDeca-Regular", size: 24))
                        .hAlign(.leading)
                        .padding()
                    
                    NavigationLink {
                        CreateNewLessonView(isRequest: isNavRequest)
                    } label: {
                        Text(isNavRequest ? "Request" : "Create")
                            .font(.custom("LexendDeca-Regular", size: 17))
                    }
                    .hAlign(.trailing)
                    .padding()
                }
                
                Divider()
                
                ScrollView(showsIndicators: false) {
                    ForEach(fetchedLessons) { lesson in
                        if lesson.date > Date() {
                            NavigationLink {
                                DetailedLessonView(lesson: lesson)
                            } label: {
                                Text(lesson.date.formatted())
                            }
                            .buttonStyle(BorderedButtonStyle())
                            .padding()
                        }
                    }
                }

            }
            Spacer()
        }
    }
}

struct LessonsView_Previews: PreviewProvider {
    static var previews: some View {
        LessonsView(isNavRequest: false)
    }
}
