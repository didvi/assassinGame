//
//  WeaponVC.swift
//  assassinGame
//
//  Created by Divi Schmidt on 5/1/19.
//  Copyright © 2019 Divi Schmidt. All rights reserved.
//

import UIKit

class WeaponVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
// has preliminary logic- will bring up the camera when the button is clicked and can take a photo, however is not stored in the game or sent off to be verified- need to add another verification popup to ensure the user wants to send that photo or if they want to take a new one
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    
//    @IBAction func photoLibraryButtonPressed(_ sender: UIButton) {
//        let picker = UIImagePickerController();
//        picker.delegate = self;
//        picker.sourceType = .photoLibrary;
//        self.present(picker, animated: true, completion: nil);
//    }

    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        let picker = UIImagePickerController();
        picker.delegate = self;
        picker.sourceType = .camera;
        self.present(picker, animated: true, completion: nil);
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img: UIImage;
        img = info[.originalImage] as! UIImage;
        imageView.image = img;
        
        dismiss(animated: true, completion: nil);
    }
    
    func saveImage(_ img: UIImage) {
        
    }

}
