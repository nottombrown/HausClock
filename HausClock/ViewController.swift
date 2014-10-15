//
//  ViewController.swift
//  HausClock
//
//  Created by Tom Brown on 7/13/14.
//  Copyright (c) 2014 not. All rights reserved.
//

import UIKit
import Darwin // For math

// TODO: Where should globals live?
let blackColor = UIColor.blackColor()
let whiteColor = UIColor.whiteColor()
let blueColor = "#91c4c5".UIColor
let redColor = "#ff0000".UIColor //TODO: Change this

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



// TODO: Is there a clean way to make this a struct instead? Would rather dispose of more state
class Player {
    let position: PlayerPosition
    var state = PlayerState.Waiting
    var secondsRemaining = 600
    
    init(position: PlayerPosition, state: PlayerState, secondsRemaining: Int) {
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


// TODO: I want this object to listen to the
class ClockButtonController: UIViewController {

    // Not sure why this hack is required. I really don't want this method
    // http://stackoverflow.com/questions/24036393/fatal-error-use-of-unimplemented-initializer-initcoder-for-class/24036440#24036440
    required init(coder aDecoder: (NSCoder!))
    {
        super.init(coder: aDecoder)
    }

}

class TopViewController: ClockButtonController {
    @IBOutlet var button: UIButton!
    @IBOutlet var label: UILabel!
    
    var player = topPlayer
    
    // TODO: How do I move these methods into the ClockButtonController where they belong?
    func update() {
        switch player.state {
        case .Active:
            button.backgroundColor = blueColor
            label.textColor = blackColor
        case .Waiting:
            button.backgroundColor = blackColor
            label.textColor = whiteColor
        }
        
        label.text = player.secondsRemainingAsString()
    }

}

class BottomViewController: ClockButtonController {
    @IBOutlet var button: UIButton!
    @IBOutlet var label: UILabel!
    
    var player = bottomPlayer
    
    // TODO: How do I move these methods into the ClockButtonController where they belong?
    func update() {
        switch player.state {
        case .Active:
            button.backgroundColor = blueColor
            label.textColor = blackColor
        case .Waiting:
            button.backgroundColor = blackColor
            label.textColor = whiteColor
        }
        
        label.text = player.secondsRemainingAsString()
    }
    
//    func viewDidLoad() {
//        super.viewDidLoad()
//        self.label.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 3.14159) // TODO: How do I get pi?
//    }

}

// TODO: Where do models that are necessary for the base UIViewController live?
var topPlayer = Player(position: .Top, state: .Waiting, secondsRemaining: 600) // TODO: Default vals?
var bottomPlayer = Player(position: .Bottom, state: .Waiting, secondsRemaining: 600)


class ViewController: UIViewController {
    
    var players = [topPlayer, bottomPlayer]
    
    var gameState = GameState.Active

    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        // Is there a common way to have these update whenever their players change?
//        topViewController.update()
//        bottomViewController.update()
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
        }
    }
}

