//
//  Global.swift
//  AppleAndSnake
//
//  Created by JackyWang on 12/11/14.
//  Copyright (c) 2014 JackyWang. All rights reserved.
//

import Foundation
import UIKit

enum DeviceType {
    case iPhone4or4S, iPhone5or5S, iPhone6, iPhone6Plus, iPad, unspecified
}

var DeviceModel : DeviceType {
    struct deviceSingleton {
        static let type = getDeviceType()
    }
    return deviceSingleton.type
}

func getDeviceType() -> DeviceType {
    
    let iPhone6PlusScreenHeight = CGFloat(736)
    let iPhone6ScreenHeight = CGFloat(667)
    let iPhone5ScreenHeight = CGFloat(568)
    let iPhone4ScreenHeight = CGFloat(480)
    
    switch screenHeight {
    case iPhone4ScreenHeight: return .iPhone4or4S
    case iPhone5ScreenHeight: return .iPhone5or5S
    case iPhone6ScreenHeight: return .iPhone6
    case iPhone6PlusScreenHeight: return .iPhone6Plus
    case let x where screenHeight > iPhone6PlusScreenHeight : return .iPad
    default : return .unspecified
    }
}

let screenHeight = UIScreen.mainScreen().bounds.height
let screenWidth = UIScreen.mainScreen().bounds.width

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


