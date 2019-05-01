//
//  TabBarVC.swift
//  assassinGame
//
//  Created by Divi Schmidt on 4/30/19.
//  Copyright © 2019 Divi Schmidt. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
    var game: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (game != nil) {
            game!.assignTargets()
        }
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toTargetScreen" {
                if let dest = segue.destination as? TargetVC {
                    dest.game = game
                }
            }
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
