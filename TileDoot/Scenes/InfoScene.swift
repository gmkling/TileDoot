//
//  InfoScene.swift
//  TileDoot
//
//  Created by Garry Kling on 1/28/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation
import SpriteKit

class InfoScene: SKScene {
    
    let appLabel = SKLabelNode(fontNamed:"Futura-medium")
    let aGameBy = SKLabelNode(fontNamed:"Futura-medium")
    let companyName = SKLabelNode(fontNamed:"Futura-medium")
    var companyLogo = SKSpriteNode(imageNamed: "placeHolder.png")
    let codeNdesign = SKLabelNode(fontNamed:"Futura-medium")
    let authorName = SKLabelNode(fontNamed:"Futura-medium")
    // icon panel
    // radio buttons
    //var sfxButton = TDButton?()
    //var musicButton = TDButton?()
    
    override func didMoveToView(view: SKView)
    {
        self.backgroundColor = lightGreenTileColor
        
        
        let gridSize = self.frame.width/12.0
        let littleButtonSize = 0.5*gridSize
        let littleButtonScale = littleButtonSize/500.0
        let normalTextSize = CGFloat(16.0)
        let smallTextSize = CGFloat(8.0)
        
        // info icon at top
        var infoButton = SKSpriteNode(imageNamed: "info1.png")
        infoButton.setScale(gridSize/500.0)
        infoButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: gridSize*18.0)
        
        // The name of the game
        appLabel.text = "TileDoot"
        appLabel.fontSize = 28
        appLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y: gridSize*16.0)
        
        aGameBy.text = "a game by"
        aGameBy.fontSize = normalTextSize
        aGameBy.position = CGPoint(x: CGRectGetMidX(self.frame), y: gridSize*14.0)
        
        companyName.text = "Omondi Media"
        companyName.fontSize = normalTextSize
        companyName.position = CGPoint(x: CGRectGetMidX(self.frame), y: gridSize*12.0)
        
        codeNdesign.text = "Code and Design by:"
        codeNdesign.fontSize = normalTextSize
        codeNdesign.position = CGPoint(x: CGRectGetMidX(self.frame), y: gridSize*10.0)
        
        authorName.text = "Garry Kling"
        authorName.fontSize = normalTextSize
        authorName.position = CGPoint(x: CGRectGetMidX(self.frame), y: gridSize*9.0)
        
        // social buttons
        var webButton = TDButton(defaultImageName: "web-500px.png", selectImageName: "web-500px.png", buttonAction: doWebButton, labelStr: "")
        var githubButton = TDButton(defaultImageName: "GitHub-Mark-500px.png", selectImageName: "GitHub-Mark-500px.png", buttonAction: doGitButton, labelStr: "")
        var emailButton = TDButton(defaultImageName: "email-500px.png", selectImageName: "email-500px.png", buttonAction: doEmailButton, labelStr: "")
        
        webButton.position = CGPoint(x: CGRectGetMidX(self.frame) - gridSize, y:gridSize*8.0)
        webButton.setScale(littleButtonScale)
        
        emailButton.position = CGPoint(x: CGRectGetMidX(self.frame), y:gridSize*8.0)
        emailButton.setScale(littleButtonScale)
        
        githubButton.position = CGPoint(x: CGRectGetMidX(self.frame) + gridSize, y: gridSize*8.0)
        githubButton.setScale(littleButtonScale)
        
        // preference custom buttons - can we implement proper checkbox UI class please?
        // further, the whole group should be centered, the way this is here, that is not possible
        
        // change tiles to simple checkboxes when doing the custom class, the tiles are ugly for this
        var sfxButton = TDButton(defaultImageName: "BlueOFF.png", selectImageName: "BlueON.png", buttonAction: doSfxCheck, labelStr: "")
        sfxButton.position = CGPoint(x: 4.0*gridSize, y: gridSize*5.0)
        sfxButton.setScale(littleButtonScale)
        
        var sfxLabel = SKLabelNode(fontNamed: "Futura-medium")
        sfxLabel.text = "Enable SFX"
        sfxLabel.fontSize = normalTextSize
        sfxLabel.horizontalAlignmentMode = .Left
        sfxLabel.verticalAlignmentMode = .Center
        sfxLabel.position = CGPoint(x: gridSize*4.5, y: gridSize*5.0)
        
        var musicButton = TDButton(defaultImageName: "BlueOFF.png", selectImageName: "BlueON.png", buttonAction: doMusicCheck, labelStr: "")
        musicButton.position = CGPoint(x: 4.0*gridSize, y: gridSize*4.0)
        musicButton.setScale(littleButtonScale)
        
        var musicLabel = SKLabelNode(fontNamed: "Futura-medium")
        musicLabel.text = "Enable Music"
        musicLabel.fontSize = normalTextSize
        musicLabel.horizontalAlignmentMode = .Left
        musicLabel.verticalAlignmentMode = .Center
        musicLabel.position = CGPoint(x: gridSize*4.5, y: gridSize*4.0)
        
        // var tileSet
        
        self.addChild(infoButton)
        self.addChild(appLabel)
        self.addChild(aGameBy)
        self.addChild(companyName)
        self.addChild(codeNdesign)
        self.addChild(authorName)
        
        self.addChild(webButton)
        self.addChild(emailButton)
        self.addChild(githubButton)
        
        self.addChild(sfxButton)
        self.addChild(sfxLabel)
        self.addChild(musicButton)
        self.addChild(musicLabel)
    }
    
    func doEasyPuzzleMenu()
    {
        print("Easy Puzzle Button pushed.")
    }
    
    func doWebButton()
    {
        
    }
    
    func doGitButton()
    {
        
    }
    
    func doEmailButton()
    {
        
    }
    
    func doSfxCheck()
    {
        
    }
    
    func doMusicCheck()
    {
        // toggle music
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
