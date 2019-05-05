//
//  TabBarVC.swift
//  assassinGame
//
//  Created by Divi Schmidt on 4/30/19.
//  Copyright © 2019 Divi Schmidt. All rights reserved.
//

import UIKit
import CoreLocation

class TabBarVC: UITabBarController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate  {
    var game: Game?;
    var name: String?;
    var player: Player?;
    let manager = CLLocationManager();
    var userLocation: CLLocation = CLLocation(latitude: 37.8716, longitude: 122.2727);
    
    @IBOutlet weak var targetName: UILabel!
    @IBOutlet weak var targetImage: UIImageView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name = "jack"
        
        if (game != nil) {
            game!.assignTargets()
            player = game!.getPlayer();
            targetName.text = player?.target?.name;
            targetImage.image = player?.target?.image;
        } else {
            // should be changed to get game from database
            game = Game()
            game!.assignTargets()
            player = game!.getPlayer(name!);
            targetName.text = player!.target!.name;
            targetImage.image = player!.target!.image;
        }
        // Do any additional setup after loading the view.
        
        manager.delegate = self;
    }
    
    @IBAction func takePicture(_ sender: UIButton) {
        // checks if the player is allowed to take another killshot
        if (canTakeKillshot(player!)) {
            let alert = UIAlertController(title: "Patience", message: "You can only take another killshot once yours is accepted or denied", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        }
        
        let picker = UIImagePickerController();
        picker.delegate = self;
        picker.sourceType = .camera;
        self.present(picker, animated: true, completion: nil);
    }
    
    // maybe change wording on the alerts-- here and in the take picture function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img: UIImage;
        img = info[.originalImage] as! UIImage;
        imageView.image = img;
        
        dismiss(animated: true, completion: nil);

        let alert = UIAlertController(title: "Is this a valid picture of your target?", message: "You only get one shot until your picture is confirmed or denied.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: {action in
            self.saveImage(img);
        }))
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
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

}
