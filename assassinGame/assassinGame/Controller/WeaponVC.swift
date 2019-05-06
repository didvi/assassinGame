//
//  WeaponVC.swift
//  assassinGame
//
//  Created by Divi Schmidt on 5/1/19.
//  Copyright © 2019 Divi Schmidt. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class WeaponVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {



    override func viewDidLoad() {
        super.viewDidLoad()
        takePicture()
    }


        
    
    func takePicture() {
        // checks if the player is allowed to take another killshot

        
        let picker = UIImagePickerController();
        picker.delegate = self;
        picker.sourceType = .camera;
        self.present(picker, animated: true, completion: nil);
    }
    
    // maybe change wording on the alerts-- here and in the take picture function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img: UIImage;
        img = info[.originalImage] as! UIImage;
//        imageView.image = img;
        
        dismiss(animated: true, completion: nil);
        
        let alert = UIAlertController(title: "Is this a valid picture of your target?", message: "You only get one shot until your picture is confirmed or denied.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: {action in
//            self.saveImage(img);
        }))
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }

}
