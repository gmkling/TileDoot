//
//  HUDView.swift
//  TileDoot
//
//  Created by Garry Kling on 4/28/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation
import SpriteKit


class HUDView : SKNode
{
    var HUDSize : CGSize
    var background = SKShapeNode()
    
    var moveScore = SKLabelNode(fontNamed: "futura-medium")
    var tileScore = SKLabelNode(fontNamed: "futura-medium")
    
    var nMoves = 0
    var par = 0
    var nTiles = 0
    var tilesTotal = 0
    
    init(size: CGSize)
    {
        HUDSize = size
        
        super.init()
        drawBackground()
        drawMoves()
        drawTileCount()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTiles(puzGameTiles: Int)
    {
        tilesTotal = puzGameTiles
        updateHUD()
    }
    
    func setPuzPar(puzPar: Int)
    {
        par = puzPar
        updateHUD()
    }
    
    func addMove()
    {
        nMoves += 1
        updateHUD()
    }
    
    func addTile()
    {
        nTiles += 1
        updateHUD()
    }
    
    func updateHUD()
    {
        moveScore.text = "Doots: \(nMoves)/\(par)"
        tileScore.text = "Tiles: \(nTiles)/\(tilesTotal)"
    }
    
    func resetScore()
    {
        nMoves = 0
        nTiles = 0
        updateHUD()
    }
    
    func drawBackground()
    {
        
        background = SKShapeNode.init(rectOfSize: HUDSize)
        background.fillColor = SKColor.lightGrayColor()
        background.strokeColor = SKColor.clearColor()
        background.position = self.center()
        self.addChild(background)
    }
    
    func drawMoves()
    {
        moveScore.fontSize = 16.0
        moveScore.position = CGPointMake(self.HUDSize.width*0.25, self.HUDSize.height*0.5)
        moveScore.verticalAlignmentMode = .Center
        moveScore.horizontalAlignmentMode = .Center
        updateHUD()
        addChild(moveScore)
    }
    
    func drawTileCount()
    {
        tileScore.fontSize = 16.0
        tileScore.position = CGPointMake(self.HUDSize.width*0.75, self.HUDSize.height*0.5)
        tileScore.verticalAlignmentMode = .Center
        tileScore.horizontalAlignmentMode = .Center
        updateHUD()
        addChild(tileScore)
    }
    
    func center () ->CGPoint
    {
        return CGPointMake((self.HUDSize.width/2.0), (self.HUDSize.height/2.0))
    }
}