//
//  Place.swift
//  PolygonSports
//
//  Created by Anish Rangdal on 1/28/23.
//

import Foundation
import CoreLocation

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}
