//
//  ShrinkingButton.swift
//  HausClock
//
//  Created by Tom Brown on 11/18/14.
//  Copyright (c) 2014 not. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ShrinkingButton: UIButton {

    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        let boundsExtension = CGFloat(25.0)
        let outerBounds = CGRectInset(self.bounds, -1*boundsExtension, -1*boundsExtension)

        // Are we currently inside?
        let touchInside = CGRectContainsPoint(outerBounds, touch.locationInView(self))
        // println("touchInside: \(touchInside)")

        // Were we last inside?
        let previousTouchInside = CGRectContainsPoint(outerBounds, touch.previousLocationInView(self))
        // println("previousTouchInside: \(previousTouchInside)")

        if touchInside {
            if previousTouchInside {
                self.sendActionsForControlEvents(UIControlEvents.TouchDragInside)
            } else {
                self.sendActionsForControlEvents(UIControlEvents.TouchDragEnter)
            }
        } else {
            // Current touch is outside
            if previousTouchInside {
                self.sendActionsForControlEvents(UIControlEvents.TouchDragExit)
            } else {
                self.sendActionsForControlEvents(UIControlEvents.TouchDragOutside)
            }
        }
        
        
        return super.continueTrackingWithTouch(touch, withEvent: event)
    }
}