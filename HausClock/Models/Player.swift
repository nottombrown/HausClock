//
//  Player.swift
//  HausClock
//
//  Created by Tom Brown on 11/28/14.
//  Copyright (c) 2014 not. All rights reserved.
//

import Foundation
import ReactiveCocoa

class Player {

    enum State {
        case Active
        case Waiting
    }

    enum Position {
        case Top
        case Bottom
        
        func opposite() -> Position {
            // Is there a less verbose way? This seems like a common case
            switch self {
            case .Top:
                return .Bottom
            case .Bottom:
                return .Top
            }
        }
    }
    
    let initialTimeInSeconds:Double = 300.0
    let position: Position
    var state: ObservableProperty<State> = ObservableProperty(.Waiting)
    var secondsRemaining: ObservableProperty<Double>
    var secondsRemainingAsStringStream: ColdSignal<String>
    
    init(position:Position) {
        self.position = position
        secondsRemaining = ObservableProperty(initialTimeInSeconds)
        
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
