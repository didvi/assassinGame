//
//  CreateGameVC.swift
//  assassinGame
//
//  Created by David Kang on 4/17/19.
//  Copyright © 2019 Divi Schmidt. All rights reserved.
//

import Foundation
import UIKit

class CreateGameVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var imageToUpload: UIImageView?
    @IBOutlet var numOfPlayers: UILabel!
    @IBOutlet var nameField: UITextField!
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageToUpload?.image = UIImage(named: "blank")
        
    }
    
    @IBAction func importImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageToUpload!.image = image
            
        }
        else {
            // error message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func stepper(_ sender: UIStepper) {
        numOfPlayers.text = String(Int(sender.value))
    }
    
    @IBAction func createRoom(_ sender: Any) {
        
        let playerCount = Int(numOfPlayers!.text!)
        game = Game(playerCount!)
        
        let creator = Player(nameField.text!, (imageToUpload?.image)!)
        game.addPlayer(creator)
        
        addGame(game)
        addPlayer(game.roomNumber, creator)
        
        performSegue(withIdentifier: "createToWaitingSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "createToWaitingSegue" {
                if let dest = segue.destination as? WaitingVC {
                    dest.game = game;
                    dest.roomNumber = String(game.roomNumber);
                    dest.name = nameField.text;
                }
            }
        }
    }

    
    
    
}
