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

let screenHeight = UIScreen.mainScreen().bounds.height
let screenWidth = UIScreen.mainScreen().bounds.width

let buttonHeight = screenHeight/3
let buttonWidth = screenWidth
let buttonNewGameFrame = CGRectMake(0, screenHeight/3, buttonWidth, buttonHeight)
let buttonSpeedSlowFrame = CGRectMake(0, 0, buttonWidth, buttonHeight)
let buttonSpeedMediumFrame = CGRectMake(0, screenHeight/3, buttonWidth, buttonHeight)
let buttonSpeedFastFrame = CGRectMake(0, screenHeight * 2 / 3, buttonWidth, buttonHeight)

let viewAnimateStartFrame = CGRectMake(0, -buttonHeight, buttonWidth, buttonHeight)
let viewAnimateEndFrame = CGRectMake(0, screenHeight, buttonWidth, buttonHeight)

let labelScoreFrame = buttonSpeedSlowFrame


class ViewController: UIViewController, GameViewDelegate {
    
    // MARK: Properties
    var buttonNewGame: UIButton!
    var buttonSpeedSlow: UIButton!
    var buttonSpeedMedium: UIButton!
    var buttonSpeedFast: UIButton!
    var buttonSpeed : [UIButton]! {
        get {
            return [buttonSpeedSlow, buttonSpeedMedium, buttonSpeedFast]
        }
    }
    
    var gameView: GameView!
    var labelScore: UILabel!

    var snake : Snake?
    var apple : Apple?
    var timer : NSTimer?
    var score : Int!
    var didGameStart : Bool!
    
    var swipeGestureUp : UISwipeGestureRecognizer!
    var swipeGestureDown : UISwipeGestureRecognizer!
    var swipeGestureLeft : UISwipeGestureRecognizer!
    var swipeGestureRight : UISwipeGestureRecognizer!
    
