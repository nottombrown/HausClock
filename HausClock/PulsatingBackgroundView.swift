//
//  PausedView.swift
//  HausClock
//
//  Created by Tom Brown on 10/21/14.
//  Copyright (c) 2014 not. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class PulsatingBackgroundView: UIView {
    
    let pulseDuration = 0.5 // Full cycle takes 1 second
    let pulseDimming = 0.60
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        pulseIn(true)
        backgroundColor = Colors.blueColor
    }
    
    func observe(game: Game) {
        game.state.values().skipRepeats{ $0 == $1}.start { state in
            (state == GameState.Active) ? self.resumeAnimation() : self.pauseAnimation()
        }
    }
    
    func pulseOut(_: Bool) {
        UIView.animateWithDuration(pulseDuration, delay: 0.0, options: .CurveEaseInOut | .AllowUserInteraction, animations: {
            self.layer.opacity = Float(self.pulseDimming)
            }, completion: pulseIn )
    }
    
    func pulseIn(_: Bool) {
        UIView.animateWithDuration(pulseDuration, delay: 0.0, options: .CurveEaseInOut | .AllowUserInteraction, animations: {
            self.layer.opacity = 1.0
            }, completion: pulseOut )
    }
    
    func pauseAnimation(){
        pausedTime = layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime!
    }
    
    private var pausedTime: CFTimeInterval?

    func resumeAnimation(){
        if var pausedTime = pausedTime? {
            layer.speed = 1.0
            layer.timeOffset = 0.0
            layer.beginTime = 0.0
            let timeSincePause = layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
            layer.beginTime = timeSincePause
        }
    }
}