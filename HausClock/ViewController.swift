//
//  ViewController.swift
//  HausClock
//
//  Created by Tom Brown on 7/13/14.
//  Copyright (c) 2014 not. All rights reserved.
//

import UIKit
import Darwin

// @Jack where do models and enums like to live?

enum PlayerPosition {
    case Top
    case Bottom

    func opposite() -> PlayerPosition {
        // Is there a less verbose way? This seems like a common case
        switch self {
        case .Top:
            return .Bottom
        case .Bottom:
            return .Top
        }
    }
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

    // TODO: Where does one normally put formatting utility functions?
    func secondsRemainingAsString() -> String {
        let minutes = secondsRemaining/60
        let seconds = secondsRemaining % 60
        let spacer = seconds < 10 ? "0" : ""
        return "\(minutes):\(spacer)\(seconds)"
    }
}

class ViewController: UIViewController {
    var players = [
        Player(position: .Top, state: .Waiting, secondsRemaining: 600), // TODO: Default vals?
        Player(position: .Bottom, state: .Waiting, secondsRemaining: 600)
    ]
    
    var gameState = GameState.Active

    @IBOutlet var topButton: UIButton!
    @IBOutlet var bottomButton: UIButton!
    
    @IBOutlet var topLabel: UILabel!
    @IBOutlet var bottomLabel: UILabel!
    
    @IBOutlet weak var topTimeView: TimeView!
    @IBOutlet weak var bottomTimeView: TimeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topLabel.transform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(M_PI))
        
        setPlayerToActive(.Top)
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("onClockTick"), userInfo: nil, repeats: true)
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
    
    func getActivePlayer() -> Player? {
        return players.filter( { $0.state == .Active } ).first
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
            break // Do nothing
        }
    }
    
    // Decrements the active player if one is available. If the player has lost, changes the player state
    func decrementActivePlayer() {
        if var activePlayer = getActivePlayer() {
            activePlayer.secondsRemaining -= 1
            
            if activePlayer.secondsRemaining <= 0 {
                gameState = .Finished
            }

            updateTimeViews()
        }
    }
}

