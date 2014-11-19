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
class ButtonWithCustomDragBounds: UIButton {
    
    // By default, buttons have bounds of 100px, this lets us customize
    let boundsExtension = CGFloat(25)
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        
        let outerBounds = CGRectInset(self.bounds, -1*boundsExtension, -1*boundsExtension)

        // Are we currently inside?
        let touchInside = CGRectContainsPoint(outerBounds, touch.locationInView(self))

        // Were we last inside?
        let previousTouchInside = CGRectContainsPoint(outerBounds, touch.previousLocationInView(self))

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