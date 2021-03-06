//
//  Snake.swift
//  AppleAndSnake
//
//  Created by JackyWang on 10/7/14.
//  Copyright (c) 2014 JackyWang. All rights reserved.
//

import Foundation
import CoreGraphics

// MARK: Type Definition

enum Direction {
    case  east, south, west, north
}

extension Direction {
    func opposite() -> Direction {
        switch self {
        case .north:
            return .south
        case .east:
            return .west
        case .south:
            return .north
        case .west:
            return .east
        }
    }
}

class Snake : NSObject {
    
    // MARK: Properties
    
    var length : Int {
        get {
            return self.body.count
        }
    }
    var currentDirection : Direction
    var head : CGRect {
        get {
            return self.body.first!
        }
        
    }
    var body = [CGRect]()
    var width : Int {
        get {
            return Int(self.head.size.width)
        }
    }

    // MARK: Initializer
    
    init (length:Int, direction:Direction, snakeHeadRect:CGRect) {
   
        self.currentDirection = direction
        self.body.append(snakeHeadRect)
        
        assert(length > 2, "Length must be greater than 2")
        assert(snakeHeadRect.size.height >= 8 || snakeHeadRect.size.width >= 8 || snakeHeadRect.size.height != snakeHeadRect.size.width , "SnakeHeadRect.height and .width must be greater than 8 and equal")
        
        //Create Body After Parameters given
        let getWidth = Int(snakeHeadRect.size.width)
        for bodyIndex in 1..<length {
    
            var newBodyPoint : CGPoint?
            
            switch direction {
            case .north:
                newBodyPoint = CGPointMake(snakeHeadRect.origin.x, snakeHeadRect.origin.y + CGFloat(getWidth * bodyIndex))
            case .south:
                newBodyPoint = CGPointMake(snakeHeadRect.origin.x, snakeHeadRect.origin.y - CGFloat(getWidth * bodyIndex))
            case .east:
                newBodyPoint = CGPointMake(snakeHeadRect.origin.x - CGFloat(getWidth * bodyIndex), snakeHeadRect.origin.y)
            case .west:
                newBodyPoint = CGPointMake(snakeHeadRect.origin.x + CGFloat(getWidth * bodyIndex), snakeHeadRect.origin.y)
            }
            var newBodyRect = CGRectMake(newBodyPoint!.x, newBodyPoint!.y, CGFloat(getWidth), CGFloat(getWidth))
            self.body.append(newBodyRect)
        }
    }



    // MARK: Methods 
    
    func changeDirection(newDirection:Direction) {
        if newDirection != self.currentDirection.opposite() {
            self.currentDirection = newDirection
        }
    }
    
    func move() {
        self.growHead()
        self.body.removeLast()
    }
    
    func growHead() {
        var newSnakeHead : CGRect?
        switch self.currentDirection {
        case .north:
            newSnakeHead = CGRectMake(self.head.origin.x, self.head.origin.y - CGFloat(self.width), CGFloat(self.width), CGFloat(self.width))
        case .south:
            newSnakeHead = CGRectMake(self.head.origin.x, self.head.origin.y + CGFloat(self.width), CGFloat(self.width), CGFloat(self.width))
        case .east:
            newSnakeHead = CGRectMake(self.head.origin.x + CGFloat(self.width), self.head.origin.y, CGFloat(self.width), CGFloat(self.width))
        case .west:
            newSnakeHead = CGRectMake(self.head.origin.x - CGFloat(self.width), self.head.origin.y, CGFloat(self.width), CGFloat(self.width))
        }
        self.body.insert(newSnakeHead!, atIndex: 0)
    }
    
    func growTail() {
        var snakeTail : CGPoint = self.body.last!.origin
        var snakeSecondToLastTail : CGPoint = self.body[self.body.count-2].origin
        let xDistance = snakeTail.x - snakeSecondToLastTail.x
        let yDistance = snakeTail.y - snakeSecondToLastTail.y
        
        var newSnakeTail : CGRect = CGRectMake(snakeTail.x + xDistance, snakeTail.y + yDistance, CGFloat(self.width), CGFloat(self.width))
        self.body.append(newSnakeTail)
        
        
    }
}