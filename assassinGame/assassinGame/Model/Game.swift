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
    
    var gameNumber: Int
    let roomNumber: Int
    let playerCount:Int
    var players:[Player]
    let timeLeft: Date
    let graveyard:[Tombstone]
    let snapshots:[String]
    var phoneToPlayer: [String:String]
    
    init(_ playersNeeded:Int, _ gameNumber:Int) {
        self.roomNumber = roomNumGenerator.generateRoomNumber()
        self.playerCount = playersNeeded
        self.timeLeft = Date()
        self.players = [Player]()
        self.graveyard = [Tombstone]()
        self.snapshots = [String]()
        self.phoneToPlayer = [String:String]()
        self.gameNumber = gameNumber;
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
    
    func assignTargets() {
        players.shuffle()
        for i in 0...players.count - 2 {
            players[i].target = players[i + 1];
        }
        players[players.count - 1].target = players[0];
    }
    
    func getPlayer() -> Player {
        // not sure how to do this- were talking about storing the device number for each player in the database
        let name = getPlayerName(self.gameNumber)
        for p in players {
            if p.name == name {
                return p;
            }
        }
        print("player does not exist")
        return Player();
    }
}
