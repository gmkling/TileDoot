//
//  TestGameBoardViewScene.swift
//  TileDoot
//
//  Created by Garry Kling on 3/17/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import SpriteKit

class TestGameBoardView: SKScene {
    
    
    override func didMoveToView(view: SKView)
    {
        let testDim = 4
        var testString =    "BBBB"
        testString +=       "RRRR"
        testString +=       "GGGG"
        testString +=       "PPPP"

        // create a Puzzle
        let testPuz = Puzzle(dim: 4, inPar: 2, levelString: testString, levelName: "TESTMTHFKA")
        
        // create GameBoardView with puzzle
        let testSize = CGSize(width: self.size.width/2.0, height: self.size.width/2.0)
        
        let gameView = GameBoardView(puzzle: testPuz, boardSize: testSize)
        // make it go
        gameView.position = CGPointMake((self.size.width/4.0), (self.size.height/2.0)-self.size.width/4.0)
        self.addChild(gameView)
    
    }
    
    func printStart()
    {
        print("Start Button pushed.")
    }
    
    // touch overrides may not be needed since we are only interested in buttons.
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        
        for touch in touches
        {
            let location = touch.locationInNode(self)
            // interesting stuff goes here
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
    }
}