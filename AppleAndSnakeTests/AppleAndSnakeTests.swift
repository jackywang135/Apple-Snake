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
        var snake : Snake = Snake(length:3, direction:Direction.south, snakeHeadRect:CGRectMake(100, 100, 16, 16))
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testSnakeInitAssert () {
        var snake : Snake = Snake(length:3, direction:Direction.south, snakeHeadRect:CGRectMake(100, 100, 16, 16))
    }
    
    func testsnakeCanWithParameters() {
        var snake : Snake = Snake(length:3, direction:Direction.south, snakeHeadRect:CGRectMake(100, 100, 16, 16))
        XCTAssertNotNil(snake, "Should be able to init snake")
    }
    
    func testSnakeGetWidth(){
        var snake : Snake = Snake(length:3, direction:Direction.south, snakeHeadRect:CGRectMake(100, 100, 16, 16))
        XCTAssertEqual(16, snake.width, "Width from snake incorrect")
    }
    
    func testAccessSnakeHead() {
        var snake : Snake = Snake(length:3, direction:Direction.south, snakeHeadRect:CGRectMake(100, 100, 16, 16))
        XCTAssertEqual(snake.head, CGRectMake(100, 100, 16, 16), "Should be able to get head")
    }
    
    func testGetDirection() {
        var snake : Snake = Snake(length:3, direction:Direction.south, snakeHeadRect:CGRectMake(100, 100, 16, 16))
        XCTAssertEqual(snake.currentDirection, Direction.south, "Direction not correct")
    }

    func testSetLengthSmallerThan2() {
        var snake : Snake = Snake(length:3, direction:Direction.south, snakeHeadRect:CGRectMake(100, 100, 16, 16))
        XCTAssertEqual(snake.length, 3, "Length should be set to 3")
    }
    
    func testSnakeWidthSmallerThan8 (){
        var snake : Snake = Snake(length:3, direction:Direction.south, snakeHeadRect:CGRectMake(100, 100, 16, 16))
        XCTAssertEqual(snake.width, 16, "Width should be set to 16")
    }
    
    func testSnakeChangeInvalidDirection () {
        var snake : Snake = Snake(length:3, direction:Direction.south, snakeHeadRect:CGRectMake(100, 100, 16, 16))
        snake.changeDirection(.north)
        XCTAssertEqual(snake.currentDirection, Direction.south, "Direction did not change")
    }
    
    func testSnakeChangeValidDirection () {
        var snake : Snake = Snake(length:3, direction:Direction.south, snakeHeadRect:CGRectMake(100, 100, 16, 16))
        snake.changeDirection(.east)
        XCTAssertEqual(snake.currentDirection, Direction.east, "Direction did not change")
    }
    
    func testSnakeBodyCreateAfterInit () {
        var snake : Snake = Snake(length:3, direction:Direction.south, snakeHeadRect:CGRectMake(100, 100, 16, 16))
        XCTAssertEqual(snake.body.count, 3, "body not equal to length")
    }
    
    func testSnakeBodyInCorrectionDirection () {
        var snake : Snake = Snake(length:3, direction:Direction.north, snakeHeadRect:CGRectMake(100, 100, 16, 16))
        let snakeBody1 = snake.body[1]
        XCTAssertEqual(snakeBody1, CGRectMake(100, 116, 16, 16), "Body in wrong direction")
        
        let snakeBody3 = snake.body[2]
        XCTAssertEqual(snakeBody3, CGRectMake(100, 132, 16, 16), "Body in wrong direction")
    }
    
    func testSnakeMoveNorth() {
        var snake : Snake = Snake(length:3, direction:Direction.north, snakeHeadRect:CGRectMake(100, 100, 16, 16))
        snake.move()
        let snakeHead = snake.head
        XCTAssertEqual(snakeHead, CGRectMake(100, 84, 16, 16), "Snake didn't move")
    }
    
    func testSnakeMoveEast() {
        var snake : Snake = Snake(length:3, direction:Direction.east, snakeHeadRect:CGRectMake(100, 100, 16, 16))
        snake.move()
        let snakeHead = snake.head
        XCTAssertEqual(snakeHead, CGRectMake(116, 100, 16, 16), "Snake didn't move")
    }
    
    func testSnakeMoveLengthConsistent() {
        var snake : Snake = Snake(length:3, direction:Direction.east, snakeHeadRect:CGRectMake(100, 100, 16, 16))
        snake.move()
        snake.move()
        snake.move()
        snake.move()
        snake.move()
        snake.move()
        XCTAssertEqual(snake.body.count, 3, "Length not consistent after move")
    }
    
    func testSnakeGrowHead () {
        var snake : Snake = Snake(length:3, direction:Direction.east, snakeHeadRect:CGRectMake(100, 100, 32, 32))
        snake.growHead()
        XCTAssertEqual(snake.length, 4, "Length did not grow")
        XCTAssertEqual(snake.head.origin, CGPointMake(132, 100), "Did not grow at correct Point")
    }
    
    func testSnakeGrowTail () {
        var snake : Snake = Snake(length:3, direction:Direction.east, snakeHeadRect:CGRectMake(100, 100, 32, 32))
        snake.growHead()
        snake.growHead()
        XCTAssertEqual(snake.length, 5, "Length did not grow")
        XCTAssertEqual(snake.head.origin, CGPointMake(164, 100), "Did not grow at correct Point")
        
    }
}
