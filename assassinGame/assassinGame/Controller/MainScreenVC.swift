//
//  ViewController.swift
//  assassinGame
//
//  Created by Divi Schmidt on 4/10/19.
//  Copyright © 2019 Divi Schmidt. All rights reserved.
//

import UIKit

class MainScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }    
    
    
    @IBAction func createGameButton(_ sender: Any) {
        performSegue(withIdentifier: "toCreateGame", sender: nil)
    }
    

 
    
}

