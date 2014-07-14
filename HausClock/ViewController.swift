//
//  ViewController.swift
//  HausClock
//
//  Created by Tom Brown on 7/13/14.
//  Copyright (c) 2014 not. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let blackColor = UIColor.blackColor()
    let whiteColor = UIColor.whiteColor()
    let blueColor = UIColor(rgba: "#91c4c5")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func touchPauseButton(sender: UIButton) {

    }
    
    @IBAction func touchTopButton(sender: UIButton) {
        sender.backgroundColor = blueColor
    }
    
    @IBAction func touchBottomButton(sender: UIButton) {
        sender.backgroundColor = blackColor
    }
    
    func setSideToActive(UIButton) {
        
    }
}

