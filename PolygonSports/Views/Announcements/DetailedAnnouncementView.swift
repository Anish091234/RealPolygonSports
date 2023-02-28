//
//  DetailedAnnouncementView.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 2/4/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailedAnnouncementView: View {
    var announcement: Announcement
    var body: some View {
        VStack {
            HStack {
                Text(announcement.title)
                    .font(.custom("LexendDeca-Regular", size: 23))
                    .hAlign(.leading)
                    .padding()
                
                Text(announcement.date.formatted())
                    .font(.custom("LexendDeca-Regular", size: 15))
                    .padding()
            }
            
            Text(announcement.description)
                .font(.custom("LexendDeca-Regular", size: 18))
            
            WebImage(url: announcement.imageURL).placeholder{
                Image(systemName: "photo")
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 200, height: 100)
            .padding()
            
            Spacer()
        }
        .padding()
    }
}

struct DetailedAnnouncementView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedAnnouncementView(announcement: Announcement(title: "Poop", description: "I like to play games and they are so much fun, i hop you had more fun than me!", date: Date(), centerID: "asdklfj"))
    }
}
