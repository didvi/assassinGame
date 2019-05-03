//
//  TabBarVC.swift
//  assassinGame
//
//  Created by Divi Schmidt on 4/30/19.
//  Copyright © 2019 Divi Schmidt. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    var game: Game?;
    var name: String?;
    var player: Player?;

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
            game = Game()
            game!.assignTargets()
            player = game!.getPlayer(name!);
            targetName.text = player!.target!.name;
            targetImage.image = player!.target!.image;
        }
        // Do any additional setup after loading the view.
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
    
    func saveImage(_ img: UIImage) {
        addKillshot(game!.roomNumber, player!.target!, img);
    }

}
