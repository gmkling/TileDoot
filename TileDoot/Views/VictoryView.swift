//
//  VictoryView.swift
//  TileDoot
//
//  Created by Garry Kling on 4/14/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation
import SpriteKit

class VictoryView : SKNode
{
    var windowSize : CGSize
    
    // elements
    var title = "Puzzle Clear"
    var victoryLabel = SKLabelNode(fontNamed: "futura-medium")
    var tiles : [SKSpriteNode]
    var scoring = SKLabelNode(fontNamed: "futura-medium")
    var background = SKShapeNode()
    weak var gamePtr: GamePlayScene?
    var dootedTiles : Int
    
    // buttons
    var tileXStart : CGFloat
    var tileXStride : CGFloat
    var tileYPos : CGFloat
    var buttonY : CGFloat
    var puzMenuButton : TDButton?
    var replayButton : TDButton?
    var contButton : TDButton?
    
    init(size: CGSize, stars: Int, moves: Int, par: Int, tilesDooted: Int, game: GamePlayScene?)
    {
        self.windowSize = size
        let fontScale = size.width/(750.0*0.833) 
        var starFile = [Color]()
        let xSize = self.windowSize.width
        let ySize = self.windowSize.height
        
        starFile = []
        tiles = []
        dootedTiles = tilesDooted
        
        // draw title
        victoryLabel.fontSize = 64.0*fontScale
        victoryLabel.position = CGPointMake(xSize*0.5, ySize*0.8)
        victoryLabel.text = title
        victoryLabel.verticalAlignmentMode = .Center
        victoryLabel.horizontalAlignmentMode = .Center
        
        // draw tiles
        
        switch stars {
        case 1:
            starFile.appendContentsOf([.kRed, .kLightGreen, .kLightGreen])
        case 2:
            starFile.appendContentsOf([.kRed, .kRed, .kLightGreen])
        case 3:
            starFile.appendContentsOf([.kRed, .kRed, .kRed])
        default:
            starFile.appendContentsOf([.kLightGreen, .kLightGreen, .kLightGreen])
        }
        
        tileXStart = xSize*0.2
        tileXStride = xSize*0.3
        tileYPos = ySize*0.55
        let gridSize = xSize/10.0
        let bigButtonSize = 2.0*gridSize
        let bigButtonScale = (bigButtonSize/500.0)
        buttonY = self.windowSize.height*0.2
        
        for i in 0...2
        {
            let tempTile = SKSpriteNode(texture: textureForColor(starFile[i]))
            tempTile.position = CGPointMake(tileXStart+tileXStride*CGFloat(i), tileYPos)
            tempTile.setScale(bigButtonScale)
            tiles.append(tempTile)
        }
        
        // draw scoring
        scoring.fontSize = 28.0*fontScale
        scoring.position = CGPointMake(xSize*0.5, ySize*0.375)
        scoring.text = "Doots: \(moves)/\(par)  TilesRemoved: \(dootedTiles)"
        scoring.verticalAlignmentMode = .Center
        scoring.horizontalAlignmentMode = .Center
        
        gamePtr = game
        
        super.init()
        
        drawBackground()
        setupButtons()

        self.addChild(victoryLabel)
        self.addChild(scoring)
        for i in 0...2 { self.addChild(tiles[i]) }
        
    }
    
    func drawBackground()
    {
        
        background = SKShapeNode.init(rectOfSize: windowSize)
        background.fillColor = SKColor.lightGrayColor()
        background.strokeColor = SKColor.blackColor()
        background.position = self.center()
        self.addChild(background)
        
    }
    
    
    func setupButtons()
    {
        
        puzMenuButton = TDButton(defaultImageName: "PurpleMenu_def.png", selectImageName: "PurpleMenu_sel.png", buttonAction: doMenuButton, disabledImageName: nil, labelStr: nil)
        replayButton = TDButton(defaultImageName: "PurpleReset_def.png", selectImageName: "PurpleReset_sel.png", buttonAction: doResetButton, disabledImageName: "PurpleReset_dis.png", labelStr: nil)
        contButton = TDButton(defaultImageName: "PurpleForward_def.png", selectImageName: "PurpleForward_sel.png", buttonAction: doForwardButton, disabledImageName: "PurpleForward_dis.png", labelStr: nil)
        
        let xSize = self.windowSize.width
        let gridSize = xSize/10.0
        let bigButtonSize = 2.0*gridSize
        let bigButtonScale = (bigButtonSize/500.0)
        
        puzMenuButton!.position = CGPointMake(tileXStart, buttonY)
        replayButton!.position = CGPointMake(tileXStart+tileXStride, buttonY)
        contButton!.position = CGPointMake(tileXStart+(tileXStride*2.0), buttonY)
        
        puzMenuButton!.setScale(bigButtonScale)
        replayButton!.setScale(bigButtonScale)
        contButton!.setScale(bigButtonScale)
        
        self.addChild(puzMenuButton!)
        self.addChild(replayButton!)
        self.addChild(contButton!)
        
    }
    
    func doMenuButton()
    {
        gamePtr?.doMenuButton()
    }
    
    func doResetButton()
    {
        gamePtr?.resetPuzzle()
    }
    
    func doForwardButton()
    {
        let fadeAction = SKAction.fadeOutWithDuration(1.0)
        let removeAction = SKAction.removeFromParent()
        self.removeAllChildren()
        self.runAction(SKAction.sequence([fadeAction, removeAction]))
        gamePtr?.nextPuzzle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func center () ->CGPoint
    {
        return CGPointMake((self.windowSize.width/2.0), (self.windowSize.height/2.0))
    }
    
    
}