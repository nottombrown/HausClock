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
    

    func setFont() {
        // @jack: Where do you put View things that need to happen after viewDidLoad()?
        // Is there a way to set this font globally or in IB?
        label.font = UIFont(name: "InterstateMono-Blk", size: 88.0)
    }
    
    func updateWithViewModel(player: Player){
        setFont()
        // Set colors
        switch player.state {
        case .Active:
            button.backgroundColor = Colors.blueColor
            label.textColor = Colors.blackColor
        case .Waiting:
            button.backgroundColor = Colors.blackColor
            label.textColor = Colors.whiteColor
        }
        
        // Set seconds remaining
        label.text = player.secondsRemainingAsString()
    }
}
