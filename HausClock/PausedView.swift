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
class PausedView: UIView {

    
    let scaleFactor = CGFloat(224.0/107.0) // The view starts out small and grows to 224 px
    let largeTransform: CGAffineTransform
    let smallTransform: CGAffineTransform
    
    
    
    required init(coder aDecoder: NSCoder) {
        // It would be nice to be able to initialize these constants earlier, but swift complains that scaleFactor is not available
        self.largeTransform = CGAffineTransformIdentity
        self.smallTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1/scaleFactor, 1/scaleFactor)
        
        super.init(coder: aDecoder)
        
        opaque = false
        backgroundColor = UIKit.UIColor(white: 1.0, alpha: 0.0)
        
        hide()
    }


    func show() {
        hidden = false
        
        UIView.animateWithDuration(0.15, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.transform = CGAffineTransformRotate(self.largeTransform, CGFloat(0))
            }, completion: nil )
    }
    
    func hide() {
        UIView.animateWithDuration(0.05, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.transform = CGAffineTransformRotate(self.smallTransform, CGFloat(0))
            }, completion: { success in
                self.hidden = true
        })            
    }
}