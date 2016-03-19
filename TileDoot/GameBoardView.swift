//
//  GameBoardView.swift
//  TileDoot
//
//  Created by Garry Kling on 3/16/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation
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
    
    // boardSize is the size in Pixels of the UI element
    init(puzzle: Puzzle, boardSize: CGSize)
    {
        self.size = boardSize
        self.dimension = puzzle.dimension
        tiles = SpriteBoard(dim: dimension)
        super.init()
        
        // init background
        drawBackground()
        
        // init board
        self.gameBoard = GameBoard(boardDimension: dimension, delegate: self, boardString: puzzle.reverseRows())
        
    }
    
    func drawBackground()
    {
        // TODO: Some work is needed to make this look good
        // ************************************************
        // determine grid size
        // set line style
        // draw lines
        
        // would rather draw grid, but just a square in back for now
        background = SKShapeNode.init(rectOfSize: size)
        background.fillColor = SKColor.grayColor()
        background.strokeColor = SKColor.blackColor()
        background.position = self.center()
        self.addChild(background)
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
    func addTile(loc: Coordinate, tile: Tile)
    {
        var tileFile = ""
        
        // swift + switch == :)
        // get an image for the color/type combo
        
        switch tile.type {
        case .colorTile:
                tileFile = filenameForColor(tile.color)
        case .barrierTile:
                tileFile = "barrierTile.png"
        case .emptyTile:
            // the rest of this is irrelevant
            return
        case .nullTile:
            return
        default:
            print("Unrecognized TileType: \(tile.type)")
        }
        
        // get the location for the loc
        let tilePos = locationForCoord(loc)
        let tempTile = TileSprite(imageNamed: tileFile)
        tempTile.position = tilePos
        
        // calc the scale
        let sceneSizeX = self.size.width
        let sceneSizeY = self.size.height
        let spriteDim = CGFloat(dimension)
        let tileSizeIn = CGFloat(500) // my tiles are 500x500 pngs
        let tileRenderSize = sceneSizeX / spriteDim
        let tileScale = tileRenderSize / tileSizeIn
        
        tempTile.anchorPoint = CGPointMake(0.0, 0.0)
        tempTile.setScale(tileScale)
            
        self.addChild(tempTile)
        
        tiles[loc.x, loc.y] = tempTile
        
    }
    
    func deleteTile(loc: Coordinate)
    {
        // create the action/animation for deletion
        let delAction = SKAction.fadeOutWithDuration(0.25)
        let delSprite = tiles[loc.x, loc.y]
        delSprite.runAction(delAction)
        
        // delete the TileSprite in the SpriteBoard
        clearTile(loc)
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
        // convert grid location to node space
        let toPos = locationForCoord(toLoc)
        // create an animation/action for the sprite
        let moveAction = SKAction.moveTo(toPos, duration: 0.25)
        
        // get the sprite, queue the action
        let tileSprite = tiles[fromLoc.x, fromLoc.y]
        tileSprite.runAction(moveAction)
        
        // also change the grid position
        tiles[toLoc.x, toLoc.y] = tileSprite
        //deleteTile(fromLoc)
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
