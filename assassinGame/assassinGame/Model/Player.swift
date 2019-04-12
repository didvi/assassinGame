//
//  Player.swift
//  assassinGame
//
//  Created by Divi Schmidt on 4/11/19.
//  Copyright © 2019 Divi Schmidt. All rights reserved.
//

import Foundation
import Firebase

class Player {
    var id: DocumentReference;
    let name:String;
    var won_game:Bool;
    var alive:Bool;
    
    init(_ name:String, _ game_id:DocumentReference) {
        self.id = game_id.collection("players").document();
        self.won_game = false;
        self.alive = true;
        self.name = name;
    }
}
