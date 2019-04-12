//
//  DatabaseController.swift
//  assassinGame
//
//  Created by Divi Schmidt on 4/10/19.
//  Copyright © 2019 Divi Schmidt. All rights reserved.
//

import Foundation
import Firebase
import MapKit
let db = Firestore.firestore()


func newGame() {
    let game_id = db.collection("games").document();
    let game = Game(6, game_id);
    
    // add players for game
    for player in game.players {
        addPlayer(player);
    }
    
    // add tombstones for map section
    for t in game.graveyard {
        addTombstone(t);
    }
    
    game.game_id.setData([
        "playerCount": game.playerCount,
        "timeLeft": game.timeLeft,
    ]) { err in
        if let err = err {
            print("Error writing document: \(err)")
        } else {
            print("Document successfully written!")
        }
    }
    
}

func addPlayer(_ player:Player) {
    player.id.setData([
        "name": player.name,
        "won_game": player.won_game,
        "alive": player.alive
    ])  { err in
        if let err = err {
            print("Error writing document: \(err)")
        } else {
            print("Document successfully written!")
        }
    }
}

func addTombstone(_ t:Tombstone) {
    t.id.setData([
        "tombstone_id": t.id,
        "title": t.title ?? " ",
        "locationName": t.locationName,
        "latitude": t.coordinate.latitude,
        "longitude": t.coordinate.longitude
    ])  { err in
        if let err = err {
            print("Error writing document: \(err)")
        } else {
            print("Document successfully written!")
        }
    }
}

func addSnapshot(_ s:Snapshot) {
  s.id.setData([
        "tombstone_id": s.id,
        "photo": s.photoString,
        "shooter_id": s.shooter_id,
        "victim_id": s.victim_id,
        "checks_possible": s.checks_possible,
        "till_death": s.till_death
    ])  { err in
        if let err = err {
            print("Error writing document: \(err)")
        } else {
            print("Document successfully written!")
        }
    }

}
