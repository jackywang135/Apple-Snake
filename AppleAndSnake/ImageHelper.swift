//
//  ImageHelper.swift
//  AppleAndSnake
//
//  Created by Jacky Wang on 12/15/14.
//  Copyright (c) 2014 JackyWang. All rights reserved.
//

import Foundation
import UIKit

class ImageHelper {
    
    var snakeHeadImage : UIImage?
    var snakeBodyImage : UIImage?
    
    init() {
        snakeHeadImage = UIImage(named: "SnakeHead")
        snakeBodyImage = UIImage(named: "SnakeBody")
    }
    
    func getSnakeHeadImage() -> UIImage {
        return snakeHeadImage!
    }
    
    func getSnakeBodyImage() -> UIImage {
        return snakeBodyImage!
    }
    
}