//
//  ViewController.swift
//  AppleAndSnake
//
//  Created by JackyWang on 10/7/14.
//  Copyright (c) 2014 JackyWang. All rights reserved.
//

import UIKit
import Darwin
import GameKit

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
    
    func scoreConverter() -> Int {
        switch self {
        case Slow:
            return 1
        case Medium:
            return 2
        case Fast:
            return 3
        }
    }
}

// MARK: Frame Definitions

let snakeWidth = DeviceModel == .iPad ? CGFloat(32) : DeviceModel == .iPhone6 || DeviceModel == .iPhone6Plus ? CGFloat(18) : CGFloat(16)

let buttonHeight = screenHeight/3
let buttonWidth = screenWidth

let buttonNewGameHeight = (screenHeight - screenWidth)/2

let buttonNewGameFrame = CGRectMake(0, (screenHeight - screenWidth)/2, buttonWidth, buttonNewGameHeight)
let buttonSpeedSlowFrame = CGRectMake(0, 0, buttonWidth, buttonHeight)
let buttonSpeedMediumFrame = CGRectMake(0, screenHeight/3, buttonWidth, buttonHeight)
let buttonSpeedFastFrame = CGRectMake(0, screenHeight * 2 / 3, buttonWidth, buttonHeight)

let viewAnimateFrameTop = CGRectMake(0, -buttonHeight, buttonWidth, buttonHeight)
let viewAnimateFrameBottom = CGRectMake(0, screenHeight, buttonWidth, buttonHeight)

let labelScoreFrame = CGRectMake(0, 0, screenWidth, buttonNewGameHeight)

let snakeHeadImageViewShowFrame = CGRectMake(0, screenHeight - screenWidth, screenWidth, screenWidth)
let snakeHeadImageViewHideFrame = CGRectMake(0, screenHeight, screenWidth, screenWidth)


class ViewController: UIViewController, GameViewDelegate, GKGameCenterControllerDelegate {
    
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
    
    var snakeHeadImageView : UIImageView!
    var gameView: GameView!
    var labelScore: UILabel!

    var snake : Snake?
    var apple : Apple?
    var timer : NSTimer?
    var score : Int!
    var convertedScore : Int! {
        get {
            return score * gameSpeed.scoreConverter()
        }
    }
    
    var didGameStart : Bool!
    var gameSpeed : Speed!
    
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
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        setUpUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showButtonNewGame(viewAnimationTime){}
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK: UI Set Up
    
    func setUpUI() {
        setUpSwipeGestures()
        setUpGameView()
        setUpButtons()
        setUpLabelScore()
        setUpInitialImageVIew()
    }
    
    func setUpInitialImageVIew() {
        snakeHeadImageView = UIImageView(image: UIImage(named: "initialImage"))
        snakeHeadImageView.frame = snakeHeadImageViewShowFrame
        view.addSubview(snakeHeadImageView)
    }
    
    func setUpButtons() {
        buttonNewGame = UIButton.buttonWithType(.Custom) as UIButton
        buttonNewGame.frame = buttonNewGameFrame
        buttonNewGame.setTitle("New Game", forState: .Normal)
        buttonNewGame.addTarget(self, action: "newGameAction:", forControlEvents: .TouchUpInside)
        buttonNewGame.backgroundColor = UIColor.whiteColor()
        buttonNewGame.setTitleColor(UIColor.blackColor(), forState: .Normal)
        buttonNewGame.titleLabel!.font = UIFont(name: "HelveticaNeue", size: 50)
        view.addSubview(buttonNewGame)
        buttonNewGame.hidden = true
        
        buttonSpeedSlow = UIButton.buttonWithType(.Custom) as UIButton
        buttonSpeedSlow.frame = viewAnimateFrameTop
        buttonSpeedSlow.setTitle("Slow", forState: .Normal)
        buttonSpeedSlow.addTarget(self, action: "buttonSpeedAction:", forControlEvents: .TouchUpInside)
        buttonSpeedSlow.backgroundColor = UIColor.blackColor()
        buttonSpeedSlow.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        buttonSpeedSlow.titleLabel!.font = UIFont(name: "HelveticaNeue", size: 50)
        view.addSubview(buttonSpeedSlow)
        
        buttonSpeedMedium = UIButton.buttonWithType(.Custom) as UIButton
        buttonSpeedMedium.frame = buttonSpeedMediumFrame
        buttonSpeedMedium.setTitle("Medium", forState: .Normal)
        buttonSpeedMedium.addTarget(self, action: "buttonSpeedAction:", forControlEvents: .TouchUpInside)
        buttonSpeedMedium.backgroundColor = UIColor.whiteColor()
        buttonSpeedMedium.setTitleColor(UIColor.blackColor(), forState: .Normal)
        buttonSpeedMedium.titleLabel!.font = UIFont(name: "HelveticaNeue", size: 50)
        view.addSubview(buttonSpeedMedium)
        buttonSpeedMedium.hidden = true
        
        buttonSpeedFast = UIButton.buttonWithType(.Custom) as UIButton
        buttonSpeedFast.frame = viewAnimateFrameBottom
        buttonSpeedFast.setTitle("Fast", forState: .Normal)
        buttonSpeedFast.addTarget(self, action: "buttonSpeedAction:", forControlEvents: .TouchUpInside)
        buttonSpeedFast.backgroundColor = UIColor.blackColor()
        buttonSpeedFast.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        buttonSpeedFast.titleLabel!.font = UIFont(name: "HelveticaNeue", size: 50)
        view.addSubview(buttonSpeedFast)
    }
    
