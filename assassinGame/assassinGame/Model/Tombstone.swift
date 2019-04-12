//
//  Tombstone.swift
//  assassinGame
//
//  Created by Divi Schmidt on 4/11/19.
//  Copyright © 2019 Divi Schmidt. All rights reserved.
//

import Foundation
import Firebase
import MapKit

class Tombstone: NSObject, MKAnnotation {
    let id: DocumentReference;
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(game_id: DocumentReference, title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
        self.id = game_id.collection("graveyard").document();
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}
