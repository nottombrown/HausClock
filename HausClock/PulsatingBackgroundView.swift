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
    
    let pulseDuration = 0.5
    let pulseDimming = 0.6
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        pulseIn(true)
        backgroundColor = Colors.blueColor
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
}