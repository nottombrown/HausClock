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
        
        observe()
        pulsatingBackgroundView.observe(game)
    }
    
    func observe() {
        let gameStateStream = game.state.values().start { state in
            if (state == .Paused) {
                self.pausedView.show()
            } else {
                self.pausedView.hide()
            }
        }
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
    
    @IBAction func touchPauseButton(sender: UIButton) {
        game.state.value = .Paused
    }
    
    // Pause screen buttons
    @IBAction func touchResumeButton(sender: AnyObject) {
        game.state.value = .Active
    }
    
    @IBAction func touchResetButton(sender: AnyObject) {
        game.reset()
    }
    
    // Pretty animation on touching the pause button
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
}

