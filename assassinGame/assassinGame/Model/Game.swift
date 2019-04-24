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
    
    init(_ playersNeeded:Int) {
        self.roomNumber = roomNumGenerator.generateRoomNumber()
        self.playerCount = playersNeeded
        self.timeLeft = Date()
        self.players = [Player]()
        self.graveyard = [Tombstone]()
        self.snapshots = [String]()
        self.phoneToPlayer = [String:String]()
    }
    
    func addPlayer(_ player: Player) {
        self.players.append(player)
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
    
    
    
}
