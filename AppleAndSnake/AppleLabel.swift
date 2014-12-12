//
//  AppleLabel.swift
//  AppleAndSnake
//
//  Created by JackyWang on 12/12/14.
//  Copyright (c) 2014 JackyWang. All rights reserved.
//

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
    
//    appleLabel!.attributedText = NSAttributedString.init(string: "🍎", attributes:[NSFontAttributeName : UIFont.systemFontOfSize(CGFloat(snake.width - 4))])
}
