//
//  Game.swift
//  assassinGame
//
//  Created by Divi Schmidt on 4/11/19.
//  Copyright © 2019 Divi Schmidt. All rights reserved.
//

import Foundation
import Firebase
import MapKit

class Game {
    let game_id: DocumentReference;
    let playerCount:Int;
    let players:Array<Player>;
    let timeLeft:Double;
    let graveyard:Array<Tombstone>;
    let snapshots:Array<String>;
    
    init(_ players:Int,_ game_id:DocumentReference) {
        self.game_id = game_id;
        self.playerCount = players;
        self.timeLeft = 7;
        self.players = [Player("Divi", game_id), Player("Max", game_id), Player("Sophia", game_id), Player("Daniel", game_id), Player("OtherDaniel", game_id), Player("Derek", game_id)];
        self.graveyard = [Tombstone(game_id: game_id, title: "OtherDaniel", locationName: "Assassination", coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661)), Tombstone(game_id: game_id, title: "Daniel", locationName: "Suicide", coordinate: CLLocationCoordinate2D(latitude: 21.283821, longitude: -157.831161))];
        self.snapshots = ["img1", "img2"];
    }
    
}
