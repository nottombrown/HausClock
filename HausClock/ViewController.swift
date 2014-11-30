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

class ViewController: UIViewController {

    @IBOutlet weak var pausedView: PausedView!
    @IBOutlet weak var topTimeView: TimeView!
    @IBOutlet weak var bottomTimeView: TimeView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var pulsatingBackgroundView: PulsatingBackgroundView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTimeView.label.transform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(M_PI))
        
        topTimeView.observe(game.getPlayerByPosition(.Top))
        bottomTimeView.observe(game.getPlayerByPosition(.Bottom))
        
        pulsatingBackgroundView.observe(game)
    }
    
    override func viewWillLayoutSubviews() {
        [topTimeView, bottomTimeView].map( { $0.onReady() })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func touchTopButton(sender: UIButton) {
        game.userDidTouchButton(.Bottom)
    }
    
    @IBAction func touchBottomButton(sender: UIButton) {
        game.userDidTouchButton(.Top)
    }
}

// Pausing and resuming the game
extension ViewController {
    
    @IBAction func touchPauseButton(sender: UIButton) {
        pausedView.show()
        game.state.value = .Paused
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
        game.state.value = .Active
        pulsatingBackgroundView.resumeAnimation()
    }
    
    @IBAction func touchResetButton(sender: AnyObject) {
        game.reset()
        pausedView.hide()
    }
}

