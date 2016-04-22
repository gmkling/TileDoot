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
    
    var audioDelegate : TD_AudioPlayer?
    
    override func didMoveToView(view: SKView)
    {
        self.backgroundColor = greenTileColor
        
        let playButton = TDButton(defaultImageName: "PurplePlay_def.png", selectImageName: "PurplePlay_sel.png", buttonAction: doPlayButton, disabledImageName: nil, labelStr: "")
        let infoButton = TDButton(defaultImageName: "info1.png", selectImageName: "info1.png", buttonAction: doInfo, disabledImageName: nil, labelStr: "")
        
        let gridSize = self.frame.width/12.0
        let bigButtonSize = 3.0*gridSize
        let bigButtonScale = bigButtonSize/500.0
        
        myLabel.text = "Tile Doot"
        myLabel.fontSize = 48
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)*1.33)
        
        playButton.position = CGPoint(x: CGRectGetMidX(self.frame), y:gridSize*9.0)
        playButton.setScale(bigButtonScale)
       
        infoButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: gridSize*2.0)
        infoButton.setScale(gridSize/500.0) // I want this little one @ 1/12 the width
        
        self.addChild(myLabel)
        self.addChild(playButton)
        self.addChild(infoButton)
    }
    
    func doPlayButton()
    {
        audioDelegate?.playSFX(singleTap_key, typeKey: mono_key)
        // switch to PuzzleDirectoryScene
        // slide in from the Right
        let pdsTransition = SKTransition.pushWithDirection(.Left, duration: 0.5)
        let pdsScene = PuzzleDirectoryScene(size: view!.bounds.size)
        
        pdsScene.audioDelegate = audioDelegate
        scene!.view!.presentScene(pdsScene, transition: pdsTransition)
    }
    
    func doHardPuzzleMenu()
    {
        print("Hard Puzzle Button pushed.")
    }
    
    func doInfo()
    {
        audioDelegate?.playSFX(singleTap_key, typeKey: mono_key)
        // create transition
        let transition = SKTransition.pushWithDirection(.Right, duration: 0.5)
        // create the info scene
        let infoScene = InfoScene(size: view!.bounds.size)
        infoScene.audioDelegate = audioDelegate
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
