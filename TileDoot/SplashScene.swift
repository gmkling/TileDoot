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
    
    var splashImage = SKSpriteNode(imageNamed: "MainMenu1.png")
    let myLabel = SKLabelNode(fontNamed:"Futura-medium")
    var labelBackground = SKSpriteNode()
    
    override func didMoveToView(view: SKView)
    {
        self.backgroundColor = lightGreenTileColor
        // since we need a ptr to the method, this happens here instead of at init time
        let startButton = TDButton(defaultImageName: "Red1_test.png", selectImageName: "Red1_test.png", buttonAction: printStart)
        
        myLabel.text = "TileDoot"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame)*1.33)
        
        
        splashImage.position = CGPoint(x: frame.size.width/2 , y: -frame.size.height/2)
        splashImage.setScale(1.1)
        splashImage.zPosition = -1
        
        startButton.position = CGPoint(x: CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        startButton.setScale(0.25)
        
        //self.addChild(splashImage)
        self.addChild(myLabel)
        self.addChild(startButton)
    }
    
    func printStart()
    {
        print("Start Button pushed.")
        self.backgroundColor = colorBank.randomItem()
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
