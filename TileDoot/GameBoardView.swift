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
    var gameBoard: GameBoard?
    var tiles = [TileSprite]()
    
    // boardSize is the size in Pixels of the UI element
    init(puzzle: Puzzle, boardSize: CGSize)
    {
        self.size = boardSize
        
        // process the Puzzle and create the TileSprites for the view
        // init the gameboard object
        
        
        super.init()
        self.gameBoard = GameBoard(initDimension: puzzle.dimension, delegate: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // the GameBoardProtocol
    func addTile(loc: Coordinate) {
        
    }
    
    func deleteTile(loc: Coordinate) {
        
    }
    
    func setColor(loc: Coordinate, color: Color) {
        
    }
    
    func setTileType(loc: Coordinate, newType: TileType) {
        
    }
    
    func moveTile(fromLoc: Coordinate, toLoc: Coordinate) {
        
    }
    
}
