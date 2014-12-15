//
//  AppleLabel.swift
//  AppleAndSnake
//
//  Created by JackyWang on 12/12/14.
//  Copyright (c) 2014 JackyWang. All rights reserved.
//

//Unused
import Foundation
import UIKit

class AppleLabel : UILabel {
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        text = "🍎"
        font = UIFont.systemFontOfSize(snakeWidth)
        adjustsFontSizeToFitWidth = true
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        animateViewPop(0.5, self)
    }
}
