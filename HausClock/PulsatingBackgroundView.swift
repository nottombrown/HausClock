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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        pulseIn(true)
        backgroundColor = Colors.blueColor
    }
    
    func pulseOut(_: Bool) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut | .AllowUserInteraction, animations: {
            self.layer.opacity = 0.7
            }, completion: pulseIn )
    }
    
    func pulseIn(_: Bool) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut | .AllowUserInteraction, animations: {
            self.layer.opacity = 1.0
            }, completion: pulseOut )
    }
}