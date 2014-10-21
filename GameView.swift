//
//  GameView.swift
//  AppleAndSnake
//
//  Created by JackyWang on 10/21/14.
//  Copyright (c) 2014 JackyWang. All rights reserved.
//

import Foundation
import UIKit



protocol GameViewDelegate {
    
    func snakeForGameView(gameView: GameView) -> Snake
    func appleForGameView(gameView: GameView) -> Apple
}

class GameView : UIView {

    var delegate : GameViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        
        //Get Snake
        var snake = delegate!.snakeForGameView(self)
        var apple = delegate!.appleForGameView(self)
        
        //Snake Head
        let snakeHeadImage = UIImage(named: "SnakeHead.png")
        var snakeHeadImageView = UIImageView(frame: snake.head)
        snakeHeadImageView.image = snakeHeadImage
            //Snake Head Direction
        switch snake.currentDirection {
        case .north:
            break;
        case .south:
            snakeHeadImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        case .east:
            snakeHeadImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
        case .west:
            snakeHeadImageView.transform = CGAffineTransformMakeRotation(CGFloat(3*M_PI/4))
        }
        self.addSubview(snakeHeadImageView)
        
        //Snake Body
        let snakeBodyImage = UIImage(named: "SnakeBody.png")
        for snakeBody in snake.body[1..<snake.length] {
            var snakeBodyImageView = UIImageView(frame: snakeBody)
            snakeBodyImageView.image = snakeBodyImage
            self.addSubview(snakeBodyImageView)
        }
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            
//            
//            })
        
//        for snakeBody in snake.body[1..<snake.length] {
//            let str : NSString = "🐍"
//            str.drawAtPoint(snakeBody.origin, withAttributes: [NSFontAttributeName : UIFont.systemFontOfSize(CGFloat(snake.width))])
//        }
        
        //Apple 
        let appleLabel = UILabel(frame: CGRectMake(apple.frame.origin.x, apple.frame.origin.y, apple.frame.size.width + CGFloat(10), apple.frame.size.height + CGFloat(10))) //+10 frame size to avoid image being cut off
        appleLabel.attributedText = NSAttributedString.init(string: "🍎")
        self.addSubview(appleLabel)
        
        
        


    }
    
    override func willRemoveSubview(subview: UIView) {
        
    }
}
