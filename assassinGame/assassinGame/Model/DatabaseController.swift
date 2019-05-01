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
import Kingfisher

let db = Firestore.firestore()

func addGame(_ game: Game) {
    let gameRef =  db.collection("games").document(String(game.roomNumber))
    
    
    gameRef.setData([
        "playerCount": game.playerCount,
        "timeLeft": game.timeLeft.description
    ]) { err in
        if let err = err {
            print("Error writing document: \(err)")
        } else {
            print("Document successfully written!")
        }
    }
}

func addPlayer(_ roomNumber: Int, _ player: Player) {
    
    // adds player to the game with correct room number to firestore
    
    let gameRef = db.collection("games").document(String(roomNumber))
    
    gameRef.collection("players").document(player.name).setData([
        "alive" : String(player.alive),
        "won_game" : String(player.won_game)
    ]) { err in
        if let err = err {
            print("Error writing document: \(err)")
        } else {
            print("Document successfully written!")
        }
    }
    
    // adds the player to the phone to player dictionary
    let deviceID = UIDevice.current.identifierForVendor?.uuidString // gets phone ID
    
    gameRef.collection("phoneToPlayers").document(deviceID!).setData(["name" : player.name]) { err in
        if let err = err {
            print("Error writing document: \(err)")
        } else {
            print("Document successfully written!")
        }
    }

    // adds player's image to Storage ~~~~~~~~~~~~~

    // converts a player's UIImage to data
    let pngData = player.image.pngData()
    
    // points to the root reference
    let storageRef = Storage.storage().reference()

    // points to "2545"
    let roomRef = storageRef.child(String(roomNumber))

    // points to "2545/Bob Dylan.png"
    let fileName = String(player.name) + ".png"
    let photoRef = roomRef.child(fileName)

    // uploads the png data to the correct storage location
    photoRef.putData(pngData!, metadata: nil) { (metadata, err) in
        if err != nil {
            print("didn't upload bro")
        }
    }
    
    
    // subtracts one from 'players needed'
    gameRef.getDocument { (document, error) in
        if let document = document, document.exists {
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: \(dataDescription)")
            
            // retrieve player count and reduce it by one
            
            var playerCount = document.data()? ["playerCount"] as! Int
            playerCount -= 1
            gameRef.updateData(["playerCount" : playerCount])
            
        } else {
            print("Document does not exist")
            
        }
    }
    
    
}

func removePlayer (_ roomNumber: Int, _ player: Player) {
    
    let gameRef = db.collection("games").document(String(roomNumber))
    gameRef.collection("players").document(player.name).delete()
    
    // adds one to 'players needed'
    gameRef.getDocument { (document, error) in
        if let document = document, document.exists {
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: \(dataDescription)")
            
            // retrieve player count and reduce it by one
            
            var playerCount = document.data()? ["playerCount"] as! Int
            playerCount += 1
            gameRef.updateData(["playerCount" : playerCount])
            
        } else {
            print("Document does not exist")
            
        }
    }
}


func getPlayerName(_ roomNumber:Int) -> String {
    let deviceID = UIDevice.current.identifierForVendor?.uuidString // gets phone IDd
    var name = "";
    
    let playerToId = db.collection("games").document(String(roomNumber)).collection("phoneToPlayers").document(deviceID!)
    playerToId.getDocument { (document, error) in
        if let document = document, document.exists {
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: \(dataDescription)")
            
            // retrieve player name from device id
            name = document.data()? ["name"] as! String;
        } else {
            print("Document does not exist")
        }
    }
    return name
}



//func addTombstone(_ t:Tombstone) {
//    t.id.setData([
//        "tombstone_id": t.id,
//        "title": t.title ?? " ",
//        "locationName": t.locationName,
//        "latitude": t.coordinate.latitude,
//        "longitude": t.coordinate.longitude
//    ])  { err in
//        if let err = err {
//            print("Error writing document: \(err)")
//        } else {
//            print("Document successfully written!")
//        }
//    }
//}

//func addSnapshot(_ s:Snapshot) {
//  s.id.setData([
//        "tombstone_id": s.id,
//        "photo": s.photoString,
//        "shooter_id": s.shooter_id,
//        "victim_id": s.victim_id,
//        "checks_possible": s.checks_possible,
//        "till_death": s.till_death
//    ])  { err in
//        if let err = err {
//            print("Error writing document: \(err)")
//        } else {
//            print("Document successfully written!")
//        }
//    }
//
//}
