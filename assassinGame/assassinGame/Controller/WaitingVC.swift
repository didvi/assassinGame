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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roomNumberLabel.text = roomNumber
        // Do any additional setup after loading the view.
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
                print("Current data: \(data)")
                self.numPlayersNeeded.text = String(data["playerCount"] as! Int)
            
                
        }
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
