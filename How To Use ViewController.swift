//
//  How To Use ViewController.swift
//  Take a Minute
//
//  Created by Joe Martin on 29/01/2020.
//  Copyright © 2020 Joe Martin. All rights reserved.
//

import Foundation
import UIKit

class HowToUseViewController: UIViewController {
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
        
    }
    
    @IBOutlet weak var takeAMinuteLabel: UILabel!
    
    @IBOutlet weak var howToUseTextView: UITextView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
}
