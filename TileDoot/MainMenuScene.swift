//
//  GameScene.swift
//  TileDoot
//
//  Created by Garry Kling on 12/28/15.
//  Copyright (c) 2015 Garry Kling. All rights reserved.
//

import SpriteKit
import UIKit

class MainMenuScene: SKScene {
    
    let myLabel = SKLabelNode(fontNamed:"Futura-medium")
    var labelBackground = SKSpriteNode()
    
    
    override func didMoveToView(view: SKView)
    {
        // saving a lot of the old layout info in comments until I finalize the new one.
        
        self.backgroundColor = greenTileColor
        
        // my TDButton class is great, but I'm not happy with the text labels yet.
        //let playButton = TDButton(defaultImageName: "Purple2_def.png", selectImageName: "Purple2_sel.png", buttonAction: doPlayButton, labelStr: "Play")
        let playButton = TDButton(defaultImageName: "PurplePlay_def.png", selectImageName: "PurplePlay_sel.png", buttonAction: doPlayButton, labelStr: "")
        //let hardButton = TDButton(defaultImageName: "Red1_def.png", selectImageName: "Red1_sel.png", buttonAction: doHardPuzzleMenu, labelStr: "Hard Puzzles")
        let infoButton = TDButton(defaultImageName: "info1.png", selectImageName: "info1.png", buttonAction: doInfo, labelStr: "")
        
        let gridSize = self.frame.width/12.0
        let bigButtonSize = 3.0*gridSize
        let bigButtonScale = bigButtonSize/500.0
        
        myLabel.text = "Tile Doot"
        myLabel.fontSize = 48
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)*1.33)
        
//        easyButton.position = CGPoint(x: CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        //playButton.position = CGPoint(x: CGRectGetMidX(self.frame), y:gridSize*11.0)
        playButton.position = CGPoint(x: CGRectGetMidX(self.frame), y:gridSize*9.0)
        playButton.setScale(bigButtonScale)
//        
//        hardButton.position = CGPoint(x: CGRectGetMidX(self.frame), y:gridSize*7.0)
//        hardButton.setScale(bigButtonScale)
        
        infoButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: gridSize*2.0)
        infoButton.setScale(gridSize/500.0) // I want this little one @ 1/12 the width
        
        //self.addChild(splashImage)
        self.addChild(myLabel)
        self.addChild(playButton)
//        self.addChild(hardButton)
        self.addChild(infoButton)
    }
    
    func doPlayButton()
    {
        // switch to PuzzleDirectoryScene
        // slide in from the Right
        let pdsTransition = SKTransition.pushWithDirection(.Left, duration: 0.5)
        let pdsScene = PuzzleDirectoryScene(size: view!.bounds.size)
        scene!.view!.presentScene(pdsScene, transition: pdsTransition)
    }
    
    func doHardPuzzleMenu()
    {
        print("Hard Puzzle Button pushed.")
    }
    
    func doInfo()
    {
        // create transition
        let transition = SKTransition.pushWithDirection(.Right, duration: 0.5)
        // create the info scene
        let infoScene = InfoScene(size: view!.bounds.size)
        // present it
        scene!.view!.presentScene(infoScene, transition: transition)

    }
    
    // touch overrides may not be needed since we are only interested in buttons.
//    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
//    {
//        
//        for touch in touches
//        {
//            let location = touch.locationInNode(self)
//            // interesting stuff goes here
//        }
//    }
    
    override func update(currentTime: CFTimeInterval) {
    
    }
}
