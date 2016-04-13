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
    var returnAddr : SKScene?
    var gameView : GameBoardView?
    var puzzleSetName : SKLabelNode?
    var puzzleName : SKLabelNode?
    var controlPanel : SKNode?
    var huDisplay : SKNode?
    
    var audioDelegate : TD_AudioPlayer?
    
    func setPuzzle(puz: Puzzle)
    {
        // how to error check this?
        puzzleData = puz
    }
    
    override func didMoveToView(view: SKView)
    {
        self.backgroundColor = greenTileColor
        
        // some layout tools
        let gridSize = self.frame.width/12.0
        let littleButtonSize = 0.5*gridSize
        let littleButtonScale = littleButtonSize/500.0
        
        // create GameBoardView with puzzle: 5/6 of width square
        let testSize = CGSize(width: self.size.width*0.833, height: self.size.width*0.833)
        
        if puzzleData != nil
        {
            gameView = GameBoardView(puzzle: puzzleData!, boardSize: testSize, audioDel: self.audioDelegate)
            gameView!.position = CGPointMake((self.size.width/12.0), self.size.height-self.size.height*0.75)
        } else
        {
            // make a crappy default puzzle
            gameView = GameBoardView(puzzle: Puzzle(dim: 4, inPar: 2, levelString: "................", levelName: "DefaultPuzzle"), boardSize: testSize, audioDel: self.audioDelegate)
        }
        
        // hamburger button at top left
        let backButton = TDButton(defaultImageName: "PurpleMenu_def.png", selectImageName: "PurpleMenu_sel.png", buttonAction: doBackButton, disabledImageName: nil, labelStr: "")
        backButton.setScale(littleButtonScale*2.0)
        backButton.position = CGPoint(x: gridSize*1.5, y: self.frame.height - gridSize*1.5)
        
        setupSwipeControls()
        self.addChild(gameView!)
        self.addChild(backButton)
    }
    
    // swipes
    
    func swipeUp(sender:UISwipeGestureRecognizerDirection)
    {
        gameView?.startTurn(.up)
        gameView?.gameBoard?.dootTiles(.up)
        gameView?.endTurn()
    }
    
    func swipeDown(sender:UISwipeGestureRecognizerDirection)
    {
        gameView?.startTurn(.down)
        gameView?.gameBoard?.dootTiles(.down)
        gameView?.endTurn()
    }
    
    func swipeLeft(sender:UISwipeGestureRecognizerDirection)
    {
        gameView?.startTurn(.left)
        gameView?.gameBoard?.dootTiles(.left)
        gameView?.endTurn()
    }
    
    func swipeRight(sender:UISwipeGestureRecognizerDirection)
    {
        gameView?.startTurn(.right)
        gameView?.gameBoard?.dootTiles(.right)
        gameView?.endTurn()
    }
    
    func setupSwipeControls() {
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GamePlayScene.swipeUp(_:)))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizerDirection.Up
        view!.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GamePlayScene.swipeDown(_:)))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizerDirection.Down
        view!.addGestureRecognizer(downSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GamePlayScene.swipeLeft(_:)))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        view!.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GamePlayScene.swipeRight(_:)))
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
    
    func doBackButton()
    {
        audioDelegate?.playSFX(pileTap_key, typeKey: stereo_key)
        // slide from left, where we came from
        let returnTransition = SKTransition.flipHorizontalWithDuration(0.5)
        if returnAddr != nil
        {
            // we assume that the returnAddr needs no audioDelegate assigned
            scene!.view!.presentScene(returnAddr!, transition: returnTransition)
        } else {
            let mmScene = MainMenuScene(size: view!.bounds.size)
            mmScene.audioDelegate = audioDelegate
            scene!.view!.presentScene(mmScene, transition: returnTransition)
        }
    }
    
}