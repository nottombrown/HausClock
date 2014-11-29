//
//  Game.swift
//  HausClock
//
//  Created by Tom Brown on 11/28/14.
//  Copyright (c) 2014 not. All rights reserved.
//

import Foundation
import Dollar

enum GameState {
    case Active
    case Paused
    case Finished
}

class Game {
    var state = GameState.Paused
    
    init() {
        reset()
    }
    
    var players = [
        Player(position: .Top),
        Player(position: .Bottom)
    ]
    
    func reset() {
        for player in players {
            player.secondsRemaining = initialTimeInSeconds
        }

        setPlayerToActive(.Top)
        state = .Paused
    }
    
    func setPlayerToActive(position: PlayerPosition) {
        var activePlayer = getPlayerByPosition(position)
        var inactivePlayer = getPlayerByPosition(position.opposite())
        
        activePlayer.state = .Active
        inactivePlayer.state = .Waiting
        state = .Active
    }
    
    func getPlayerByPosition(position: PlayerPosition) -> Player {
        return $.find(players, { $0.position == position } )!
    }
    
    func getActivePlayer() -> Player? {
        return $.find(players, { $0.state == PlayerState.Active } )!
    }
}