    func setUpLabelScore() {
        labelScore = UILabel(frame: viewAnimateFrameTop)
        labelScore.text = "Score : \(score)"
        labelScore.backgroundColor = UIColor.blackColor()
        labelScore.textColor = UIColor.whiteColor()
        labelScore.font = UIFont(name: "HelveticaNeue", size: 50)
        labelScore.textAlignment = NSTextAlignment.Center
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
    
    //MARK : Animations
    
    let viewAnimationTime = 0.4
    
    func animateView(duration:Double, view:UIView, newFrame:CGRect, completion:()->()) {
        UIView.animateWithDuration(viewAnimationTime, animations: {
            view.superview!.bringSubviewToFront(view)
            view.frame = newFrame }){ _ in completion()}
    }
    
    func shouldHideSnakeHead(hide:Bool, duration : Double, completion:()->()) {
        animateView(duration, view: snakeHeadImageView, newFrame: hide ? snakeHeadImageViewHideFrame : snakeHeadImageViewShowFrame){ _ in completion()}
    }
    
    func showButtonNewGame(duration: Double, completion: ()->()) {
        buttonNewGame.superview!.bringSubviewToFront(buttonNewGame)
        UIView.transitionWithView(self.buttonNewGame, duration: viewAnimationTime, options: UIViewAnimationOptions.TransitionFlipFromTop, animations: { self.buttonNewGame.hidden = false }){ _ in completion()}
    }
    
    func hideButtonNewGame(duration: Double, completion: ()->()) {
        buttonNewGame.superview!.bringSubviewToFront(buttonNewGame)
        self.buttonNewGame.hidden = true
    }
    
    func showSpeedButtons(duration:Double, completion: ()->()) {
        buttonSpeedFast.frame = buttonSpeedFastFrame
        self.buttonSpeedMedium.hidden = false
        UIView.transitionWithView(self.buttonSpeedMedium, duration: viewAnimationTime, options: UIViewAnimationOptions.TransitionFlipFromTop, animations: { self.buttonSpeedMedium.hidden = false }, completion: nil)
        animateView(viewAnimationTime, view: buttonSpeedSlow, newFrame: buttonSpeedSlowFrame){ _ in completion()}
    }
    
    func hideSpeedButtons(duration:Double, completion: ()->()) {
        animateView(viewAnimationTime, view: buttonSpeedFast, newFrame: viewAnimateFrameBottom){ _ in }
        UIView.transitionWithView(self.buttonSpeedMedium, duration: viewAnimationTime, options: UIViewAnimationOptions.TransitionFlipFromTop, animations: { self.buttonSpeedMedium.hidden = true }){ _ in }
        animateView(viewAnimationTime, view: buttonSpeedSlow, newFrame: viewAnimateFrameTop){ _ in completion()}
    }
    
    func hideLabelScore(hide: Bool, completion:()->()) {
        UIView.animateWithDuration(viewAnimationTime, animations: { self.labelScore.frame = hide ? viewAnimateFrameTop : labelScoreFrame }){ _ in completion()}
    }
    
    //MARK: Button Actions
    
    func newGameAction(sender: UIButton) {
        hideLabelScore(true){}
        shouldHideSnakeHead(true, duration: 1){}
        hideButtonNewGame(viewAnimationTime){}
        showSpeedButtons(viewAnimationTime){}
    }
    
    func buttonSpeedAction(sender: UIButton) {
        gameView.removeAllSubviews()
        hideSpeedButtons(viewAnimationTime){self.startGame(Speed(rawValue: sender.currentTitle!)!)}
    }
    
    // MARK: Game Logics
    
    func startGame (speed:Speed) {
        gameSpeed = speed
        allocSnakeAndApple()
        didGameStart = true
        score = 0
        timer = NSTimer.scheduledTimerWithTimeInterval(speed.getSeconds(), target: self, selector: "timerMethod:", userInfo: nil, repeats: true)
    }
    
    func timerMethod(sender:NSTimer) {
        self.snake!.move()
        self.checkSnakeStatus()
        gameView.setNeedsLayout()
    }
    
    func gameOver () {
        timer!.invalidate()
        didGameStart = false
        labelScore.text = "Score : \(convertedScore)"
        let reportScoreError = GameCenterManager.sharedManager.reportScore(convertedScore)
        if reportScoreError != nil {
            NSLog("Report Score Error: \(reportScoreError)")
        }
        hideLabelScore(false){}
        shouldHideSnakeHead(false, duration:1){self.showButtonNewGame(self.viewAnimationTime){ GameCenterManager.sharedManager.showLeaderboard(self)}}
    }
    
    func allocSnakeAndApple() {
        snake = nil
        snake = Snake(length: 4, direction: .south, snakeHeadRect: CGRectMake(snakeWidth * 10, snakeWidth * 10, snakeWidth, snakeWidth))
        self.plantNewApple()
    }
    

    //MARK: Apple Manipulation 
    
    func plantNewApple() {
        
        apple = nil
        
        var randomX = Int(arc4random_uniform(UInt32(gameView!.frame.size.width - CGFloat(snake!.width))))
        var randomY = Int(arc4random_uniform(UInt32(gameView!.frame.size.height - CGFloat(snake!.width))))
        
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
        
        func roundToNearestInt(CGF : CGFloat) -> Int {
            let roundedInt = (CGF - CGFloat(Int(CGF)) < CGFloat(0.5)) ? Int(CGF) : Int(CGF + CGFloat(0.5))
            return roundedInt
        }
        
        let wallWidth = CGFloat(roundToNearestInt(screenWidth / snakeWidth)) * snakeWidth
        let wallHeight = CGFloat(roundToNearestInt(screenHeight / snakeWidth)) * snakeWidth
        return point.x >= wallWidth || point.x < 0 || point.y >= wallHeight || point.y < 0
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
    
    //MARK: GameCenter ViewController Delegate 
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, nil)
    }
}

