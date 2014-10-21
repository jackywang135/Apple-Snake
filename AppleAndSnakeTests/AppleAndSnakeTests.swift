//
//  AppleAndSnakeTests.swift
//  AppleAndSnakeTests
//
//  Created by JackyWang on 10/7/14.
//  Copyright (c) 2014 JackyWang. All rights reserved.
//

import UIKit
import XCTest



class AppleAndSnakeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
//        snake = Snake(length:1, direction:Direction.south, snakeHeadRect:CGRectMake(100, 100, 5, 5))
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testsnakeCanWithParameters() {
        var snake : Snake = Snake(length:1, direction:Direction.south, snakeHeadRect:CGRectMake(100, 100, 5, 5))
        XCTAssertNotNil(snake, "Should be able to init snake")
    }
    
    func testSnakeGetWidth(){
        var snake : Snake = Snake(length:1, direction:Direction.south, snakeHeadRect:CGRectMake(100, 100, 5, 5))
        XCTAssertEqual(CGFloat(8), snake.width, "Width from snake incorrect")
    }
    
    func testAccessSnakeHead() {
        var snake : Snake = Snake(length:1, direction:Direction.south, snakeHeadRect:CGRectMake(100, 100, 5, 5))
        XCTAssertEqual(snake.snakeHead, CGRectMake(100, 100, 8, 8), "Should be able to get head")
    }
    
    func testGetDirection() {
        var snake : Snake = Snake(length:1, direction:Direction.south, snakeHeadRect:CGRectMake(100, 100, 5, 5))
        XCTAssertEqual(snake.currentDirection, Direction.south, "Direction not correct")
    }

    func testSetLengthSmallerThan2() {
        var snake : Snake = Snake(length:1, direction:Direction.south, snakeHeadRect:CGRectMake(100, 100, 5, 5))
        XCTAssertEqual(snake.length, 2, "Length should be set to 2")
    }
    
    func testSnakeWidthSmallerThan8 (){
        var snake : Snake = Snake(length:1, direction:Direction.south, snakeHeadRect:CGRectMake(100, 100, 5, 5))
        XCTAssertEqual(snake.width, CGFloat(8), "Width should be set to 8")
    }
}
