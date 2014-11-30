//
//  Game.swift
//  HausClock
//
//  Created by Tom Brown on 11/28/14.
//  Copyright (c) 2014 not. All rights reserved.
//

import Foundation
import Dollar
import ReactiveCocoa
import AudioToolbox

class Game {
    
    enum State {
        case Initial // The game hasn't started yet
        case Active
        case Paused
        case Finished
    }
    
    var state: ObservableProperty<State>
    let clockTickInterval:Double = 0.1 // This currently causes massive re-rendering. Should only update text as necessary
    
    init() {
        state = ObservableProperty(.Initial)
        NSTimer.scheduledTimerWithTimeInterval(clockTickInterval, target: self, selector: Selector("onClockTick"), userInfo: nil, repeats: true)
        reset()
    }
    
    var players = [
        Player(position: .Top),
        Player(position: .Bottom)
    ]
    
    func reset() {
        for player in players {
            player.secondsRemaining.value = player.initialTimeInSeconds
        }

        setPlayerToActive(.Top)
        state.value = .Initial
    }
    
    func userDidTouchButton(position: Player.Position) {
        switch state.value {
        case .Initial, .Active:
            setPlayerToActive(position)
        case .Finished, .Paused:
            break
        }
    }
    
    func setPlayerToActive(position: Player.Position) {
        var activePlayer = getPlayerByPosition(position)
        var inactivePlayer = getPlayerByPosition(position.opposite())
        
        activePlayer.state.value = .Active
        inactivePlayer.state.value = .Waiting
        state.value = .Active
    }
    
    func getPlayerByPosition(position: Player.Position) -> Player {
        return $.find(players, { $0.position == position } )!
    }
    
    func getActivePlayer() -> Player? {
        return $.find(players, { $0.state.value == Player.State.Active } )!
    }
    
    @objc func onClockTick() {
        switch state.value {
        case .Active:
            decrementActivePlayer()
        case .Finished:
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        case .Initial, .Paused:
            break
        }
    }
    
    // Decrements the active player if one is available. If the player has lost, changes the player state
    func decrementActivePlayer() {
        if var activePlayer = getActivePlayer() {
            activePlayer.secondsRemaining.value -= clockTickInterval
            
            if activePlayer.secondsRemaining.value <= 0 {
                state.value = .Finished
            }
        }
    }
}