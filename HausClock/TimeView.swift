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
        super.init(coder: aDecoder)
        opaque = false
        backgroundColor = UIKit.UIColor(white: 1.0, alpha: 0.0)
    }
    
    func onReady() {
        // @jack: Where do you put View things that need to happen after viewDidLoad()?
        button.backgroundColor = Colors.blackColor
        
        // Is there a way to set this font globally or in IB?
        label.font = UIFont(name: "InterstateMono-Blk", size: 88.0)
    }
    
    // TODO: is there a canonical RAC name for this observer setup method?
    func observe(player: Player) {
        player.secondsRemaining.values().start { _ in
            // TODO: we could have another signal that's stringified for less processing
            self.label.text = player.secondsRemainingAsString()
        }
        
        player.state.values().start { state in
            switch state {
            case .Active:
                // hide the black button so that the pulsating background shows through.
                // HACK: less than 0.05 opacity makes the button unclickable for some reason
                self.button.layer.opacity = 0.05
                self.label.textColor = Colors.blackColor
            case .Waiting:
                self.button.layer.opacity = 1.0
                self.label.textColor = Colors.whiteColor
            }
        }
    }
}
