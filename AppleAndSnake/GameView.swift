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
    func didGameStart(gameView:GameView) -> Bool
}


class GameView : UIView {

    //MARK: Properties
    
    var delegate : GameViewDelegate?
    var imageHelper = ImageHelper()
    let kAppleLabelTag = 1
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //MARK: Methods
    
    override func layoutSubviews() {
        
        if delegate!.didGameStart(self) {
        
        //MARK: Remove all subviews
		self.subviews.filter(){ $0 is UIImageView || $0.tag == 1}.map(){$0.removeFromSuperview()}
    
        //MARK: Redraw subviews
        
        //Get Snake
        var snake = delegate!.snakeForGameView(self)
        var apple = delegate!.appleForGameView(self)
			
			
		let array = [Int]()
		array.map { $0 * 2 }
        //Snake Body
        let snakeBodyImage = imageHelper.getSnakeBodyImage()
        for snakeBody in snake.body[1..<snake.length] {
            var snakeBodyImageView = UIImageView(frame: snakeBody)
            snakeBodyImageView.image = snakeBodyImage
            self.addSubview(snakeBodyImageView)
        }
        
        //Snake Head
        let snakeHeadImage = imageHelper.getSnakeHeadImage()
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
        
        //Draw Apple
        let appleLabel = UILabel(frame: apple.frame)
        appleLabel.tag = kAppleLabelTag
        appleLabel.text = "🍎"
        appleLabel.font = UIFont.systemFontOfSize(snakeWidth - 6)
        self.addSubview(appleLabel)
        }
    }
    
    func removeAllSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}