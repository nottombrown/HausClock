//
//  TimeView.swift
//  HausClock
//
//  Created by Tom Brown on 10/21/14.
//  Copyright (c) 2014 not. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class TimeView: UIView {
    @IBOutlet var button: UIButton!
    @IBOutlet var label: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        println("init timeview")
        super.init(coder: aDecoder)
    }
    
    func updateWithViewModel(){
        println("update with view model")
    }
}