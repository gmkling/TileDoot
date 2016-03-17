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
    var tiles : SpriteBoard
    
    // boardSize is the size in Pixels of the UI element
    init(puzzle: Puzzle, boardSize: CGSize)
    {
        self.size = boardSize
        self.dimension = puzzle.dimension
        tiles = SpriteBoard(dim: dimension)
        
        super.init()
        
        // init
        self.gameBoard = GameBoard(boardDimension: dimension, delegate: self, boardString: puzzle.reverseString())
        
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
    
    // the GameBoardProtocol
    func addTile(loc: Coordinate, tile: Tile)
    {
        var tileFile = ""
        // get an image for the color/type combo
        if tile.type == TileType.colorTile
        {
            tileFile = filenameForColor(tile.color)
        } else if tile.type == TileType.barrierTile
        {
            tileFile = "barrierTile.png"
        }
            // get the location for the loc
        let tilePos = locationForCoord(loc)
        let tempTile = TileSprite(imageNamed: tileFile)
        tempTile.position = tilePos
        
        self.addChild(tempTile)
        
        tiles[loc.x, loc.y] = tempTile
        
    }
    
    func deleteTile(loc: Coordinate)
    {
        // create the action/animation for deletion
        // delete the TileSprite in the SpriteBoard
        tiles[loc.x, loc.y] = TileSprite()
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
        // create an animation/action for the sprite
        // also change the grid position
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
