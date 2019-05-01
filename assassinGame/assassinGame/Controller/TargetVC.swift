//
//  TargetVC.swift
//  assassinGame
//
//  Created by Divi Schmidt on 5/1/19.
//  Copyright © 2019 Divi Schmidt. All rights reserved.
//

import UIKit

class TargetVC: UIViewController {
    var game: Game?;
    var player: Player?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (game != nil) {
            player = game!.getPlayer();
            targetName.text = player!.target.name;
            targetImage.image = player!.target.image;
        }
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var targetImage: UIImageView!
    
    @IBOutlet weak var targetName: UILabel!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
