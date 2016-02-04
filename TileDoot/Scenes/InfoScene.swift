//
//  InfoScene.swift
//  TileDoot
//
//  Created by Garry Kling on 1/28/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import UIKit
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
        let imageWidth = 8.0*gridSize
        
        let normalTextSize = CGFloat(16.0)
        let smallTextSize = CGFloat(8.0)
        
        // info icon at top
        var infoButton = SKSpriteNode(imageNamed: "info1.png")
        infoButton.setScale(gridSize/500.0)
        infoButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: gridSize*18.0)
        
        var backButton = TDButton(defaultImageName: "BlueBack_def-500px.png", selectImageName: "BlueBack_sel-500px.png", buttonAction: doBackButton, labelStr: "")
        backButton.setScale(littleButtonScale*2.0)
        backButton.position = CGPoint(x: gridSize*1.5, y: self.frame.height - gridSize*1.5)
        
        // The name of the game
        appLabel.text = "Tile Doot"
        appLabel.fontSize = 28
        appLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y: gridSize*18.0)
        
        var tileSheetImage = SKSpriteNode(imageNamed: "TileSheetSample.png")
        tileSheetImage.position = CGPoint(x: CGRectGetMidX(self.frame), y: gridSize*14.75)
        tileSheetImage.setScale(imageWidth/tileSheetImage.frame.width)
        
        aGameBy.text = "A Game By"
        aGameBy.fontSize = normalTextSize
        aGameBy.position = CGPoint(x: CGRectGetMidX(self.frame), y: gridSize*11.0)
        
//        companyName.text = "Omondi Media"
//        companyName.fontSize = normalTextSize
//        companyName.position = CGPoint(x: CGRectGetMidX(self.frame), y: gridSize*12.0)
//        
//        codeNdesign.text = "Code and Design"
//        codeNdesign.fontSize = normalTextSize
//        codeNdesign.position = CGPoint(x: CGRectGetMidX(self.frame), y: gridSize*10.0)
        
        authorName.text = "Garry Kling"
        authorName.fontSize = normalTextSize
        authorName.position = CGPoint(x: CGRectGetMidX(self.frame), y: gridSize*10.0)
        
        // social buttons
        var webButton = TDButton(defaultImageName: "web-500px.png", selectImageName: "web-500px.png", buttonAction: doWebButton, labelStr: "")
        var githubButton = TDButton(defaultImageName: "GitHub-Mark-500px.png", selectImageName: "GitHub-Mark-500px.png", buttonAction: doGitButton, labelStr: "")
        var emailButton = TDButton(defaultImageName: "email-500px.png", selectImageName: "email-500px.png", buttonAction: doEmailButton, labelStr: "")
        
        webButton.position = CGPoint(x: CGRectGetMidX(self.frame) - gridSize, y:gridSize*9.0)
        webButton.setScale(littleButtonScale)
        
        emailButton.position = CGPoint(x: CGRectGetMidX(self.frame), y:gridSize*9.0)
        emailButton.setScale(littleButtonScale)
        
        githubButton.position = CGPoint(x: CGRectGetMidX(self.frame) + gridSize, y: gridSize*9.0)
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
        
        //self.addChild(infoButton)
        self.addChild(backButton)
        self.addChild(appLabel)
        self.addChild(tileSheetImage)
        self.addChild(aGameBy)
        //self.addChild(companyName)
        //self.addChild(codeNdesign)
        self.addChild(authorName)
        
        self.addChild(webButton)
        self.addChild(emailButton)
        self.addChild(githubButton)
        
        self.addChild(sfxButton)
        self.addChild(sfxLabel)
        self.addChild(musicButton)
        self.addChild(musicLabel)
    }
    
    func doBackButton()
    {
        
    }
    
    func doWebButton()
    {
        let webUrl = NSURL(string: "http://www.garrykling.com")!
        UIApplication.sharedApplication().openURL(webUrl)
    }
    
    func doGitButton()
    {
        let gitUrl = NSURL(string: "http://www.github.com/gmkling")!
        UIApplication.sharedApplication().openURL(gitUrl)
    }
    
    func doEmailButton()
    {
        let emailUrl = NSURL(string: "mailto: garry.kling@gmail.com")!
        UIApplication.sharedApplication().openURL(emailUrl)
    }
    
    func doSfxCheck()
    {
        // toggle SFX
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