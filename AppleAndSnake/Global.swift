//
//  Global.swift
//  AppleAndSnake
//
//  Created by JackyWang on 12/11/14.
//  Copyright (c) 2014 JackyWang. All rights reserved.
//

import Foundation
import UIKit

func delayClosureWithTime(time:NSTimeInterval, closure:()->()) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
}

func animateViewPop(duration:Double, view : UIView) {
    let time = duration/3
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001)
    UIView.animateWithDuration(time, animations: { view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1)}, completion: { _ in
        UIView.animateWithDuration(time, animations: {view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)}, completion: { _ in
            UIView.animateWithDuration(time, animations: {view.transform = CGAffineTransformIdentity })
        })
    })
}

