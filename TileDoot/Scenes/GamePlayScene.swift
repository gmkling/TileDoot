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
    var puzzles : PuzzleSet
    //var curPuz : Puzzle
    //var curPuzID : String
    weak var delegateController : GamePlaySceneViewController?
    var returnAddr : SKScene?
    var gameView : GameBoardView
    var puzzleSetName = UILabel() //fontNamed: "futura-medium")
    var puzzleName = UILabel() //fontNamed: "futura-medium")
    var controlPanel = SKNode()
    var trackingSurrogate = UIView()
    var backButton = UIButton()
    
    // HUD
    var HUD : HUDView
    
    // turn tracking
    var curTurn = 0
    var curSubturn = 1
    var beginTime : NSTimeInterval = 0.0
    var lastTime : NSTimeInterval = 0.0
    var thisTime : NSTimeInterval = 0.0
    
    weak var audioDelegate : TD_AudioPlayer?
    
    init(size: CGSize, puzSet: PuzzleSet, puzID: String)
    {
        self.puzzles = puzSet
        puzzleData = puzSet.getPuzzleWithID(puzID)!
        gameView = GameBoardView(puzzle: puzzleData, boardSize: size, audioDel: self.audioDelegate, game: nil)
        HUD = HUDView(size: CGSizeMake(size.width, size.height*0.1))
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
    
    func setCurPuzzle(puzID: String)
    {
        
    }
    
    override func didMoveToView(view: SKView)
    {
        self.backgroundColor = greenTileColor
        // some layout tools
        
        // TODO: *0.5 then *2.0 on button size??
        let gridSize = self.frame.width/12.0
        let littleButtonSize = gridSize
        let littleButtonScale = littleButtonSize/500.0
        
        // create GameBoardView with puzzle: 5/6 of width square
        let testSize = CGSize(width: self.size.width*0.833, height: self.size.width*0.833)
        
        // get the gameView squared away
        gameView = GameBoardView(puzzle: puzzleData, boardSize: testSize, audioDel: self.audioDelegate, game: self)
        //gameView.position = CGPointMake((self.size.width/12.0), self.size.height-self.size.height*0.75)
        let gameViewPos = CGPointMake((self.size.width/12.0), (self.size.height-self.size.width*0.833)/2.0)
        gameView.position = gameViewPos
        
        // let trackingPos = convertPointToView(gameViewPos)
        let trackingPos = gameViewPos
        // make the tracking frame slightly larger to allow for swipes to start/finish on the margin
        trackingSurrogate.frame = CGRectMake(trackingPos.x, trackingPos.y, testSize.width*1.1, testSize.height*1.1)
        
        // hamburger button at top left
        backButton = UIButton(type: .System)
        backButton.addTarget(self, action: #selector(doMenuButton), forControlEvents: .TouchUpInside)
        backButton.backgroundColor = purpleTileColor.colorWithAlphaComponent(1.0)
        let defImg = UIImage(named: "PuzzleMenu_def.png")
        backButton.setBackgroundImage(defImg?.resizableImageWithCapInsets(UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0), resizingMode: .Stretch), forState: .Normal)
        let selImg = UIImage(named: "PuzzleMenu_sel.png")
        backButton.setBackgroundImage(selImg?.resizableImageWithCapInsets(UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0), resizingMode: .Stretch), forState: .Selected)
        
        backButton.contentHorizontalAlignment = .Center
        backButton.contentVerticalAlignment = .Center
        backButton.tintColor = UIColor.clearColor()
        // create the frame for the back button, in SK coords it is TLeft(0,0), UI is BLeft(0, 0)
        backButton.frame = CGRectMake(gameViewPos.x, gridSize*1.5, littleButtonSize*1.667, littleButtonSize)
        
        // Label
        puzzleSetName.text = puzzles.name
        puzzleName.text = puzzleData.puzzleID
        
        puzzleSetName.font = UIFont(name: "futura-medium", size: 16.0)
        puzzleSetName.frame = CGRectMake(size.width*0.25, gridSize*1.5, littleButtonSize*1.667, littleButtonSize)
        puzzleSetName.textAlignment = .Center
        puzzleSetName.numberOfLines = 1
        puzzleSetName.adjustsFontSizeToFitWidth = true
        puzzleSetName.textColor = UIColor.whiteColor()
        
        puzzleName.font = UIFont(name: "futura-medium", size: 16.0)
        puzzleName.frame = CGRectMake(size.width*0.75, gridSize*1.5, littleButtonSize*1.667, littleButtonSize)
        puzzleName.textAlignment = .Center
        puzzleName.numberOfLines = 1
        puzzleName.adjustsFontSizeToFitWidth = true
        puzzleName.textColor = UIColor.whiteColor()
        
        self.view?.addSubview(backButton)
        self.view?.addSubview(puzzleName)
        self.view?.addSubview(puzzleSetName)
        self.view?.addSubview(trackingSurrogate)
        addLayoutConstraints()
        
        // HUD
        HUD.setTiles(gameView.gameBoard!.nGameTiles)
        HUD.setPuzPar(gameView.puzzleObj.par)
        HUD.position = CGPointMake(0.0, 0.0)
        addChild(HUD)
        
        setupSwipeControls()
        self.addChild(gameView)
        
        
    }
    
    // add constraints
    
    func addLayoutConstraints()
    {
        // the layout for backButton, puzzleName, and puzzleSetName
        // aligned below top guide, backButton aligned with gameView left
        
        let backButtonLeftAlign = NSLayoutConstraint(item: backButton, attribute: .Leading, relatedBy: .Equal, toItem: trackingSurrogate, attribute: .Leading, multiplier: 1.0, constant: 0.0)
        view?.addConstraint(backButtonLeftAlign)
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
        trackingSurrogate.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GamePlayScene.swipeDown(_:)))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizerDirection.Down
        trackingSurrogate.addGestureRecognizer(downSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GamePlayScene.swipeLeft(_:)))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        trackingSurrogate.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(GamePlayScene.swipeRight(_:)))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        trackingSurrogate.addGestureRecognizer(rightSwipe)
    }
    
    override func update(currentTime: NSTimeInterval)
    {
        // bug out if there are no turns or curTurn is out of range
        if gameView.moves.count < 1 { return }
        if curTurn >= gameView.moves.count { return }
        
        let theTurn = gameView.moves[curTurn]
        
        // get the first subturn of the curTurn, if the curTurn is still incomplete
        if !theTurn.complete
        {
            // if the turn is done, mark it and go around the horn.
            if theTurn.scanComplete() { curTurn += 1; curSubturn=1; return }
            
            if curSubturn > theTurn.subTurns + 1 { return }

            if let subturnArray = gameView.moves[curTurn].getSubturn(curSubturn)
            {
                var subturnProcessFlag = false
                var subturnIncompleteFlag = false
                
                // if any task needs processed, set the flag
                for each in subturnArray
                {
                    if !each.processed { subturnProcessFlag = true }
                }
                
                if subturnProcessFlag
                {
                    // mark them as processed
                    for action in subturnArray
                    {
                        // check in Turn.getSubturn, EndTurn and EndPuzzle only ever occur after the prev subturn
                        // so they can be processed with impugnity
                        if action is EndTurnMark
                        {
                            action.markProcessed()
                            action.markComplete()
                        } else if action is EndPuzzleMark
                        {
                            action.markProcessed()
                            action.markComplete()
                            
                            // run the victory screen, reinit the gameView with next Puzzle on button push
                            // victory button should signal nextPuzzle()
                            // fade the HUD while victory runs, fade it back in
                            let fadeOutHUD = SKAction.fadeOutWithDuration(0.5)
                            
                            HUD.runAction(fadeOutHUD)
                            gameView.runAction(SKAction.runBlock({self.gameView.runVictory()}))
                        }
                        
                        let nextAction = convertActionToSKAction(action)
                        gameView.runAction(nextAction)
                        action.markProcessed()
                    }
                } else {
                    for each in subturnArray
                    {
                        // don't mark if the incomplete action is the marker
                        if each is SubturnMark { continue }
                        if !each.complete { subturnIncompleteFlag = true }
                    }
                    
                    if subturnIncompleteFlag { return } // wait for completion
                    else {
                        // Mark subturn (array.last) as complete, move on to the next
                        self.curSubturn += 1;
                        subturnArray.last!.markComplete()
                    }
                }
            }
        }

        // dispatch any additional actions to additional views as needed
        // update scoring data in HUD
 
    }
    
    // the idea is to process this centrally so that it is easy to adjust
    func convertActionToSKAction(action: SequencedAction) -> SKAction
    {
        // some actions are meaningless outside the context of the Turn/Render cycle, so we have to do the conversion here.
        // I don't like the dependency, but I don't know how to do this conversion within the SequencedAction subtree
        // maybe this will evolve towards that.
        
        // Actions should do what they specify PLUS update their original SequencedActions with .markComplete()
        // Their complete flags are test by update() before processing new actions/the next subTurn
        // All actions should be packaged so that they can be run by the scene or the gameView, even if they run on sprites
        // eg SKAction.runBlock({ someTile.runAction(someOtherAction, completion: { someOtherActionEvent.markAsComplete } )
        
        // would look better as a switch case, but I am using type, and you can't switch on type
        let action_noop = SKAction.runBlock({})
        
        if action is SubturnMark
        {
            // taken care of in update()
            return action_noop
        }
        
        if action is EndTurnMark
        {
            // taken care of in update()
            HUD.addMove()
            return action_noop
        }
        
        if action is EndPuzzleMark
        {
            // TODO: ???
            // return SKAction.runBlock({ self.audioDelegate?.playSFX(<#T##sfxKey: String##String#>, typeKey: <#T##String#>))
            
            // taken care of in update() for now, could run a block instead
            return action_noop
        }
        
        if action is AddAction
        {
            // cast the action
            let tileAdd = action as! AddAction
            
            // TODO: fancy Tile adding animation instead of this
            let fadeInAction = SKAction.fadeInWithDuration(0.1)
            let waitAction = SKAction.waitForDuration(0.5, withRange: 0.25)
            let audioAction = SKAction.runBlock({self.audioDelegate?.playSFX(singleTap_key, typeKey: mono_key)})
            let finishAction = SKAction.runBlock({action.markComplete()})
            let fadeInSeq = SKAction.sequence([waitAction, fadeInAction, audioAction, finishAction])
            
            let tempTile = tileAdd.getTileSprite()
            
            // calc the scale
            let sceneSizeX = gameView.size.width
            let spriteDim = CGFloat(gameView.dimension)
            let tileSizeIn = CGFloat(kTileFileSizeInPixels) // my tiles are 500x500 pngs
            let tileRenderSize = sceneSizeX / spriteDim
            let tileScale = tileRenderSize / tileSizeIn
            
            tempTile.anchorPoint = CGPointMake(0.0, 0.0)
            tempTile.setScale(tileScale)
            tempTile.alpha = 0.0
            
            
            //gameView.addChild(tempTile)
            tempTile.enqueueAction(fadeInSeq)
            
            // will the reference hang around here so we can package and defer it?
            return SKAction.runBlock({self.gameView.addTileSprite(tileAdd.target!, tile: tempTile)})
        }
        
        if action is MoveAction
        {
            let curAction = action as! MoveAction
            // MoveAction should be moved over from GameBoardView::processMoveBlock()
            // do this for each move action in the array
            let toLoc = curAction.to
            let toPos = gameView.locationForCoord(toLoc)
            let fromLoc = curAction.target
            // create an animation/action for the sprite
            let moveAction = SKAction.moveTo(toPos, duration: 0.25)
            let tileSprite = gameView.tiles[fromLoc!.x, fromLoc!.y]
            let audioAction = SKAction.runBlock({self.audioDelegate?.playSFX(woodSlide_key, typeKey: stereo_key)})
            let finishAction = SKAction.runBlock({
                action.markComplete()
            })
            let actionBundle = SKAction.sequence([audioAction, moveAction, finishAction])
            
            let moveBlock = {
            tileSprite.enqueueAction(actionBundle)
            // also change the grid position
            self.gameView.tiles[toLoc.x, toLoc.y] = tileSprite
            tileSprite.executeActions()
            }
            
            return SKAction.runBlock(moveBlock)
        }
        
        if action is DeleteAction
        {
            // DeleteAction should be moved over from GameBoardView::processDeleteBlock()
            // create the action/animation for deletion
            let delAction = action as! DeleteAction
            let loc = delAction.target
            
            
            let deleteAudio = SKAction.runBlock({self.audioDelegate?.playSFX(pileTap_key, typeKey: mono_key)})
            let fadeAction = SKAction.fadeOutWithDuration(0.25)
            let deleteAction = SKAction.removeFromParent()
            let doneAction = SKAction.runBlock({action.markComplete(); self.HUD.addTile()})
            
            // set the deleteMark - when the move action completes it will delete.
            // somehow this bit of genius delete stationary tiles - WHY?
            let delSprite = gameView.tiles[loc!.x, loc!.y]
            delSprite.deleteMark = true

            // TODO: Add a better animation that will happen per group instead of per tile
            let deleteBundle = SKAction.sequence([fadeAction, deleteAudio, deleteAction, doneAction])
            delSprite.enqueueAction(deleteBundle)
            
            let deleteBlock = {
                delSprite.executeActions()
            }
            return SKAction.runBlock(deleteBlock)
            
        }
        
        if action is AudioAction
        {
            // AudioAction should be moved over from GameBoardView::processActions()
            return action_noop
        }
        
        print("Failed to ID action \(action)")
        return action_noop
    }
    
    func nextPuzzle()
    {
        gameView.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(1.0), SKAction.removeFromParent()]))
        
        let testSize = CGSize(width: self.size.width*0.833, height: self.size.width*0.833)
        let nextPuzNum = puzzleData.puzzleNumber+1
        
        if nextPuzNum > puzzles.nPuzzles
        {
            doMenuButton()
            return
        }
        
        puzzleData = puzzles.getPuzzle(nextPuzNum)!
        gameView = GameBoardView(puzzle: puzzleData, boardSize: testSize, audioDel: self.audioDelegate, game: self)
        gameView.position = CGPointMake((self.size.width/12.0), (self.size.height-self.size.width*0.833)/2.0)
        gameView.alpha = 0.0
        self.addChild(gameView)
        gameView.runAction(SKAction.fadeInWithDuration(1))
        let fadeInHUD = SKAction.fadeInWithDuration(0.5)
        self.HUD.runAction(fadeInHUD)
        resetScoring()
        
        // labels
        puzzleSetName.text = puzzles.name
        puzzleName.text = puzzleData.puzzleID
    }
    
    func resetPuzzle()
    {
        gameView.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(1.0), SKAction.removeFromParent()]))
        
        let testSize = CGSize(width: self.size.width*0.833, height: self.size.width*0.833)
        let nextPuzNum = puzzleData.puzzleNumber
        
        if nextPuzNum > puzzles.nPuzzles
        {
            doMenuButton()
            return
        }
        
        puzzleData = puzzles.getPuzzle(nextPuzNum)!
        gameView = GameBoardView(puzzle: puzzleData, boardSize: testSize, audioDel: self.audioDelegate, game: self)
        gameView.position = CGPointMake((self.size.width/12.0), (self.size.height-self.size.width*0.833)/2.0)
        self.addChild(gameView)
        gameView.runAction(SKAction.fadeInWithDuration(1))
        
        resetScoring()
        let fadeInHUD = SKAction.fadeInWithDuration(0.5)
        self.HUD.runAction(fadeInHUD)
        
    }
    
    func resetScoring()
    {
        // reset turn tracking
        curTurn = 0
        curSubturn = 1
        // reset HUD
        HUD.resetScore()
        HUD.setTiles(gameView.gameBoard!.nGameTiles)
        HUD.setPuzPar(gameView.puzzleObj.par)
    }
    
    
    func doMenuButton()
    {
        // TODO: Effective cleanup
        audioDelegate?.playSFX(pileTap_key, typeKey: stereo_key)
        
        if puzzleData.puzzleNumber+1 > puzzles.nPuzzles
        {
            delegateController!.returnToPuzzleSetScreen()
            return
        }
        
        if delegateController != nil
        {
            delegateController!.returnToPuzzleSelection()
        }
    }
    
}