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
    
    
    // MARK: Initializer
    init(length:Int, direction:Direction, snakeHeadRect:CGRect){
        if length < 2 {
            self.length = 2
        } else {
            self.length = length
        }
        
        self.currentDirection = direction
        
        if (snakeHeadRect.size.height < 8 || snakeHeadRect.size.width < 8) {
            let snakeHeadPoint = snakeHeadRect.origin
            let newSnakeHeadRect : CGRect = CGRectMake(snakeHeadPoint.x, snakeHeadPoint.y, 8, 8)
            self.snakeBody.append(newSnakeHeadRect)
        } else {
            self.snakeBody.append(snakeHeadRect)
        }
    }
    
    // MARK: Variables
    var length : Int
    var currentDirection : Direction!
    var snakeHead : CGRect {
        get {
            return self.snakeBody.first!
        }

    }
    var snakeBody = [CGRect]()
    var width : CGFloat {
        get {
            return self.snakeHead.size.width
        }
    }
    

    
}