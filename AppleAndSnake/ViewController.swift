//
//  ViewController.swift
//  AppleAndSnake
//
//  Created by JackyWang on 10/7/14.
//  Copyright (c) 2014 JackyWang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GameViewDelegate {
    
    
    // MARK: Properties
    
    @IBOutlet var gameView: GameView!
    var snake : Snake?
    var apple : Apple?
    var timer : NSTimer?
    var score : Int?
    
    // MARK: Initializers
    
    required init(coder aDecoder: NSCoder) {
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
    
    //MARK: Game Logics
    
    func startGame () {
        score = 0
        snake = nil
        snake = Snake(length: 4, direction: .south, snakeHeadRect: CGRectMake(160, 160, 16, 16))
        apple = nil
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "timerMethod:", userInfo: nil, repeats: true)
        self.plantNewApple()
    }
    
    func timerMethod(sender:NSTimer) {
        self.snake!.move()
        self.checkSnakeStatus()
        gameView.setNeedsLayout()
        
    }
    
    func gameOver () {
        timer!.invalidate()
    }
    

    //MARK: Apple Manipulation 
    
    func plantNewApple() {
        
        apple = nil
        
        var randomX = Int(arc4random()) % Int(gameView!.frame.size.width)
        var randomY = Int(arc4random()) % Int(gameView!.frame.size.height)
        
        randomX = randomX / snake!.width * snake!.width
        randomY = randomX / snake!.width * snake!.width
        
        let appleRect = CGRectMake(CGFloat(randomX), CGFloat(randomX), CGFloat(self.snake!.width), CGFloat(self.snake!.width))
        
        for body in self.snake!.body {
            if body.origin == appleRect.origin {
                [self.plantNewApple()]
                return
            }
        }
        apple = Apple(frame: appleRect)
    }
    
    //MARK: Snake Manipulation
    
    func increaseSnakeLength () {
        if self.willNextMoveHitWallOrBody() {
            snake!.growTail()
            return
        }
        snake!.growHead()
    }
    
    //MARK: Security Check
    
    func checkSnakeStatus() {
        
        if self.didSnakeHitBody(snake!.head.origin) || self.didSnakeHitWall(snake!.head.origin) {
            self.gameOver()
            return
        }
        if (self.didSnakeHitApple()) {
            score!++
            self.increaseSnakeLength()
            self.plantNewApple()
        }
    }
    
    func didSnakeHitWall(point:CGPoint) -> Bool {
        let wallWidth = Int(gameView.frame.size.width) / snake!.width * snake!.width
        let wallHeight = Int(gameView.frame.size.height) / snake!.width * snake!.width
        return point.x >= CGFloat(wallWidth) || point.x < 0 || point.y >= CGFloat(wallHeight) || point.y < 0
    }
    
    func didSnakeHitBody(point:CGPoint) -> Bool {
        for body in snake!.body[1..<snake!.length] {
            if body.origin == point {
                return true
            }
        }
        return false
    }
    
    func didSnakeHitApple() -> Bool {
        return snake!.head.origin == apple!.frame.origin
    }
    
    func willNextMoveHitWallOrBody() -> Bool {
        
        let snakeHeadPoint = snake!.head.origin
        var snakeNextHeadPoint : CGPoint?
        
        switch snake!.currentDirection {
        case .north:
            snakeNextHeadPoint = CGPointMake(snakeHeadPoint.x, snakeHeadPoint.y - CGFloat(snake!.width))
        case .south:
            snakeNextHeadPoint = CGPointMake(snakeHeadPoint.x, snakeHeadPoint.y + CGFloat(snake!.width))
        case .east:
            snakeNextHeadPoint = CGPointMake(snakeHeadPoint.x + CGFloat(snake!.width), snakeHeadPoint.y)
        case .west:
            snakeNextHeadPoint = CGPointMake(snakeHeadPoint.x - CGFloat(snake!.width), snakeHeadPoint.y)
        }
        return self.didSnakeHitBody(snakeNextHeadPoint!) || self.didSnakeHitWall(snakeNextHeadPoint!)
    }
    
    // MARK: Swipe Gesture
    
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

