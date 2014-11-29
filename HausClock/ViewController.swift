//
//  ViewController.swift
//  HausClock
//
//  Created by Tom Brown on 7/13/14.
//  Copyright (c) 2014 not. All rights reserved.
//

import UIKit
import Darwin
import Dollar

// @Jack where do models and enums like to live?

let clockTickInterval = 0.1 // This currently causes massive re-rendering. Should only update text as necessary
let initialTimeInSeconds = 20.0


class ViewController: UIViewController {
    var players = [
        Player(position: .Top),
        Player(position: .Bottom)
    ]
    
    var gameState = GameState.Paused
    
    @IBOutlet weak var pausedView: PausedView!
    @IBOutlet weak var topTimeView: TimeView!
    @IBOutlet weak var bottomTimeView: TimeView!
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTimeView.label.transform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(M_PI))
        
        resetGameState()
        NSTimer.scheduledTimerWithTimeInterval(clockTickInterval, target: self, selector: Selector("onClockTick"), userInfo: nil, repeats: true)
    }
    
    override func viewWillLayoutSubviews() {
        [topTimeView, bottomTimeView].map( { $0.setFont() })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func resetGameState() {
        for player in players {
            player.secondsRemaining = initialTimeInSeconds
        }
        
        setPlayerToActive(.Top)
        gameState = .Paused
        updateTimeViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func touchTopButton(sender: UIButton) {
        setPlayerToActive(.Bottom)
    }
    
    @IBAction func touchBottomButton(sender: UIButton) {
        setPlayerToActive(.Top)
    }
    
    func getPlayerByPosition(position: PlayerPosition) -> Player {
        return $.find(players, { $0.position == position } )!
    }
    
    func getActivePlayer() -> Player? {
        return $.find(players, { $0.state == PlayerState.Active } )!
    }

    func setPlayerToActive(position: PlayerPosition) {
        var activePlayer = getPlayerByPosition(position)
        var inactivePlayer = getPlayerByPosition(position.opposite())
        
        activePlayer.state = .Active
        inactivePlayer.state = .Waiting
        gameState = .Active

        updateTimeViews()
    }
    
    func updateTimeViews() {
        // TODO: Replace this call with Observer pattern
        topTimeView.updateWithViewModel(getPlayerByPosition(.Top))
        bottomTimeView.updateWithViewModel(getPlayerByPosition(.Bottom))
    }
    
    func onClockTick() {
        switch gameState {
        case .Active:
            decrementActivePlayer()
        case .Finished:
            decrementActivePlayer()
        case .Paused:
            break
        }
    }
    
    // Decrements the active player if one is available. If the player has lost, changes the player state
    func decrementActivePlayer() {
        if var activePlayer = getActivePlayer() {
            activePlayer.secondsRemaining -= clockTickInterval
            
            if activePlayer.secondsRemaining <= 0 {
                gameState = .Finished
            }
            updateTimeViews()
        }
    }
}

// Pausing and resuming the game
extension ViewController {
    
    @IBAction func touchPauseButton(sender: UIButton) {
        pausedView.show()
        gameState = .Paused
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
        gameState = .Active
    }
    
    @IBAction func touchResetButton(sender: AnyObject) {
        resetGameState()
        pausedView.hide()
    }
}

