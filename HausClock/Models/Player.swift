//
//  Player.swift
//  HausClock
//
//  Created by Tom Brown on 11/28/14.
//  Copyright (c) 2014 not. All rights reserved.
//

import Foundation

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

class Player {
    let position: PlayerPosition
    var state = PlayerState.Waiting
    var secondsRemaining = initialTimeInSeconds
    
    init(position:PlayerPosition) {
        self.position = position
    }
    
    // TODO: Where does one normally put formatting utility functions?
    func secondsRemainingAsString() -> String {
        
        let minutes = Int(secondsRemaining)/60
        let seconds = Int(secondsRemaining) % 60
        let spacer = seconds < 10 ? "0" : ""
        return "\(minutes):\(spacer)\(seconds)"
    }
}
