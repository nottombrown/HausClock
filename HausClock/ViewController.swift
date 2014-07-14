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
    
    var topSecondsRemaining = 600
    var bottomSecondsRemaining = 600
    
    @IBOutlet var topButton: UIButton
    @IBOutlet var bottomButton: UIButton
    
    @IBOutlet var topLabel: UILabel
    @IBOutlet var bottomLabel: UILabel
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("onClockTick"), userInfo: nil, repeats: true)
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
    
    func onClockTick() {
        topSecondsRemaining -= 1
        bottomSecondsRemaining -= 1
        topLabel.text = secondsToString(topSecondsRemaining)
        bottomLabel.text = secondsToString(bottomSecondsRemaining)
    }

    func secondsToString(seconds: Int) -> String {
        return "\(seconds/60):\(seconds % 60)"
    }
    
}

