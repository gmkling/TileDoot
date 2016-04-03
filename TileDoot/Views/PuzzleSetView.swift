//
//  PuzzleSetView.swift
//  TileDoot
//
//  Created by Garry Kling on 4/2/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation
import SpriteKit

// this is the core view of the PuzzleDirectoryScene
// loosely based on the GameBoardView as they both use a grid, but not a subclass since behavior is totally different

class PuzzleSetView: SKNode
{
    var size : CGSize
    var background = SKShapeNode()
    var puzzles : PuzzleSet
    var puzzlePages : [PuzzleSetPage]
    var nPages : Float
    
    init(inPuzzles: PuzzleSet, viewSize: CGSize)
    {
        self.size = viewSize
        
        
        self.puzzles = inPuzzles
        
        // initialize the PuzzleGridPages by cycling through PuzzleSet and populating new pages
        nPages = Float(inPuzzles.nPuzzles)/16.0
        puzzlePages = []
        
        for i in 0...Int(nPages)
        {
            var tempPage = PuzzleSetPage(viewSize: self.size)
            for j in 0..<16
            {
                tempPage.addPuzzle(i, atY: j, status: <#T##PuzzleStatus#>)
            }
            puzzlePages.append(tempPage)
        }
        super.init()
        
        drawBackground()
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawBackground()
    {
        background = SKShapeNode.init(rectOfSize: size)
        background.fillColor = SKColor.grayColor()
        background.strokeColor = SKColor.blackColor()
        background.position = self.center()
        self.addChild(background)
    }
    
    func center () ->CGPoint
    {
        return CGPointMake((self.size.width/2.0), (self.size.height/2.0))
    }
}

class PuzzleSetPage : SKNode
{
    let dimension = 4
    var size : CGSize
    // the grid will always be 4x4, if I ever want to change it, I'll come up with a better way
    var background = SKShapeNode()
    var puzzleSprites : PuzzleGrid
    
    init(viewSize: CGSize)
    {
        self.size = viewSize
        self.puzzleSprites = PuzzleGrid(dim: dimension)
        super.init()
        
        drawBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPuzzle(atX: Int, atY: Int, status: PuzzleStatus)
    {
        if atX > 3 || atY > 3
        {
            // you suck
            print("Error adding Puzzle to PuzzleSetPage at [\(atX),\(atY)]")
            return
        }
        var tempSprite = PuzzleSprite(viewSize: CGSize(width: self.size.width/4.0, height: self.size.width/4.0))
        tempSprite.setProgress(status)
        tempSprite.position = CGPointMake((self.size.width/4.0)*CGFloat(atX), self.size.height - (self.size.width/4.0)*CGFloat(atY))
        self.addChild(tempSprite)
        puzzleSprites[atX, atY] = tempSprite
    }
    
    func drawBackground()
    {
        background = SKShapeNode.init(rectOfSize: size)
        background.fillColor = SKColor.darkGrayColor()
        background.strokeColor = SKColor.blackColor()
        background.position = self.center()
        self.addChild(background)
    }
    
    func center () ->CGPoint
    {
        return CGPointMake((self.size.width/2.0), (self.size.height/2.0))
    }
    
}


