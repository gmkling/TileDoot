//
//  GameScene.swift
//  TileDoot
//
//  Created by Garry Kling on 12/28/15.
//  Copyright (c) 2015 Garry Kling. All rights reserved.
//

import SpriteKit

class SplashScene: SKScene {
    
    var splashImage = SKSpriteNode(imageNamed: "SplashGlass_test.jpg")
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Futura-medium")
        myLabel.text = "TileDoot"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        splashImage.position = CGPoint(x: frame.size.width/2 , y: frame.size.height/2)
        splashImage.setScale(0.5)
        
        var startButton = TDButton(defaultImageName: "StartButtonUp.png", selectImageName: "StartButtonDown.png", buttonAction: printStart)
        startButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + (myLabel.frame.height / 2) + 3)
        
        self.addChild(splashImage)
        self.addChild(myLabel)
        //self.addChild(startButton)
    }
    
    func printStart()
    {
        print("Start Button pushed.")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches
        {
            let location = touch.locationInNode(self)
            // interesting stuff goes here
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
