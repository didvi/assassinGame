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
        "totalPlayers": game.playerCount,
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


//TODO: test if works, maybe change structure
func addKillshot(_ roomNumber:Int, _ killer: Player,_ img: UIImage, _ loc: CLLocation) {
    // adds player's killshot to Storage ~~~~~~~~~~~~~
    
    // converts a player's UIImage to data
    let pngData = img.pngData()
    
    // points to the root reference
    let storageRef = Storage.storage().reference()
    
    // points to "2545"
    let roomRef = storageRef.child(String(roomNumber))
    
    // points to "2545/killshot/"
    let killshotRef = roomRef.child("killshot")
    
    // points to "2545/killshot/Bob Dylan.png"
    let fileName = String(killer.target!.name) + ".png"
    let photoRef = killshotRef.child(fileName)
    
    // uploads the png data to the correct storage location
    photoRef.putData(pngData!, metadata: nil) { (metadata, err) in
        if err != nil {
            print("didn't upload bro")
        }
    }
    
    
    // adds killshot to the killshots collection, with the target name as the id
    let gameRef = db.collection("games").document(String(roomNumber))
    
    gameRef.getDocument { (document, error) in
        if let document = document, document.exists {
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: \(dataDescription)")
            
            // gets number of players in game
            let totalPlayers = document.data()? ["totalPlayers"] as! Int
            let confirmationsNeeded = min(totalPlayers, 3);
            
            gameRef.collection("unconfirmedKillshots").document(killer.target!.name).setData([
                "confirmationsNeeded" : confirmationsNeeded,
                "assassin": killer.name,
                "accepts": 0,
                "rejects": 0,
                "latLocation": 0.0,
                "lonLocation": 0.0,
            ]) { err in if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
                }
            }
            
        } else {
            print("Document does not exist")
            
        }
    }
    
}

//TODO: implement this
func canTakeKillshot(_ player: Player) -> Bool {
    return false;
}

// should be called whenever a killshot is confirmed or denied
// if confirmations needed or denials needed is at 0, then the killshot should be removed
// player should also be removed if confirmations is at 0
func checkKillshotStatus(_ targetName: String) -> Bool {
    return false;
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
