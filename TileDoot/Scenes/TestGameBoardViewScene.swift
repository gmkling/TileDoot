//
//  TestGameBoardViewScene.swift
//  TileDoot
//
//  Created by Garry Kling on 3/17/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import SpriteKit

class TestGameBoardView: SKScene {
    
    var gameView : GameBoardView?
    

    
    override func didMoveToView(view: SKView)
    {
        let testDim = 8
        // construct the String rep of the game board
        let puzRow8 = "BBBB****"
        let puzRow7 = "BBBB****"
        let puzRow6 = "....GGGG"
        let puzRow5 = "....GGGG"
        let puzRow4 = "...RR***"
        let puzRow3 = "...RG.OO"
        let puzRow2 = "YO...OOY"
        let puzRow1 = "GB..OOB*"
        
        //let puzzleString = puzRow1+puzRow2+puzRow3+puzRow4+puzRow5+puzRow6+puzRow7+puzRow8
        let puzzleString = puzRow8+puzRow7+puzRow6+puzRow5+puzRow4+puzRow3+puzRow2+puzRow1
        
        // create a Puzzle
        let testPuz = Puzzle(dim: testDim, inPar: 2, levelString: puzzleString, levelName: "TESTMTHFKA")
        
        // create GameBoardView with puzzle
        let testSize = CGSize(width: self.size.width/2.0, height: self.size.width/2.0)
        
        gameView = GameBoardView(puzzle: testPuz, boardSize: testSize)
        // make it go
        gameView!.position = CGPointMake((self.size.width/4.0), (self.size.height/2.0)-self.size.width/4.0)
        setupSwipeControls()
        self.addChild(gameView!)
    
    }
    
    func printStart()
    {
        print("Start Button pushed.")
    }
    
    func moveSomething()
    {
        gameView?.moveTile(Coordinate(x: 0,y: 1), toLoc: Coordinate(x: 2, y: 1))
    }
    
    // swipes
    
    func swipeUp(sender:UISwipeGestureRecognizerDirection)
    {
        gameView?.gameBoard?.dootTiles(.up)
    }
    
    func swipeDown(sender:UISwipeGestureRecognizerDirection)
    {
        gameView?.gameBoard?.dootTiles(.down)
    }
    
    func swipeLeft(sender:UISwipeGestureRecognizerDirection)
    {
        gameView?.gameBoard?.dootTiles(.left)
    }
    
    func swipeRight(sender:UISwipeGestureRecognizerDirection)
    {
        gameView?.gameBoard?.dootTiles(.right)
    }
    
    func setupSwipeControls() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("swipeUp:"))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizerDirection.Up
        view!.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("swipeDown:"))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizerDirection.Down
        view!.addGestureRecognizer(downSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("swipeLeft:"))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        view!.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("swipeRight:"))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        view!.addGestureRecognizer(rightSwipe)
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        
        for touch in touches
        {
            let location = touch.locationInNode(self)
            // interesting stuff goes here
            // self.moveSomething()
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
    }
}