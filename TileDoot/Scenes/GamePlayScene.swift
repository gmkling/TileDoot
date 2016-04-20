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
    
    var puzzleData : Puzzle
    var returnAddr : SKScene?
    var gameView : GameBoardView
    var puzzleSetName = SKLabelNode()
    var puzzleName = SKLabelNode()
    var controlPanel = SKNode()
    var huDisplay = SKNode()
    
    // turn tracking
    var curTurn = 0
    var curSubturn = 0
    var beginTime : NSTimeInterval = 0.0
    var lastTime : NSTimeInterval = 0.0
    var thisTime : NSTimeInterval = 0.0
    
    
    var audioDelegate : TD_AudioPlayer?
    
    override init(size: CGSize)
    {
        // make a placeholder puzzle and view until
        puzzleData = Puzzle(dim: 4, inPar: 2, levelString: "................", levelName: "DefaultPuzzle")
        gameView = GameBoardView(puzzle: self.puzzleData, boardSize: size, audioDel: self.audioDelegate, game: nil)
        
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPuzzle(puz: Puzzle)
    {
        // TODO: How can we make this method safer, what to do when a puzzle exists to dispose of it
        puzzleData = puz
    }
    
    override func didMoveToView(view: SKView)
    {
        self.backgroundColor = greenTileColor
        // some layout tools
        
        // TODO: *0.5 then *2.0 on button size??
        let gridSize = self.frame.width/12.0
        let littleButtonSize = 0.5*gridSize
        let littleButtonScale = littleButtonSize/500.0
        
        // create GameBoardView with puzzle: 5/6 of width square
        let testSize = CGSize(width: self.size.width*0.833, height: self.size.width*0.833)
        
        // get the gameView squared away
        gameView = GameBoardView(puzzle: puzzleData, boardSize: testSize, audioDel: self.audioDelegate, game: self)
        gameView.position = CGPointMake((self.size.width/12.0), self.size.height-self.size.height*0.75)
        
        
        // hamburger button at top left
        let backButton = TDButton(defaultImageName: "PurpleMenu_def.png", selectImageName: "PurpleMenu_sel.png", buttonAction: doBackButton, disabledImageName: nil, labelStr: "")
        backButton.setScale(littleButtonScale*2.0)
        backButton.position = CGPoint(x: gridSize*1.5, y: self.frame.height - gridSize*1.5)
        
        setupSwipeControls()
        self.addChild(gameView)
        self.addChild(backButton)
    }
    
    // swipes
    
    func swipeUp(sender:UISwipeGestureRecognizerDirection)
    {
        gameView.startTurn(.up)
        gameView.gameBoard?.dootTiles(.up)
        gameView.endTurn()
    }
    
    func swipeDown(sender:UISwipeGestureRecognizerDirection)
    {
        gameView.startTurn(.down)
        gameView.gameBoard?.dootTiles(.down)
        gameView.endTurn()
    }
    
    func swipeLeft(sender:UISwipeGestureRecognizerDirection)
    {
        gameView.startTurn(.left)
        gameView.gameBoard?.dootTiles(.left)
        gameView.endTurn()
    }
    
    func swipeRight(sender:UISwipeGestureRecognizerDirection)
    {
        gameView.startTurn(.right)
        gameView.gameBoard?.dootTiles(.right)
        gameView.endTurn()
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
    
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
//    {
//        
//        for touch in touches
//        {
//            let location = touch.locationInNode(self)
//        }
//    }
    
    override func update(currentTime: NSTimeInterval)
    {
        // on the first time around, init the beginTime
        if curTurn == 0 { beginTime = currentTime; }
        
        // take a look at the GamePlayView's actionQ
        // if a good Turn is there, take the number if you don't have it
        //  if there are commands waiting, see if it is a whole subturn that is not complete and update internal numbers
        //      if there is a subturn ready, see what commands are timely, package them up as actions and dispatch them
        //         also dispatch any additional actions to additional views as needed
        //         update scoring data in HUD
        
        //
        
        
    }
    
    // the idea is to process this centrally so that it is easy to adjust
    func convertAction(action: SequencedAction, turn: Turn) -> SKAction?
    {
        // some actions are meaningless outside the context of the Turn/Render cycle, so we have to do the conversion here.
        // I don't like the dependency, but I don't know how to do this conversion within the SequencedAction subtree
        // maybe this will evolve towards that.
        
        // Actions should do what they specify PLUS update their original SequencedActions with .markComplete()
        // Their complete flags are test by update() before processing new actions/the next subTurn
        
        if action is SubturnMark
        {
            // increment the subturn here
            return SKAction.runBlock({ self.curSubturn += 1; action.markComplete() })
        }
        
        if action is TileAction
        {
            // TileAction is abstract, we should not see instances, and should do nothing
            
        }
        
        if action is AddAction
        {
            // AddAction should be moved over from GameBoardView::startPuzzle()
            
        }
        
        if action is MoveAction
        {
           // MoveAction should be moved over from GameBoardView::processMoveBlock()
            
        }
        
        if action is DeleteAction
        {
            // DeleteAction should be moved over from GameBoardView::processDeleteBlock()
        }
        
        if action is AudioAction
        {
            // AudioAction should be moved over from GameBoardView::processActions()
        }
        
        return nil
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