//
//  Snapshot.swift
//  assassinGame
//
//  Created by Divi Schmidt on 4/11/19.
//  Copyright © 2019 Divi Schmidt. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class Snapshot {
    let id: DocumentReference;
    let photo: UIImage;
    let photoString: String;
    let shooter_id: Int;
    let victim_id: Int;
    var checks_possible: Int;
    var till_death: Int;
    
    init(game_id: DocumentReference, _ shooter_id: Int, _ victim_id: Int, _ photoString: String) {
        self.id = game_id.collection("snapshots").document();
        self.photo = UIImage();
        self.photoString = photoString;
        self.shooter_id = shooter_id;
        self.victim_id = victim_id;
        self.checks_possible = 5;
        self.till_death = 3;
    }
}
