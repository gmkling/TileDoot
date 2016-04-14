//
//  GameBoardView.swift
//  TileDoot
//
//  Created by Garry Kling on 3/16/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation
import CoreGraphics
import SpriteKit

// this view will be a part of the gameplay scene to represent the board
// It must be the delegate of the game model since a new model is created each time a puzzle is loaded

class GameBoardView : SKNode , GameBoardProtocol
{
    var size: CGSize
    var gameBoard : GameBoard?
    var dimension : Int
    var background = SKShapeNode()
    var tiles : SpriteBoard
    var moves : [Turn?]
    
    var audioDelegate : TD_AudioPlayer?
    
    // grid
    var gridPath : CGMutablePath
    var gridLines = SKShapeNode()
    
    // boardSize is the size in Pixels of the UI element
    init(puzzle: Puzzle, boardSize: CGSize, audioDel: TD_AudioPlayer?)
    {
        self.size = boardSize
        self.dimension = puzzle.dimension
        tiles = SpriteBoard(dim: dimension)
        gridPath = CGPathCreateMutable()
        moves = []
        moves.append(Turn(dir: .none))
        if audioDel != nil
        {
            self.audioDelegate = audioDel
        }
        
        super.init()

        // TODO: animate this
        // init background
        drawBackground()
        drawGrid()
        
        // init board
        self.gameBoard = GameBoard(boardDimension: dimension, delegate: self, boardString: puzzle.reverseRows())
        
    }
    
    
    func drawBackground()
    {
        
        background = SKShapeNode.init(rectOfSize: size)
        background.fillColor = SKColor.lightGrayColor()
        background.strokeColor = SKColor.blackColor()
        background.position = self.center()
        self.addChild(background)
        
    }
    
