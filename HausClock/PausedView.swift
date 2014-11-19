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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.opaque = false
        self.backgroundColor = UIKit.UIColor(white: 1.0, alpha: 0.0)
        self.hidden = true
    }


    func show() {
        self.transform = CGAffineTransformScale(self.transform, 1/scaleFactor, 1/scaleFactor)
        self.hidden = false
        
        UIView.animateWithDuration(0.15, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(0))
            }, completion: nil )
    }
    
    func hide() {
        self.hidden = true
    }
}