//
//  GameView.swift
//  AppleAndSnake
//
//  Created by JackyWang on 10/21/14.
//  Copyright (c) 2014 JackyWang. All rights reserved.
//

import Foundation
import UIKit

//MARK: Protocol

protocol GameViewDelegate {
    
    func snakeForGameView(gameView: GameView) -> Snake
    func appleForGameView(gameView: GameView) -> Apple
}

class GameView : UIView {

    //MARK: Properties
    
    var delegate : GameViewDelegate?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Methods
    
    override func layoutSubviews() {
        
        //MARK: Remove all subviews
        for view in self.subviews {
            view.removeFromSuperview();
        }
        
        //MARK: Redraw subviews
        
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
            snakeHeadImageView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/2))
        }
        self.addSubview(snakeHeadImageView)

        //Snake Body
        let snakeBodyImage = UIImage(named: "SnakeBody.png")
        for snakeBody in snake.body[1..<snake.length] {
            var snakeBodyImageView = UIImageView(frame: snakeBody)
            snakeBodyImageView.image = snakeBodyImage
            self.addSubview(snakeBodyImageView)
        }
        
        //Draw Apple
        let appleLabel = UILabel(frame: CGRectMake(apple.frame.origin.x, apple.frame.origin.y, apple.frame.size.width, apple.frame.size.height))
        appleLabel.attributedText = NSAttributedString.init(string: "🍎", attributes:[NSFontAttributeName : UIFont.systemFontOfSize(CGFloat(snake.width - 4))]) //-4 to prevent apple being cut off
        self.addSubview(appleLabel)
    }
}