//
//  ViewController.swift
//  HausClock
//
//  Created by Tom Brown on 7/13/14.
//  Copyright (c) 2014 not. All rights reserved.
//

import UIKit
import Darwin

enum PlayerPosition {
    case Top
    case Bottom
}

enum PlayerState {
    case Active
    case Waiting
}

enum GameState {
    case Active
    case Paused
    case Finished
}

class Player {
    let position: PlayerPosition
    var state = PlayerState.Waiting
    var secondsRemaining = 600
    
    init(position:PlayerPosition, state:PlayerState,secondsRemaining:Int){
        self.position = position
        self.state = state
        self.secondsRemaining = secondsRemaining
    }
}

class ViewController: UIViewController {
    
    let blackColor = UIColor.blackColor()
    let whiteColor = UIColor.whiteColor()
    let blueColor = "#91c4c5".UIColor
    let redColor = "#ff0000".UIColor //TODO: Change this

    var players = [
        Player(position: .Top, state: .Waiting, secondsRemaining: 600), // TODO: Default vals?
        Player(position: .Bottom, state: .Waiting, secondsRemaining: 600)
    ]
    
    var gameState = GameState.Active
    
    @IBOutlet var topButton: UIButton!
    @IBOutlet var bottomButton: UIButton!
    
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topLabel.transform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(M_PI))

        setPlayerToActive(.Top)
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
    
    func getPlayerByPosition(position: PlayerPosition) -> Player {
        return players.filter( { $0.position == position } ).first!
    }

    func getOppositePlayerByPosition(position: PlayerPosition) -> Player {
        // DRY this up, create PlayerPosition#Opposite
        return players.filter( { $0.position != position } ).first!
    }
    
    func getActivePlayer() -> Player? {
        return players.filter( { $0.state == .Active } ).first
    }

    func setPlayerToActive(position: PlayerPosition) {
        var activePlayer = getPlayerByPosition(position)
        var inactivePlayer = getOppositePlayerByPosition(position)
        
        activePlayer.state = .Active
        inactivePlayer.state = .Waiting
        gameState = GameState.Active

        switch position {
        case .Top:
            // DRY this up -> The topButton and bottomButton should listen for state changes on the player
            // What is the cleanest way to do this? Make another controller for each half?

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
        switch gameState {
        case .Active:
            decrementActivePlayer()
        case .Finished:
            decrementActivePlayer()
        case .Paused:
            println("pass") // TODO: is there a "pass" or some such?
        }
    }
    
    // Decrements the active player if one is available. If the player has lost, changes the player state
    func decrementActivePlayer() {
        if var activePlayer = getActivePlayer() {
            activePlayer.secondsRemaining -= 1
            
            if activePlayer.secondsRemaining <= 0 {
                gameState = .Finished
            }

            topLabel.text = secondsToString(getPlayerByPosition(.Top).secondsRemaining)
            bottomLabel.text = secondsToString(getPlayerByPosition(.Bottom).secondsRemaining)
        }
    }

    func secondsToString(totalSeconds: Int) -> String {
        let minutes = totalSeconds/60
        let seconds = totalSeconds % 60
        let spacer = seconds < 10 ? "0" : ""
        return "\(minutes):\(spacer)\(seconds)"
    }
}

