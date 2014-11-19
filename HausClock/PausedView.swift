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
        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(M_PI))
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1/scaleFactor, 1/scaleFactor)
        self.hidden = false
        
        UIView.animateWithDuration(0.7, delay: 0.0, options: .CurveEaseOut, animations: {
            println("Starting animation")
            self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(0))
            }, completion: { finished in
                println("Finished animation")
        })
    }
    
    func hide() {
        self.hidden = true
    }
}