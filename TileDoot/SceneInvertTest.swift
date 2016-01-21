//
//  SceneInvertTest.swift
//  TileDoot
//
//  Created by Garry Kling on 1/21/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import SpriteKit

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

class SceneInvertTest: SKScene {
    
    
    
    override func didMoveToView(view: SKView)
    {
        // since we need a ptr to the method, this happens here instead of at init time
        let endButton = TDButton(defaultImageName: "NewGameActive_test.png", selectImageName: "NewGameSelected_test.png", buttonAction: printStart)
        
        // flip the coord system so that [0,0] is TRHC
        //self.yScale = -1.0
        let sceneSizeX = self.size.width
        let sceneSizeY = self.size.height
        var tileSprites = [SKSpriteNode]()
        let dim = 64
        let spriteDim = CGFloat(dim)
        let tileSizeIn = CGFloat(500) // my tiles are 500x500 pngs
        var tileRenderSize = sceneSizeX / spriteDim
        let tileScale = tileRenderSize / tileSizeIn
        //let tileName = ["Purple1_test.png", "Blue1_test.png", "Red1_test.png"]
        
        for i in 0..<dim
        {
            for j in 0..<dim*2
            {
                var tile = SKSpriteNode(imageNamed: tileNames.randomItem())
                tile.anchorPoint = CGPointMake(0.0, 1.0)
                
                // how we calculate the position may be an alternative to re-writing the model
                tile.position = CGPointMake(sceneSizeX - (CGFloat(i+1) * tileRenderSize), sceneSizeY - (CGFloat(j)*tileRenderSize))
                tile.xScale = tileScale
                tile.yScale = tileScale
                self.addChild(tile)
                tileSprites.append(tile)
                
            }
        }
        
        
        
        
        endButton.position = CGPoint(x: CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        endButton.setScale(0.25)

    }
    
    func printStart()
    {
        print("Start Button pushed.")
    }
    
    // touch overrides may not be needed since we are only interested in buttons.
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        
        for touch in touches
        {
            let location = touch.locationInNode(self)
            // interesting stuff goes here
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        
    }
}
