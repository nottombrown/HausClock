//
//  Game.swift
//  HausClock
//
//  Created by Tom Brown on 11/28/14.
//  Copyright (c) 2014 not. All rights reserved.
//

import Foundation
import ReactiveCocoa
import AudioToolbox

var game = Game() // Global game instance - Is there a canonical way to do this?

class Game {
    
    enum State {
        case Initial // The game hasn't started yet
        case Active
        case Paused
        case Finished
    }
    
    var state: ObservableProperty<State> = ObservableProperty(.Initial)
    let clockTickInterval:Double = 0.1 // This currently causes massive re-rendering. Should only update text as necessary
    
    init() {
        NSTimer.scheduledTimerWithTimeInterval(clockTickInterval, target: self, selector: Selector("onClockTick"), userInfo: nil, repeats: true)
        reset()
        
        // Buzz when the game finishes
        let finishedStream = state.values().skipRepeats{ $0 == $1}.filter { $0 == Game.State.Finished }
        
        // TODO: It seems that the concatenation doesn't join correctly. Perhaps we want merge?
        let delayedStream = finishedStream.delay(3.0, onScheduler: MainScheduler())
        let doubledStream = delayedStream.concat(finishedStream)
        finishedStream.start { _ in AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate)) }
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
    
    func getPlayerByPosition(position: Player.Position) -> Player {
        return players.filter{ $0.position == position }.first!
    }
    
    private func setPlayerToActive(position: Player.Position) {
        var activePlayer = getPlayerByPosition(position)
        var inactivePlayer = getPlayerByPosition(position.opposite())
        
        activePlayer.state.value = .Active
        inactivePlayer.state.value = .Waiting
        state.value = .Active
    }
    
    private func getActivePlayer() -> Player? {
        return players.filter{ $0.state.value == Player.State.Active }.first
    }
    
    @objc private func onClockTick() {
        if state.value == .Active {
            decrementActivePlayer()
        }
    }
    
    // Decrements the active player if one is available. If the player has lost, changes the player state
    private func decrementActivePlayer() {
        if var activePlayer = getActivePlayer() {
            activePlayer.secondsRemaining.value -= clockTickInterval
            
            if activePlayer.secondsRemaining.value <= 0 {
                state.value = .Finished
            }
        }
    }
}