    // MARK: Initializers
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didGameStart = false
    }
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        showButtonNewGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        setUpGameView()
        setUpButtons()
        setUpSwipeGestures()
        setUpLabelScore()
        
    }
    
    func setUpButtons() {
        buttonNewGame = UIButton.buttonWithType(.Custom) as UIButton
        buttonNewGame.frame = viewAnimateStartFrame
        buttonNewGame.setTitle("New Game", forState: .Normal)
        buttonNewGame.addTarget(self, action: "newGameAction:", forControlEvents: .TouchUpInside)
        buttonNewGame.backgroundColor = UIColor.whiteColor()
        buttonNewGame.setTitleColor(UIColor.blackColor(), forState: .Normal)
        buttonNewGame.titleLabel!.font = UIFont(name: "HelveticaNeue", size: 50)
        view.addSubview(buttonNewGame)
        
        buttonSpeedSlow = UIButton.buttonWithType(.Custom) as UIButton
        buttonSpeedSlow.frame = viewAnimateStartFrame
        buttonSpeedSlow.setTitle("Slow", forState: .Normal)
        buttonSpeedSlow.addTarget(self, action: "buttonSpeedAction:", forControlEvents: .TouchUpInside)
        buttonSpeedSlow.backgroundColor = UIColor.whiteColor()
        buttonSpeedSlow.setTitleColor(UIColor.blackColor(), forState: .Normal)
        buttonSpeedSlow.titleLabel!.font = UIFont(name: "HelveticaNeue", size: 50)
        view.addSubview(buttonSpeedSlow)
        
        buttonSpeedMedium = UIButton.buttonWithType(.Custom) as UIButton
        buttonSpeedMedium.frame = viewAnimateStartFrame
        buttonSpeedMedium.setTitle("Medium", forState: .Normal)
        buttonSpeedMedium.addTarget(self, action: "buttonSpeedAction:", forControlEvents: .TouchUpInside)
        buttonSpeedMedium.backgroundColor = UIColor.blackColor()
        buttonSpeedMedium.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        buttonSpeedMedium.titleLabel!.font = UIFont(name: "HelveticaNeue", size: 50)
        view.addSubview(buttonSpeedMedium)
        
        buttonSpeedFast = UIButton.buttonWithType(.Custom) as UIButton
        buttonSpeedFast.frame = viewAnimateStartFrame
        buttonSpeedFast.setTitle("Fast", forState: .Normal)
        buttonSpeedFast.addTarget(self, action: "buttonSpeedAction:", forControlEvents: .TouchUpInside)
        buttonSpeedFast.backgroundColor = UIColor.whiteColor()
        buttonSpeedFast.setTitleColor(UIColor.blackColor(), forState: .Normal)
        buttonSpeedFast.titleLabel!.font = UIFont(name: "HelveticaNeue", size: 50)
        view.addSubview(buttonSpeedFast)
        
    }
    
    func setUpLabelScore() {
        labelScore = UILabel(frame: viewAnimateStartFrame)
        labelScore.text = "Score : \(score)"
        labelScore.backgroundColor = UIColor.blackColor()
        labelScore.textColor = UIColor.whiteColor()
        labelScore.font = UIFont(name: "HelveticaNeue", size: 50)
        view.addSubview(labelScore)
        
    }
    
    func setUpGameView() {
        gameView = GameView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        gameView.delegate = self
        gameView.backgroundColor = UIColor.blackColor()
        view.addSubview(gameView)
    }

    func setUpSwipeGestures() {
        swipeGestureDown = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeGestureDown.direction = .Down
        swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeGestureLeft.direction = .Left
        swipeGestureUp = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeGestureUp.direction = .Up
        swipeGestureRight = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeGestureRight.direction = .Right
        
        view.addGestureRecognizer(swipeGestureDown)
        view.addGestureRecognizer(swipeGestureLeft)
        view.addGestureRecognizer(swipeGestureRight)
        view.addGestureRecognizer(swipeGestureUp)
    }
    
    // MARK: Buttons Actions
    
    func newGameAction(sender: UIButton) {
        animateView(labelScore, newFrame: viewAnimateStartFrame, completion: {
            self.showButtonSpeeds()        })
    }
    
    func buttonSpeedAction(sender: UIButton) {
        animateView(buttonSpeedSlow, newFrame: viewAnimateEndFrame, completion: {
            self.animateView(self.buttonSpeedMedium, newFrame: viewAnimateEndFrame, completion: {
                self.animateView(self.buttonSpeedFast, newFrame: viewAnimateEndFrame, completion: {
                    self.startGame(Speed(rawValue:sender.titleLabel!.text!)!)
                    
                })
            })
        })
        buttonNewGame.frame = viewAnimateStartFrame
        for view in buttonSpeed {
            view.frame = viewAnimateStartFrame
        }
    }
    
    //MARK: Animation
    let viewAnimationTime = 0.3
    
    func animateView(view:UIView, newFrame:CGRect, completion:()->()) {
        UIView.animateWithDuration(viewAnimationTime, animations: {
            view.superview!.bringSubviewToFront(view)
            view.frame = newFrame }, completion: { (complete:Bool) in
                completion()
        })
    }
    
    func showButtonNewGame() {
        animateView(buttonNewGame, newFrame: buttonNewGameFrame, { _ in }) //empty closure
    }
    
    func hideButtonNewGame() {
        
    }
    
    func showButtonSpeeds() {
        self.animateView(self.buttonNewGame, newFrame: viewAnimateEndFrame,completion: {
            self.animateView(self.buttonSpeedFast, newFrame: buttonSpeedFastFrame, completion: {
                self.animateView(self.buttonSpeedMedium, newFrame: buttonSpeedMediumFrame, completion: {
                    self.animateView(self.buttonSpeedSlow, newFrame: buttonSpeedSlowFrame, completion: { _ in })
                })
            })
        })
    }
    
    func hideButtonSpeeds() {
        
    }
    
    // MARK: Game Logics
    
    func startGame (speed:Speed) {
        allocSnakeAndApple()
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
        didGameStart = false
        labelScore.text = "Score : \(score)"
        animateView(labelScore, newFrame: labelScoreFrame, completion: {
            self.animateView(self.buttonNewGame, newFrame: buttonNewGameFrame, completion: { _ in })
        })
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
    
    func swipe(sender: UISwipeGestureRecognizer) {
        
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

