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
    init(puzzle: Puzzle, boardSize: CGSize)
    {
        self.size = boardSize
        self.dimension = puzzle.dimension
        tiles = SpriteBoard(dim: dimension)
        gridPath = CGPathCreateMutable()
        moves = []
        moves.append(Turn(dir: .none))
        
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
        let fadeInSeq = SKAction.sequence([waitAction, fadeInAction])
        
        if audioDelegate == nil { print("nil audioDelegate") }
        
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
                    audioDelegate?.playSFX(singleTap_key, typeKey: mono_key)
                    tiles[tileAdd.target!.x, tileAdd.target!.y] = tempTile
                }
            }
        }
    }
    
    func startTurn(dir: MoveDirection)
    {
        // TODO: Create a new Turn object for a new swipe, do anything else to get ready for a turn cycle
        moves.append(Turn(dir: dir))
    }
    
    func endTurn()
    {
        // TODO: Scan enqueued actions to create animations for:
        // Moves
        
//      // convert grid location to node space
//        let toPos = locationForCoord(toLoc)
//        
//        // create an animation/action for the sprite
//        let moveAction = SKAction.moveTo(toPos, duration: 0.25)
//        let tileSprite = tiles[fromLoc.x, fromLoc.y]
//        tileSprite.runAction(moveAction)
//        
//        // also change the grid position
//        tiles[toLoc.x, toLoc.y] = tileSprite
        
        // Group Deletes
        
        // Repeat if necessito
        // update scoring
        // archive the Turn, do any cleanup that is needed
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
        
        if moves.last != nil
        {
            moves.last!!.appendAction(tileAction)
        }
        
    }
    
    func deleteTile(loc: Coordinate, group: Int)
    {
        // create the action/animation for deletion
        //let delAction = createDeleteAction()
        //let delSprite = tiles[loc.x, loc.y]
        //delSprite.runAction(delAction)
        print("Deleted tile with Parent tileID: \(group)")
        
        // delete the TileSprite in the SpriteBoard
        //clearTile(loc)
        
        // TODO: New Version with move queuing
        let delAction = DeleteAction(loc: loc, group: group)
        
        moves.last!!.appendAction(delAction)
        
    }
    
    func createDeleteAction() -> SKAction
    {
        return SKAction.fadeOutWithDuration(0.25)
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
    
    func processMoves()
    {
        
    }
    
    func processGroups()
    {
        
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
