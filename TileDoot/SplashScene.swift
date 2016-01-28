//
//  GameScene.swift
//  TileDoot
//
//  Created by Garry Kling on 12/28/15.
//  Copyright (c) 2015 Garry Kling. All rights reserved.
//

import SpriteKit
import UIKit

class SplashScene: SKScene {
    
    let myLabel = SKLabelNode(fontNamed:"Futura-medium")
    var labelBackground = SKSpriteNode()
    
    override func didMoveToView(view: SKView)
    {
        self.backgroundColor = lightGreenTileColor
        // since we need a ptr to the method, this happens here instead of at init time
        let easyButton = TDButton(defaultImageName: "Purple2_def.png", selectImageName: "Purple2_sel.png", buttonAction: doEasyPuzzleMenu, labelStr: "Easy Puzzles")
        let hardButton = TDButton(defaultImageName: "Red1_def.png", selectImageName: "Red1_sel.png", buttonAction: doHardPuzzleMenu, labelStr: "Hard Puzzles")
        let infoButton = TDButton(defaultImageName: "info1.png", selectImageName: "info1.png", buttonAction: doInfo, labelStr: "")
        
        let gridSize = self.frame.width/12.0
        let bigButtonSize = 3.0*gridSize
        let bigButtonScale = bigButtonSize/500.0
        
        myLabel.text = "TileDoot"
        myLabel.fontSize = 48
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)*1.33)
        
//        easyButton.position = CGPoint(x: CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        easyButton.position = CGPoint(x: CGRectGetMidX(self.frame), y:gridSize*11.0)
        easyButton.setScale(bigButtonScale)
        
        hardButton.position = CGPoint(x: CGRectGetMidX(self.frame), y:gridSize*7.0)
        hardButton.setScale(bigButtonScale)
        
        infoButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: gridSize*2.0)
        infoButton.setScale(gridSize/500.0) // I want this little one @ 1/12 the width
        
        //self.addChild(splashImage)
        self.addChild(myLabel)
        self.addChild(easyButton)
        self.addChild(hardButton)
        self.addChild(infoButton)
    }
    
    func doEasyPuzzleMenu()
    {
        print("Easy Puzzle Button pushed.")
    }
    
    func doHardPuzzleMenu()
    {
        print("Hard Puzzle Button pushed.")
    }
    
    func doInfo()
    {
        print("Info button pushed.")
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
