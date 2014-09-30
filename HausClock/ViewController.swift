//
//  ViewController.swift
//  HausClock
//
//  Created by Tom Brown on 7/13/14.
//  Copyright (c) 2014 not. All rights reserved.
//

import UIKit

enum Player {
    case Top
    case Bottom
}

enum GameState {
    case Active
    case Paused
}


class ViewController: UIViewController {
    
    let blackColor = UIColor.blackColor()
    let whiteColor = UIColor.whiteColor()
    let blueColor = "#91c4c5".UIColor
    
    var topSecondsRemaining = 600
    var bottomSecondsRemaining = 600
    
    var activePlayer = Player.Bottom
    var gameState = GameState.Paused
    
    @IBOutlet var topButton: UIButton!
    @IBOutlet var bottomButton: UIButton!
    
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topLabel.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 3.14159) // TODO: How do I get pi?

        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("onClockTick"), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func touchPauseButton(sender: UIButton) {
        gameState = .Paused
    }
    
    @IBAction func touchTopButton(sender: UIButton) {
        setPlayerToActive(.Bottom)
    }
    
    @IBAction func touchBottomButton(sender: UIButton) {
        setPlayerToActive(.Top)
    }
    
    func setPlayerToActive(player: Player) {
        activePlayer = player
        gameState = .Active
        // TODO: Is there a clean way to just listen to the activePlayer switching?
        
        switch activePlayer {
        case .Top:
            topButton.backgroundColor = blueColor
            bottomButton.backgroundColor = blackColor
            topLabel.textColor = blackColor
            bottomLabel.textColor = whiteColor
            
        case .Bottom:
            topButton.backgroundColor = blackColor
            bottomButton.backgroundColor = blueColor
            bottomLabel.textColor = blackColor
            topLabel.textColor = whiteColor

        }
    }
    
    func onClockTick() {
        if gameState == .Paused {
            return
        }
        
        switch activePlayer {
        case .Top:
            topSecondsRemaining -= 1
        case .Bottom:
            bottomSecondsRemaining -= 1
        }

        topLabel.text = secondsToString(topSecondsRemaining)
        bottomLabel.text = secondsToString(bottomSecondsRemaining)
    }

    func secondsToString(totalSeconds: Int) -> String {
        let minutes = totalSeconds/60
        let seconds = totalSeconds % 60
        let spacer = seconds < 10 ? "0" : ""
        return "\(minutes):\(spacer)\(seconds)"
    }
    
}

