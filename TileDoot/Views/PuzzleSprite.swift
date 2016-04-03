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

class PuzzleSprite : SKNode
{
    var puzzleNum = 0
    var status = PuzzleStatus.unsolved
    var par = 0
    var size : CGSize
    
    // shapes
    var puzzleSquare = SKShapeNode()
    var progressIndicator = SKShapeNode()
    
    init(viewSize: CGSize)
    {
        self.size = viewSize
        // assume no progress
        puzzleSquare = SKShapeNode(rect: CGRect(origin: CGPoint(x: self.size.width*0.5, y: self.size.height*0.75), size: CGSize(width:self.size.width/2.0, height: self.size.height/2.0 )))
        progressIndicator = SKShapeNode(circleOfRadius: 1.0)
        progressIndicator.position = CGPoint(x: self.size.width/2.0, y: self.size.height*0.25)
        
        puzzleSquare.fillColor = yellowTileColor
        progressIndicator.fillColor = SKColor.blackColor()
        progressIndicator.strokeColor = SKColor.whiteColor()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setProgress(newStatus: PuzzleStatus)
    {
        status = newStatus
        
        if status == .unsolved
        {
            progressIndicator.fillColor = SKColor.blackColor()
            return
        }
        
        if status == .solved
        {
            progressIndicator.fillColor = SKColor.lightGrayColor()
            return
        }
        
        if status == .parMet
        {
            progressIndicator.fillColor = SKColor.whiteColor()
            return
        }
    }
    
}

class PuzzleGrid {
    var dimension: Int = 0
    var board = [PuzzleSprite]()
    
    init(dim: Int) {
        let nullPuzzle = PuzzleSprite(viewSize: CGSize(width: 0,height: 0))
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

