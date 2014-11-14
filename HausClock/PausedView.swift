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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.opaque = false
        self.backgroundColor = UIKit.UIColor(white: 1.0, alpha: 0.0)
        self.hidden = true
    }


    func show() {
        self.hidden = false
    }
    
    func hide() {
        self.hidden = true
    }
}