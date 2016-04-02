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
    
    
    init(inPuzzles: PuzzleSet, viewSize: CGSize)
    {
        self.size = viewSize
        
        
        self.puzzles = inPuzzles
        
        // initialize the PuzzleGrid by cycling through PuzzleSet and populating the cells relevant cells
        
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
    var dimension = 4
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


