//
//  WaitingVC.swift
//  assassinGame
//
//  Created by David Kang on 4/24/19.
//  Copyright © 2019 Divi Schmidt. All rights reserved.
//

import UIKit
import Firebase

class WaitingVC: UIViewController {


    @IBOutlet var roomNumberLabel: UILabel!
    @IBOutlet var numPlayersNeeded: UILabel!
    var roomNumber: String? = nil
    var game: Game!;
    var name: String!;
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomNumberLabel.text = roomNumber
        listenDocument()
        
    }
    
    private func listenDocument() {
        // [START listen_document]
        db.collection("games").document(roomNumber!)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                self.numPlayersNeeded.text = String(data["playerCount"] as! Int)
                if (self.numPlayersNeeded.text == "0") {
                    self.performSegue(withIdentifier: "waitingToGame", sender: nil)
                }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "waitingToGame" {
                if let dest = segue.destination as? TabBarVC {
                    dest.name = name;
                    dest.roomNumber = Int(roomNumber!)!
                }
            }
        }
    }
    
}
