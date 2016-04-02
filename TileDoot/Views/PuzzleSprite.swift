//
//  PuzzleSprite.swift
//  TileDoot
//
//  Created by Garry Kling on 4/2/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation
import SpriteKit

enum PuzzleStatus : Int{
    case unsolved = 0
    case solved, parMet
}

class PuzzleSprite : SKSpriteNode
{
    var puzzleNum = 0
    var status = PuzzleStatus.unsolved
    
    // shapes
    var puzzleSquare = SKShapeNode()
    var progressIndicator = SKShapeNode()
    
}

class PuzzleGrid {
    var dimension: Int = 0
    var board = [PuzzleSprite]()
    
    init(dim: Int) {
        let nullPuzzle = PuzzleSprite()
        self.dimension = dim
        self.board = [PuzzleSprite](count:dim*dim, repeatedValue:nullPuzzle)
    }
    
    subscript(row: Int, col: Int) -> PuzzleSprite {
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
    
    func setAll(item: PuzzleSprite) {
        for i in 0..<dimension {
            for j in 0..<dimension {
                self[i, j] = item
            }
        }
    }
}