    func drawGrid()
    {
        let theWidth = self.size.width
        let theHeight = self.size.height
        let gridSize = theWidth/CGFloat(dimension)
        
        // create the subpaths for the grid
        for num in 1..<dimension
        {
            let curX = gridSize*CGFloat(num)
            let curY = self.size.height - curX
            
            // vertical
            CGPathMoveToPoint(gridPath, nil, curX, theHeight)
            CGPathAddLineToPoint(gridPath, nil, curX, 0)
            CGPathCloseSubpath(gridPath)
            
            // horizontal
            CGPathMoveToPoint(gridPath, nil, 0, curY)
            CGPathAddLineToPoint(gridPath, nil, theWidth, curY)
            CGPathCloseSubpath(gridPath)
        }
        // turn the paths into a SKNode
        gridLines = SKShapeNode.init(path: gridPath)
        
        // set line style
        gridLines.strokeColor = SKColor.darkGrayColor()
        gridLines.lineWidth = 1.0
        gridLines.position = CGPointMake(0, 0)
        self.addChild(gridLines)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func locationForCoord(coord: Coordinate) ->CGPoint
    {
        let newX = CGFloat(coord.x) * (self.size.width/CGFloat(self.dimension))
        let newY = CGFloat(coord.y) * (self.size.height/CGFloat(self.dimension))
        return CGPoint(x: newX, y: newY)
    }
    
    func clearTile(loc: Coordinate)
    {
        // this should not effect the existing sprite's behavior, just remove the reference. 
        // may need to protect this, I don't think it's threadsafe
        
        // make the location a blank sprite
        tiles[loc.x, loc.y] = TileSprite()
    }
    
    // the GameBoardProtocol
    func startPuzzle()
    {
        // TODO: Make the start of puzzle animation be special
        // at this point all addTile actions should be in Q, waiting to look pretty
        // the moveDirection "none" is for the beginning of the level
        let fadeInAction = SKAction.fadeInWithDuration(0.1)
        let waitAction = SKAction.waitForDuration(0.5, withRange: 0.25)
        let audioAction = SKAction.runBlock({self.audioDelegate?.playSFX(singleTap_key, typeKey: mono_key)})
        let fadeInSeq = SKAction.sequence([waitAction, fadeInAction, audioAction])
        
        if self.audioDelegate == nil { print("nil audioDelegate") }
        
        if moves.last != nil && moves.last!!.move == MoveDirection.none
        {
            for t in moves.last!!.actionQ
            {
                if let tileAdd = t as? AddAction
                {
                    // TODO: fancy Tile adding animation instead of this
                    let tempTile = tileAdd.getTileSprite()
                    
                    // calc the scale
                    let sceneSizeX = self.size.width
                    let sceneSizeY = self.size.height
                    let spriteDim = CGFloat(dimension)
                    let tileSizeIn = CGFloat(500) // my tiles are 500x500 pngs
                    let tileRenderSize = sceneSizeX / spriteDim
                    let tileScale = tileRenderSize / tileSizeIn
                    
                    tempTile.anchorPoint = CGPointMake(0.0, 0.0)
                    tempTile.setScale(tileScale)
                    tempTile.alpha = 0.0
                    
                    
                    self.addChild(tempTile)
                    tempTile.runAction(fadeInSeq)
                    tiles[tileAdd.target!.x, tileAdd.target!.y] = tempTile
                }
            }
        }
    }
    
    func startTurn(dir: MoveDirection)
    {
        // TODO: Create a new Turn object for a new swipe, do anything else to get ready for a turn cycle
        moves.append(Turn(dir: dir))
        
        // can moves be disabled until endTurn() is called?
        for each in (self.scene!.view!.gestureRecognizers)!
        {
            each.enabled = false
        }
    }
    
    func endTurn()
    {
        // if the swipe did not move any tiles, disregard it
        if moves.last!!.actionQ.count == 0
        {
            // if the swipe created no actions, throw it away and return
            moves.removeLast()
            // can moves be disabled until endTurn() is called?
            for each in (self.scene!.view!.gestureRecognizers)!
            {
                each.enabled = true
            }
            return
        }
        
        // unthinkable, but
        // if moves.last!!.complete { return }
        
        processActions()
        
        for i in 0..<dimension
        {
            for j in 0..<dimension
            {
                tiles[i,j].executeActions()
            }
        }
        
        // update scoring
        // archive the Turn, do any cleanup that is needed
        
        moves.last!!.complete = true
        
        // turn gesture recognizer back on
        for each in (self.scene!.view!.gestureRecognizers)!
        {
            each.enabled = true
        }
    }
    
    func endPuzzle()
    {
        // TODO: When Victory condition is reached,
        // create the fancy winning/losing window
        // prepare to change or repeat puzzle, return to main, info, etc
    }
    
    func addTile(loc: Coordinate, tile: Tile)
    {
        // no-op if the tileType is empty
        if tile.type == TileType.emptyTile { return }
        
        // get the location for the loc
        let tilePos = locationForCoord(loc)
        let tileAction = AddAction(loc: loc, tile: tile, pos: tilePos)
        
//        if moves.last != nil
//        {
            moves.last!!.appendAction(tileAction)
 //       }
    
    }
    
    func deleteTile(loc: Coordinate, group: Int)
    {
        
        let delAction = DeleteAction(loc: loc, group: group)
        let audAction = AudioAction(loc: loc, sfxKey:catch_key, sfxType: mono_key)
        
        moves.last!!.appendAction(delAction)
        //moves.last!!.appendAction(audAction)
    }
    
    func createDeleteAction() -> SKAction
    {
        let randomRange = CGFloat(Float(arc4random())) / CGFloat(UINT32_MAX)
        let fadeAction = SKAction.fadeOutWithDuration(0.25*Double(randomRange))
        let audioAction = SKAction.runBlock({self.audioDelegate?.playSFX(pileTap_key, typeKey: mono_key)})
        let delAction = SKAction.removeFromParent()
        return SKAction.sequence([fadeAction, audioAction, delAction])
    }
    
    func setColor(loc: Coordinate, color: Color)
    {
        // this should swap out the SKTexture in the sprite node I think
    }
    
    func setTileType(loc: Coordinate, newType: TileType)
    {
        // this should also muck with the tile image/texture I think
    }
    
    func moveTile(fromLoc: Coordinate, toLoc: Coordinate)
    {
        let moveCmd = MoveAction(from: fromLoc, to: toLoc)
        
        moves.last!!.appendAction(moveCmd)
    }
    
    func processActions()
    {
        // TODO: Create additional animation overlays
        // TODO: sync sounds with actions
        
        if let actions = moves.last??.actionQ
        {
            var index = 0
            
            while index < actions.count
            {
                var curAction = actions[index]
                if curAction is MoveAction
                {
                    // gather the run of move actions into an array
                    var moveBlock = [curAction as! MoveAction]
                    index += 1
                    
                    // test the index on left so we don't overflow
                    while index < actions.count && actions[index] is MoveAction
                    {
                        moveBlock.append(actions[index]! as! MoveAction)
                        index += 1
                    }
                    processMoveBlock(moveBlock)
                } else if curAction is DeleteAction
                {
                    // gather the run of delete actions into an array
                    var deleteBlock = [curAction as! DeleteAction]
                    index+=1
                    
                    while index < actions.count && actions[index] is DeleteAction
                    {
                        deleteBlock.append(actions[index]! as! DeleteAction)
                        index += 1
                    }
                    processDeleteBlock(deleteBlock)
                } else if curAction is AudioAction
                {
                    let baseDur = 0.25
                    var audioBlock = curAction as! AudioAction
                    let audioAction = SKAction.runBlock({self.audioDelegate?.playSFX(audioBlock.keyString, typeKey: audioBlock.audioTypeKey)})
                    let delayAction = SKAction.waitForDuration(0.25*Double((self.moves.last??.subTurns)!))
                    
                    self.runAction(SKAction.sequence([delayAction, audioAction]))
                    index += 1
                } else
                {
                    // head off the infinite loop
                    index += 1
                    print("Unimplemented action type in GameBoardView::processActions()")
                }
                
            }
            
            // now we have run through the queue
        } else
        {
            // sorry, you dun goofed
            print("Error unrolling action queue")
        }
            
    }
    
        
    func processMoveBlock(moves: [MoveAction])
    {
        for curAction in moves
        {
            // do this for each move action in the array
            let toLoc = curAction.to
            let toPos = locationForCoord(toLoc)
            let fromLoc = curAction.target
            // create an animation/action for the sprite
            let moveAction = SKAction.moveTo(toPos, duration: 0.25)
            let tileSprite = tiles[fromLoc!.x, fromLoc!.y]
            tileSprite.enqueueAction(moveAction)
            
            // also change the grid position
            tiles[toLoc.x, toLoc.y] = tileSprite
        }
        audioDelegate?.playSFX(woodSlide_key, typeKey: stereo_key)
        self.moves.last??.subTurns += 1
    }
    
    func processDeleteBlock(deletes: [DeleteAction])
    {
        // TODO: make group delete animation!
        
        for curAction in deletes
        {
            // create the action/animation for deletion
            let loc = curAction.target!
            let delAction = createDeleteAction() // fade and remove from parent for now
            let delSprite = tiles[loc.x, loc.y]
            
            // if the sprite has less moves than subturns, add a pause
            if delSprite.actionQ.count == moves.last!!.subTurns
            {
                delSprite.enqueueAction(delAction)
            } else
            {
                delSprite.enqueueAction(SKAction.waitForDuration(0.25))
                delSprite.enqueueAction(delAction)
            }
            
            // print("Deleted tile with Parent tileID: \(group)")
            //
            // delete the TileSprite in the SpriteBoard
            //clearTile(loc)
        }
        
        self.moves.last??.subTurns += 1
    }
    
    func center () ->CGPoint
    {
        return CGPointMake((self.size.width/2.0), (self.size.height/2.0))
    }
    
}

class SpriteBoard {
    var dimension: Int = 0
    var board = [TileSprite]()
    
    init(dim: Int) {
        let nullTile = TileSprite()
        self.dimension = dim
        self.board = [TileSprite](count:dim*dim, repeatedValue:nullTile)
    }
    
    subscript(row: Int, col: Int) -> TileSprite {
        get {
            assert(row >= 0 && row < dimension)
            assert(col >= 0 && col < dimension)
            return board[row*dimension + col]
        }
        set {
            assert(row >= 0 && row < dimension)
            assert(col >= 0 && col < dimension)
            board[row*dimension + col] = newValue
        }
    }
    
    func setAll(item: TileSprite) {
        for i in 0..<dimension {
            for j in 0..<dimension {
                self[i, j] = item
            }
        }
    }
}
