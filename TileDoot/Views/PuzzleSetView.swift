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
    var curPage : Float
    var audioDelegate: TD_AudioPlayer?
    var gameScene : GamePlayScene?
    
    init(inPuzzles: PuzzleSet, viewSize: CGSize)
    {
        self.size = viewSize
        let defaults = NSUserDefaults.standardUserDefaults()
        self.puzzles = inPuzzles
        
        // initialize the PuzzleGridPages by cycling through PuzzleSet and populating new pages
        nPages = Float(inPuzzles.nPuzzles)/16.0
        puzzlePages = []
        curPage = 0
        
        super.init()
        
        for i in 0...Int(nPages)
        {
            var tempPage = PuzzleSetPage(viewSize: self.size, handler: doGameScene)
            for j in 0..<16
            {
                let curPuzzle = (i*16)+j
                // check for partial page
                if curPuzzle >= puzzles.nPuzzles { break }
                
                let curX = j%4
                let curY = (j-curX)/4
                
                let tempPuzzle = inPuzzles.getPuzzle(curPuzzle)
                let prog = defaults.integerForKey((tempPuzzle?.puzzleID)!)
                
                tempPage.addPuzzle(curX, atY: curY, status: PuzzleStatus(rawValue: prog)!, pID: (tempPuzzle?.puzzleID)!)
                
            }
            tempPage.position = CGPointMake(0.0, 0.0)
            puzzlePages.append(tempPage)
        }
        
        
        //drawBackground()
        
        self.addChild(puzzlePages[Int(curPage)])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawBackground()
    {
        
        background = SKShapeNode.init(rectOfSize: size)
        background.fillColor = SKColor.lightGrayColor()
        background.strokeColor = SKColor.blackColor()
        background.position = self.center()
        background.zPosition = -1
        self.addChild(background)
    }
    
    func center () ->CGPoint
    {
        return CGPointMake((self.size.width/2.0), (self.size.height/2.0))
    }
    
    func moveLeft()
    {
        // this may work
//        if (curPage+1)>nPages { return } // don't move
//        
//        var removeMotion = SKAction.moveTo(CGPointMake(self.size.width * -1, 0.0), duration: 0.25)
//        var removeFade = SKAction.fadeOutWithDuration(0.25)
//        puzzlePages[Int(curPage)].runAction(SKAction.group([removeMotion, removeFade]))
//        puzzlePages[Int(curPage)].removeFromParent()
//        curPage += 1
        // move the page onto the screen from the Right
        
        
    }
    
    func moveRight()
    {
        
    }
    
    func doGameScene(puzID: String?)
    {
        // this smells funny to me. 
        
        // match puzID to the one in puzzles
        // create a gameplay scene with it
        if puzID != nil
        {
            var puz = puzzles.getPuzzleWithID(puzID!)
            self.gameScene = GamePlayScene(size: scene!.view!.bounds.size)
            gameScene!.setPuzzle(puz!)
            gameScene!.returnAddr = scene!
            var transition = SKTransition.flipHorizontalWithDuration(0.5)
            gameScene!.audioDelegate = audioDelegate
            self.scene?.view?.presentScene(gameScene!, transition: transition)
            return
        }
        
        // or die quietly
        print("Error creating gameScene with PuzzleID: \(puzID)")
    }
}

class PuzzleSetPage : SKNode
{
    let dimension = 4
    var size : CGSize
    // the grid will always be 4x4, if I ever want to change it, I'll come up with a better way
    var background = SKShapeNode()
    var puzzleSprites : PuzzleGrid
    let puzzleSelImg = "Red1_sel.png"
    let puzzleDefImg = "Red1_def.png"
    var buttonHandler: (String?) -> Void
    
    init(viewSize: CGSize, handler: (String?) -> Void)
    {
        self.size = viewSize
        self.puzzleSprites = PuzzleGrid(dim: dimension)
        self.buttonHandler = handler
        super.init()
        
        //drawBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPuzzle(atX: Int, atY: Int, status: PuzzleStatus, pID: String)
    {
        if atX > 3 || atY > 3
        {
            // you suck
            print("Error adding Puzzle to PuzzleSetPage at [\(atX),\(atY)]")
            return
        }
        var tempSprite = PuzzleSprite(viewSize: CGSize(width: self.size.width/4.0, height: self.size.width/4.0), defaultImageName: redFiles.randomItem(), selectImageName: puzzleSelImg, buttonAction: doPuzzleButton)
        tempSprite.setProgress(status)
        tempSprite.setPuzzleID(pID)
        tempSprite.setNumber((atX + atY*4)+1)
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
    
    // add a func to change images of buttons, etc
    
    // when a button gets pushed, route it here
    
    func doPuzzleButton(inID: String?)
    {
        if (inID != nil)
        {
            print(inID)
            buttonHandler(inID)
        }
    }
    
    func center () ->CGPoint
    {
        return CGPointMake((self.size.width/2.0), (self.size.height/2.0))
    }
    
}


