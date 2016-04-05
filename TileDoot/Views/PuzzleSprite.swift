//
//  PuzzleSprite.swift
//  TileDoot
//
//  Created by Garry Kling on 4/2/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation
import SpriteKit

enum PuzzleStatus : Int
{
    case unsolved = 0
    case solved, parMet
}

class PuzzleSprite : SKNode
{
    var puzzleNum = 0
    var status = PuzzleStatus.unsolved
    var par = 0
    var size : CGSize
    var ID: String?
    
    // shapes
    var puzzleSquare = SKShapeNode()
    var progressIndicator = SKShapeNode()
    var numberLabel = SKLabelNode(fontNamed: "Futura-medium")
    
    init(viewSize: CGSize)
    {
        self.size = viewSize
        
        puzzleSquare = SKShapeNode(rectOfSize: CGSize(width:viewSize.width/2.0, height: viewSize.height/2.0), cornerRadius: 5.0)
        
        puzzleSquare.position = CGPoint(x: viewSize.width*0.5, y: viewSize.height*0.5)
        puzzleSquare.fillColor = SKColor(red: 226.0/255.0, green: 198.0/255.0, blue: 72.0/255.0, alpha: 255.0)
        puzzleSquare.strokeColor = SKColor.whiteColor()
        
        // assume no progress
        progressIndicator = SKShapeNode(circleOfRadius: self.size.width*0.05)
        progressIndicator.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.125)
        progressIndicator.fillColor = SKColor.blackColor()
        progressIndicator.strokeColor = SKColor.whiteColor()
        
        super.init()
        self.addChild(puzzleSquare)
        self.addChild(progressIndicator)
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
    
    func setNumber(num: Int)
    {
        if num < 0 { return } // get out of here with that nasty shit
        
        numberLabel.text = "\(num)"
        numberLabel.fontSize = size.height/4.0
        numberLabel.verticalAlignmentMode = .Center
        numberLabel.horizontalAlignmentMode = .Center
        numberLabel.position = CGPointMake(puzzleSquare.frame.midX, puzzleSquare.frame.midY)
        numberLabel.fontColor = UIColor.whiteColor()
        self.addChild(numberLabel)
    }
    
    func setPuzzleID(newID: String)
    {
        self.ID = newID
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

