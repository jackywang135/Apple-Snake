//
//  Snake.swift
//  AppleAndSnake
//
//  Created by JackyWang on 10/7/14.
//  Copyright (c) 2014 JackyWang. All rights reserved.
//

import Foundation
import CoreGraphics
import Darwin

enum Direction {
    case north, east, south, west
}

class Snake : NSObject{
    
    var length : Float {
        didSet {
            if length < 2 {
                self.length = 2
            }
        }

    }
    
    var width : Float {
        get {
            return Float(self.snakeHead.size.width)
        }
        set {
            if (width < 8) {
                self.width = 8
           }
        }
    }
    
    var currentDirection : Direction!
    var snakeBody = [CGRect]()
    var snakeHead : CGRect {
        get {
            return self.snakeBody.first!
        }

    }
    
    init(length:Float, direction:Direction, width:float snakeHeadPosition:CGPoint){
        //super.init()
        self.length = length
        self.currentDirection = direction
        self.snakeBody.append(snakeHeadRect)
    }
    
}