//
//  ViewController.swift
//  AppleAndSnake
//
//  Created by JackyWang on 10/7/14.
//  Copyright (c) 2014 JackyWang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GameViewDelegate {
    
    @IBOutlet var gameView: GameView!
    var snake : Snake
    var apple : Apple
    
    required init(coder aDecoder: NSCoder) {
        snake = Snake(length: 4, direction: .east, snakeHeadRect: CGRectMake(100, 100, 16, 16))
        apple = Apple(frame: CGRectMake(100, 300, CGFloat(snake.width), CGFloat(snake.width)))
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gameView.delegate = self
        gameView.backgroundColor = UIColor.blackColor()
        gameView.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Delegate
    
    func snakeForGameView(gameView: GameView) -> Snake {
        return self.snake
    }
    
    func appleForGameView(gameView: GameView) -> Apple {
        return self.apple
    }
    
}

