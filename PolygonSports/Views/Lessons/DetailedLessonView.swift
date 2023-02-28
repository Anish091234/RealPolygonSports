//
//  DetailedLessonView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/27/23.
//

import SwiftUI

struct DetailedLessonView: View {
    
    var lesson: Lesson
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(lesson.date.formatted())
                    .font(.custom("LexendDeca-Regular", size: 18))
                    .padding()
                
                Text("\(lesson.coachName) at \(lesson.centerName)")
                    .font(.custom("LexendDeca-Regular", size: 18))
                
                let stringDuration = String(lesson.duration)
                
                Text("Duration: \(stringDuration) mins")
                    .font(.custom("LexendDeca-Regular", size: 18))
                    .padding()
                Spacer()
            }
        }
    }
}

struct DetailedLessonView_Previews1: PreviewProvider {
    static var previews: some View {
        DetailedLessonView(lesson: Lesson(date: Date(), coachName: "Joe", coachUID: "adjsfaj", centerName: "Apple Park", centerUID: "kjaskdfj", playerName: "James", playerUID: "", duration: 60, isChild: false, parentName: "", parentUID: ""))
    }
}
