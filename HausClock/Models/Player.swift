//
//  Player.swift
//  HausClock
//
//  Created by Tom Brown on 11/28/14.
//  Copyright (c) 2014 not. All rights reserved.
//

import Foundation
import ReactiveCocoa

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
    let initialTimeInSeconds:Double = 20.0

    let position: PlayerPosition
    var state: ObservableProperty<PlayerState>
    var secondsRemaining: ObservableProperty<Double>
    
    var secondsRemainingAsStringStream: ColdSignal<String>
    
    init(position:PlayerPosition) {
        self.position = position
        self.secondsRemaining = ObservableProperty(initialTimeInSeconds)
        state = ObservableProperty(PlayerState.Waiting)
        
        // Convert the seconds remaining into a stream and skip the repeats
        secondsRemainingAsStringStream = secondsRemaining.values().map(Player.formatSecondsRemainingAsString).skipRepeats{ $0 == $1 }
    }

    private class func formatSecondsRemainingAsString(seconds: Double) -> String {
        let minutes = Int(seconds)/60
        let seconds = Int(seconds) % 60
        let spacer = seconds < 10 ? "0" : ""
        return "\(minutes):\(spacer)\(seconds)"
    }
}
