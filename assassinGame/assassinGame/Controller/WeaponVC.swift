//
//  WeaponVC.swift
//  assassinGame
//
//  Created by Divi Schmidt on 5/1/19.
//  Copyright © 2019 Divi Schmidt. All rights reserved.
//

import UIKit

class WeaponVC: UIViewController {
// has preliminary logic- will bring up the camera when the button is clicked and can take a photo, however is not stored in the game or sent off to be verified- need to add another verification popup to ensure the user wants to send that photo or if they want to take a new one
    
    var game: Game!;
    var player: Player!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (game != nil) {
            player = game!.getPlayer();
        }
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    
//    @IBAction func photoLibraryButtonPressed(_ sender: UIButton) {
//        let picker = UIImagePickerController();
//        picker.delegate = self;
//        picker.sourceType = .photoLibrary;
//        self.present(picker, animated: true, completion: nil);
//    }


}
