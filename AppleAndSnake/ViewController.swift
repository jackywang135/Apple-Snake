//
//  ViewController.swift
//  AppleAndSnake
//
//  Created by JackyWang on 10/7/14.
//  Copyright (c) 2014 JackyWang. All rights reserved.
//

import UIKit
import Darwin

enum Speed : String, Printable {
    case Slow = "Slow", Medium = "Medium", Fast = "Fast"
    var description : String {
        get {
            return self.rawValue
        }
    }
}

extension Speed {
    
    func getSeconds() -> Double {
        switch self {
        case Slow:
            return 0.2
        case Medium:
            return 0.1
        case Fast:
            return 0.05
        }
    }
}

class ViewController: UIViewController, GameViewDelegate {
    
    // MARK: Properties
    @IBOutlet weak var buttonNewGame: UIButton!
    @IBOutlet var buttonSpeed: [UIButton]!
    @IBOutlet var gameView: GameView!
    
    var snake : Snake?
    var apple : Apple?
    var timer : NSTimer?
    var score : Int?
    var didGameStart : Bool!
    
    // MARK: Initializers
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didGameStart = false
    }
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameView.delegate = self
        gameView.backgroundColor = UIColor.blackColor()
        setUpButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Buttons
    
   func setUpButtons() {
        buttonNewGame.titleLabel!.adjustsFontSizeToFitWidth = true
        for button in buttonSpeed {
            button.titleLabel!.adjustsFontSizeToFitWidth = true
        }
        areButtonSpeedHidden(true)
    }
    
    @IBAction func newGameAction(sender: UIButton) {
        buttonNewGame.hidden = true
        areButtonSpeedHidden(false)
    }
    
    @IBAction func buttonSpeedAction(sender: UIButton) {
        
        self.startGame(Speed(rawValue:sender.titleLabel!.text!)!)
        areButtonSpeedHidden(true)
    }
    
    func areButtonSpeedHidden(bool:Bool) {
        for button in buttonSpeed {
            button.hidden = bool
        }
    }
    
    
    // MARK: Game Logics
    
    func startGame (speed:Speed) {
        
        self.allocSnakeAndApple()
        didGameStart = true
        score = 0
        timer = NSTimer.scheduledTimerWithTimeInterval(speed.getSeconds(), target: self, selector: "timerMethod:", userInfo: nil, repeats: true)
    }
    
    func timerMethod(sender:NSTimer) {
        self.snake!.move()
        self.checkSnakeStatus()
        gameView!.setNeedsLayout()
        
    }
    
    func gameOver () {
        timer!.invalidate()
        buttonNewGame.hidden = false
        didGameStart = false
    }
    
    func allocSnakeAndApple() {
        snake = nil
        snake = Snake(length: 4, direction: .south, snakeHeadRect: CGRectMake(160, 160, 16, 16))
        self.plantNewApple()
    }
    

    //MARK: Apple Manipulation 
    
    func plantNewApple() {
        
        apple = nil
        
        var randomX = Int(arc4random_uniform(UInt32(gameView!.frame.size.width - CGFloat(snake!.width))))
        var randomY = Int(arc4random_uniform(UInt32(gameView!.frame.size.height-CGFloat(snake!.width))))
        
        randomX = randomX / snake!.width * snake!.width
        randomY = randomY / snake!.width * snake!.width
        
        let appleRect = CGRectMake(CGFloat(randomX), CGFloat(randomY), CGFloat(self.snake!.width), CGFloat(self.snake!.width))
        
        for body in self.snake!.body {
            if body.origin == appleRect.origin {
                self.plantNewApple()
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
        let wallWidth = Int(gameView!.frame.size.width) / snake!.width * snake!.width
        let wallHeight = Int(gameView!.frame.size.height) / snake!.width * snake!.width
        return point.x > CGFloat(wallWidth) || point.x < 0 || point.y > CGFloat(wallHeight) || point.y < 0
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
        
        if (didGameStart == true) {
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
    }
    

    // MARK: Delegate
    
    func snakeForGameView(gameView: GameView) -> Snake {
        return snake!
    }
    
    func appleForGameView(gameView: GameView) -> Apple {
        return apple!
    }
    
    func didGameStart(gameView:GameView) -> Bool {
        return didGameStart
    }
    
}

