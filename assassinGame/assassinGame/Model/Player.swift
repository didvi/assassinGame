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

    let name:String
    var won_game:Bool
    var alive:Bool
    let image:UIImage
    
    let playerId: String
    var target: Player;
    
    
    // dummy player just to avoid errors idk how to handle -> see getPlayer in Game
    init() {
        self.won_game = false;
        self.alive = true;
        self.name = "name";
        self.image = UIImage(named: "image");
        
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            self.playerId = "uuid"
        }
    }
    
    init(_ name:String, _ image:UIImage) {
        self.won_game = false;
        self.alive = true;
        self.name = name;
        self.image = image;
        
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            self.playerId = uuid
        }
    }
}
