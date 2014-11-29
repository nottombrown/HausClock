//
//  ViewController.swift
//  HausClock
//
//  Created by Tom Brown on 7/13/14.
//  Copyright (c) 2014 not. All rights reserved.
//

import UIKit
import Darwin
import ReactiveCocoa

// @Jack where do models and enums like to live?

let clockTickInterval:Double = 0.1 // This currently causes massive re-rendering. Should only update text as necessary

class ViewController: UIViewController {

    var game = Game()
    
    @IBOutlet weak var pausedView: PausedView!
    @IBOutlet weak var topTimeView: TimeView!
    @IBOutlet weak var bottomTimeView: TimeView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var pulsatingBackgroundView: PulsatingBackgroundView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTimeView.label.transform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(M_PI))
        
        NSTimer.scheduledTimerWithTimeInterval(clockTickInterval, target: self, selector: Selector("onClockTick"), userInfo: nil, repeats: true)
        
        updateTimeViews() // TODO: Use observer for all these calls
    }
    
    override func viewWillLayoutSubviews() {
        [topTimeView, bottomTimeView].map( { $0.setFont() })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func touchTopButton(sender: UIButton) {
        game.setPlayerToActive(.Bottom)
        updateTimeViews() // TODO: Use observer for all these calls
    }
    
    @IBAction func touchBottomButton(sender: UIButton) {
        game.setPlayerToActive(.Top)
        updateTimeViews() // TODO: Use observer for all these calls
    }
    
    func updateTimeViews() {
        // TODO: Replace this call with Observer pattern
        topTimeView.updateWithViewModel(game.getPlayerByPosition(.Top))
        bottomTimeView.updateWithViewModel(game.getPlayerByPosition(.Bottom))
    }
    
    func onClockTick() {
        switch game.state {
        case .Active:
            decrementActivePlayer()
        case .Finished:
            break
        case .Paused:
            break
        }
    }
    
    // Decrements the active player if one is available. If the player has lost, changes the player state
    func decrementActivePlayer() {
        if var activePlayer = game.getActivePlayer() {
            activePlayer.secondsRemaining.value -= clockTickInterval
            
            if activePlayer.secondsRemaining.value <= 0 {
                game.state = .Finished
            }
            updateTimeViews()
        }
    }
}

// Pausing and resuming the game
extension ViewController {
    
    @IBAction func touchPauseButton(sender: UIButton) {
        pausedView.show()
        game.state = .Paused
        pulsatingBackgroundView.pauseAnimation() // TODO: Use observers instead
    }
    
    @IBAction func shrinkPauseButton(sender: AnyObject) {
        UIView.animateWithDuration(0.15, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.pauseButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFloat(0.8), CGFloat(0.8))
            }, completion: nil)
    }
    
    @IBAction func expandPauseButton(sender: AnyObject) {
        UIView.animateWithDuration(0.15, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.pauseButton.transform = CGAffineTransformIdentity
            }, completion: nil )
    }
    
    @IBAction func touchResumeButton(sender: AnyObject) {
        pausedView.hide()
        game.state = .Active
        pulsatingBackgroundView.resumeAnimation()
    }
    
    @IBAction func touchResetButton(sender: AnyObject) {
        game.reset()
        pausedView.hide()
    }
}

