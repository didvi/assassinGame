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
    
    let roomNumber: Int
    let playerCount:Int
    var players:[Player]
    let timeLeft: Date
    let graveyard:[Tombstone]
    let snapshots:[String]
    var phoneToPlayer: [String:String]
    

    
    init(roomNumber:Int, playersNeeded:Int) {
        self.roomNumber = roomNumber
        self.playerCount = playersNeeded
        self.timeLeft = Date()
        self.players = [Player]()
        self.graveyard = [Tombstone]()
        self.snapshots = [String]()
        self.phoneToPlayer = [String:String]()
    }
    
    func removePlayer(_ player: Player) {
        var i = 0
        while i < self.players.count {
            if self.players[i].name == player.name {
                self.players.remove(at: i)
            }
            i += 1
        }
    }
    
    func assignTargets() {
        players.shuffle()
        
        if (players.count == 2) {
            players[0].target = players[1]
            players[1].target = players[0]
            return;
        }
        for i in 0...players.count - 2 {
            players[i].target = players[i + 1];
        }
        players[players.count - 1].target = players[0];
    }
   
    
    
}
