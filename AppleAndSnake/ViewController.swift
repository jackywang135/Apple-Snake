//
//  ViewController.swift
//  AppleAndSnake
//
//  Created by JackyWang on 10/7/14.
//  Copyright (c) 2014 JackyWang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GameViewDelegate {
    
    
    // MARK: Variables
    
    @IBOutlet var gameView: GameView!
    var snake : Snake?
    var apple : Apple?
    var timer : NSTimer?
    var score : Int
    
    // MARK: Initializers
    
    required init(coder aDecoder: NSCoder) {
        
        
        score = 0
        super.init(coder: aDecoder)
    }
    
    //MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gameView.delegate = self
        gameView.backgroundColor = UIColor.blackColor()
        self.startGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startGame () {
        score = 0
        snake = nil
        snake = Snake(length: 4, direction: .south, snakeHeadRect: CGRectMake(100, 100, 16, 16))
        apple = nil
        apple = Apple(frame: CGRectMake(100, 300, CGFloat(snake!.width), CGFloat(snake!.width)))
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "timerMethod:", userInfo: nil, repeats: true)
    }
    
    func timerMethod(sender:NSTimer) {
        self.snake!.move()
        gameView.setNeedsDisplay()
    }
    
    @IBAction func swipe(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.Up:
            snake!.changeDirection(.north)
        case UISwipeGestureRecognizerDirection.Down:
            snake!.changeDirection(.south)
        case UISwipeGestureRecognizerDirection.Left:
            snake!.changeDirection(.west)
        case UISwipeGestureRecognizerDirection.Right:
            snake!.changeDirection(.east)
        default:
            return
        }
    }
    
    

    
    // MARK: Delegate
    
    func snakeForGameView(gameView: GameView) -> Snake {
        return self.snake!
    }
    
    func appleForGameView(gameView: GameView) -> Apple {
        return self.apple!
    }
    
}

