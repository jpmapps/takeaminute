//
//  Privacy Policy ViewController.swift
//  Take a Minute
//
//  Created by Joe Martin on 16/02/2020.
//  Copyright © 2020 Joe Martin. All rights reserved.
//

import UIKit

class privacyPolicyViewController: UIViewController {
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
        
    }
    
    @IBOutlet weak var seedlingView: UIImageView!
    
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    
    @IBOutlet weak var privacyPolicyTextView: UITextView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)

    }
    
    
}
