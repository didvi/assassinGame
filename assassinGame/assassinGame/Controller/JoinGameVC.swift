//
//  JoinGameVC.swift
//  assassinGame
//
//  Created by David Kang on 4/23/19.
//  Copyright © 2019 Divi Schmidt. All rights reserved.
//

import UIKit

class JoinGameVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var nameInput: UITextField!
    @IBOutlet var playerPhoto: UIImageView!
    @IBOutlet var roomNumberInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func importImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.playerPhoto!.image = image
            
        }
        else {
            // error message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func joinGame(_ sender: Any) {
    
        let gameRef = db.collection("games").document(roomNumberInput.text!)
        
        gameRef.getDocument { (document, error) in
            
            if let document = document, document.exists {
                let player = Player(self.nameInput.text!, self.playerPhoto.image!)
                addPlayer(Int(self.roomNumberInput.text!)!, player)
                self.performSegue(withIdentifier: "joinToWaitSegue", sender: nil)
            } else {
                let alert = UIAlertController(title: "Oh no!", message: "That room doesn't exist.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "joinToWaitSegue" {
                if let dest = segue.destination as? WaitingVC {
                    dest.roomNumber = roomNumberInput.text!
                    dest.name = nameInput.text!
                }
            }
        }
    }
    
}

