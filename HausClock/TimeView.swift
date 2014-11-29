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
    
    func setFont() {
        // @jack: Where do you put View things that need to happen after viewDidLoad()?
        // Is there a way to set this font globally or in IB?
        label.font = UIFont(name: "InterstateMono-Blk", size: 88.0)
    }
    
    func updateWithViewModel(player: Player){
        setFont()
        
        button.backgroundColor = Colors.blackColor
        
        // Set colors
        switch player.state {
        case .Active:
            // hide the black button so that the pulsating background shows through. 
            // HACK: less than 0.05 opacity makes the button unclickable for some reason
            button.layer.opacity = 0.05
            label.textColor = Colors.blackColor
        case .Waiting:
            button.layer.opacity = 1.0
            label.textColor = Colors.whiteColor
        }
        
        // Set seconds remaining
        label.text = player.secondsRemainingAsString()
    }

    // TODO: is there a canonical RAC name for this observer setup method?
    func observePlayer(player: Player) {
//        self.player = player // Cache the model
//        onReady() // TODO: e.g. $.ready()
        
        player.secondsRemaining.values().start { _ in
            // Set seconds remaining
            self.updateWithViewModel(player)
        }
        
    }
}
