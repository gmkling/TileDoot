//
//  GamePlayScene.swift
//  TileDoot
//
//  Created by Garry Kling on 1/28/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation
import SpriteKit

class GamePlayScene: SKScene {
    
    var puzzleData : Puzzle?
    var gameView : GameBoardView?
    
    func setPuzzle(puz: Puzzle)
    {
        // how to error check this?
        puzzleData = puz
    }
    
    override func didMoveToView(view: SKView)
    {
        // create GameBoardView with puzzle
        let testSize = CGSize(width: self.size.width/2.0, height: self.size.width/2.0)
        
        
        gameView = GameBoardView(puzzle: puzzleData!, boardSize: testSize)
        
        gameView!.position = CGPointMake((self.size.width/4.0), (self.size.height/2.0)-self.size.width/4.0)
        setupSwipeControls()
        self.addChild(gameView!)
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