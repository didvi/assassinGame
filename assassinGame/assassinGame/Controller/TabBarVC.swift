//
//  TabBarVC.swift
//  assassinGame
//
//  Created by Divi Schmidt on 4/30/19.
//  Copyright © 2019 Divi Schmidt. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class TabBarVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate  {
    var roomNumber: Int?
    var game: Game?;
    var name: String?
    var player: Player?;
    let manager = CLLocationManager();
    var userLocation: CLLocation = CLLocation(latitude: 37.8716, longitude: 122.2727);
    
    @IBOutlet weak var targetName: UILabel?
    @IBOutlet weak var targetImage: UIImageView!
    @IBOutlet weak var toJudge: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        targetName.text = player?.target?.name;
//        targetImage.image = player?.target?.image;
        
        manager.delegate = self;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        assignTarget()
        listenDocument()
        
    }
    func assignTarget() {

        let docRef = db.collection("games").document(String(roomNumber!)).collection("players")
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var potentialTargets = [String]()
                
                for document in querySnapshot!.documents {
                    if document.documentID != self.name! {
                        potentialTargets.append(document.documentID)
                    }
                }
                
                potentialTargets.shuffle()
                for target in potentialTargets {
                    if target != self.name! {
                        self.targetName?.text = target
                    }
                }
                
                // Reference to an image file in Firebase Storage
                let reference = Storage.storage().reference().child("1842/Divi.png")
                
                reference.getData(maxSize: 7063823999) { data, error in
                    if error != nil {
                        print("oh nuuuu")
                    } else {
                        // Data for "images/island.jpg" is returned
                        let image = UIImage(data: data!)
                        self.targetImage.image = image!
                    }
                }
                
//                child("\(self.roomNumber!)/\(self.targetName!).jpg")
                
                
                
            }
            
        }
    }
    
    
    
    
    @IBAction func takePicture(_ sender: UIButton) {
        // checks if the player is allowed to take another killshot

        
        let picker = UIImagePickerController();
        picker.delegate = self;
        picker.sourceType = .camera;
        picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil);
    }
    
    // maybe change wording on the alerts-- here and in the take picture function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img: UIImage
        img = info[.originalImage] as! UIImage
        uploadKillshotPic(image: img)
        uploadKillshotName(name: targetName!.text!)
        
        dismiss(animated: true, completion: nil);
        
    }
    
    func uploadKillshotPic(image: UIImage) {
        // converts a player's UIImage to data
        let pngData = image.pngData()
        
        // points to the root reference
        let storageRef = Storage.storage().reference()
        
        // points to "2545"
        let roomRef = storageRef.child(String(roomNumber!) + "ks")
    
        // points to "2545/Bob Dylan.png"
        let fileName = String(targetName!.text!) + ".png"
        let photoRef = roomRef.child(fileName)
        
        // uploads the png data to the correct storage location
        photoRef.putData(pngData!, metadata: nil) { (metadata, err) in
            if err != nil {
                print("didn't upload bro")
            }
        }
    }
    func uploadKillshotName(name: String) {
        let dbRef = db.collection("games")
        
        // Set the "capital" field of the city 'DC'
        dbRef.document(String(roomNumber!) + "ks").setData(["name" : self.targetName!.text!])
        
       
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            userLocation = location;
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    func saveImage(_ img: UIImage) {
        manager.requestLocation()
        addKillshot(game!.roomNumber, player!.target!, img, userLocation);
    }
    
    private func listenDocument() {
        // [START listen_document]
        db.collection("games").document(String(roomNumber!) + "ks")
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                if let name = data["name"] {
                    // Reference to an image file in Firebase Storage
                    let reference = Storage.storage().reference().child(String(self.roomNumber!) + "ks/\(name).png")
                    
                    reference.getData(maxSize: 7063823999) { data, error in
                        if error != nil {
                            print("oh nuuuu")
                        } else {
                            // Data for "images/island.jpg" is returned
                            let image = UIImage(data: data!)
                            self.toJudge.image = image!
                        }
                    }
                    
                }

        }
    }
    
    


}
