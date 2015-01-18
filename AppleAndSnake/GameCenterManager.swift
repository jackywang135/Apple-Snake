//
//  GameCenterManager.swift
//  AppleAndSnake
//
//  Created by Jacky Wang on 1/17/15.
//  Copyright (c) 2015 JackyWang. All rights reserved.
//

import Foundation
import GameKit

class GameCenterManager {
    
    var leaderBoard : String = ""
    var activated = false
    
    class var sharedManager : GameCenterManager {
        struct singleton {
            static let instance = GameCenterManager()
        }
        return singleton.instance
    }
    
    func authenticatePlayer(vc:ViewController) -> NSError? {
        var authenticationError : NSError?
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = { gameCenterVC, error in
            if gameCenterVC != nil {
                vc.presentViewController(gameCenterVC!, animated: true, nil)
            } else if localPlayer.authenticated == true {
                self.activated = true
                localPlayer.loadDefaultLeaderboardIdentifierWithCompletionHandler(){ leaderBoardIdentifier, error in
                    self.leaderBoard = leaderBoardIdentifier
                    authenticationError = error
                }
            }
            authenticationError = error
        }
        return nil
    }
    
    func reportScore(score: Int) -> NSError? {
        var gkScore = GKScore(leaderboardIdentifier: leaderBoard)
        gkScore.value = Int64(score)
        var scoreReportError : NSError?
        GKScore.reportScores([gkScore]) { error in
            if error != nil {
                scoreReportError = error
            }
        }
        return scoreReportError
    }
    
    func showLeaderboard(vc:ViewController) {
        if !activated {
            return
        }
        let gcViewController = GKGameCenterViewController()
        gcViewController.gameCenterDelegate = vc
        gcViewController.viewState = GKGameCenterViewControllerState.Leaderboards
        gcViewController.leaderboardIdentifier = leaderBoard
        vc.presentViewController(gcViewController, animated: true, completion: nil)
    }
}