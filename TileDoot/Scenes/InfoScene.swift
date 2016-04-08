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
    //var companyLogo = SKSpriteNode(imageNamed: "placeHolder.png")
    let codeNdesign = SKLabelNode(fontNamed:"Futura-medium")
    let authorName = SKLabelNode(fontNamed:"Futura-medium")
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var audioDelegate : TD_AudioPlayer?
    
    override func didMoveToView(view: SKView)
    {
        self.backgroundColor = greenTileColor
        
        
        let gridSize = self.frame.width/12.0
        let littleButtonSize = 0.5*gridSize
        let littleButtonScale = littleButtonSize/500.0
        let imageWidth = 8.0*gridSize
        
        let normalTextSize = CGFloat(16.0)
        //let smallTextSize = CGFloat(8.0)
        
        // info icon at top
        let infoButton = SKSpriteNode(imageNamed: "info1.png")
        infoButton.setScale(gridSize/500.0)
        infoButton.position = CGPoint(x: CGRectGetMidX(self.frame), y: gridSize*18.0)
        
        let backButton = TDButton(defaultImageName: "PurpleMenu_def.png", selectImageName: "PurpleMenu_sel.png", buttonAction: doBackButton, disabledImageName: nil, labelStr: "")
        backButton.setScale(littleButtonScale*2.0)
        backButton.position = CGPoint(x: gridSize*1.5, y: self.frame.height - gridSize*1.5)
        
        // The name of the game
        appLabel.text = "Tile Doot"
        appLabel.fontSize = 28
        appLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y: gridSize*18.0)
        
        let tileSheetImage = SKSpriteNode(imageNamed: "TileSheetSample.png")
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
        let webButton = TDButton(defaultImageName: "webButton-500px_def.png", selectImageName: "webButton-500px_sel.png", buttonAction: doWebButton, disabledImageName: nil, labelStr: "")
        let githubButton = TDButton(defaultImageName: "gitButton-500px_def.png", selectImageName: "gitButton-500px_sel.png", buttonAction: doGitButton, disabledImageName: nil, labelStr: "")
        let emailButton = TDButton(defaultImageName: "emailButton-500px_def.png", selectImageName: "emailButton-500px_sel.png", buttonAction: doEmailButton, disabledImageName: nil, labelStr: "")
        
        webButton.position = CGPoint(x: CGRectGetMidX(self.frame) - gridSize, y:gridSize*9.0)
        webButton.setScale(littleButtonScale)
        
        emailButton.position = CGPoint(x: CGRectGetMidX(self.frame), y:gridSize*9.0)
        emailButton.setScale(littleButtonScale)
        
        githubButton.position = CGPoint(x: CGRectGetMidX(self.frame) + gridSize, y: gridSize*9.0)
        githubButton.setScale(littleButtonScale)
        
        // preference custom buttons - can we implement proper checkbox UI class please?
        // further, the whole group should be centered, the way this is here, that is not possible
        
        let sfxState = defaults.boolForKey(sfx_key)
        let sfxButton = TDToggleButton(defaultImageName: "checkBox-500px_def.png", selectImageName: "checkBox-500px_sel.png", enableAction: doSfxOn, disableAction: doSfxOff, withState: sfxState, labelStr: "")
        sfxButton.position = CGPoint(x: 4.0*gridSize, y: gridSize*5.0)
        sfxButton.setScale(littleButtonScale)
        
        let sfxLabel = SKLabelNode(fontNamed: "Futura-medium")
        sfxLabel.text = "Sound Effects"
        sfxLabel.fontSize = normalTextSize
        sfxLabel.horizontalAlignmentMode = .Left
        sfxLabel.verticalAlignmentMode = .Center
        sfxLabel.position = CGPoint(x: gridSize*4.5, y: gridSize*5.0)
        
        let musicState = defaults.boolForKey(music_key)
        let musicButton = TDToggleButton(defaultImageName: "checkBox-500px_def.png", selectImageName: "checkBox-500px_sel.png", enableAction: doMusicOn, disableAction: doMusicOff, withState: musicState, labelStr: "")
        musicButton.position = CGPoint(x: 4.0*gridSize, y: gridSize*4.0)
        musicButton.setScale(littleButtonScale)
        
        let musicLabel = SKLabelNode(fontNamed: "Futura-medium")
        musicLabel.text = "Music"
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
        audioDelegate?.playSFX(pileTap_key, typeKey: stereo_key)
        // slide from right, where we came from
        let mmTransition = SKTransition.pushWithDirection(.Left, duration: 0.5)
        let mmScene = MainMenuScene(size: view!.bounds.size)
        mmScene.audioDelegate = audioDelegate
        scene!.view!.presentScene(mmScene, transition: mmTransition)
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
        // this is the old way, and it crashes and burns
        // let emailUrl = NSURL(string: "mailto: garry.kling@gmail.com")!
        // UIApplication.sharedApplication().openURL(emailUrl)
    }
    
    func doSfxOn()
    {
        // retain the default
        defaults.setBool(true, forKey: sfx_key)
        // update the player
        audioDelegate?.unmuteSFX()
        print("SFX On")
    }
    
    func doSfxOff()
    {
        // retain default
        defaults.setBool(false, forKey: sfx_key)
        // update the player
        audioDelegate?.muteSFX()
        print("SFX Off")
    }
    
    func doMusicOff()
    {
        // retain the default
        defaults.setBool(false, forKey: music_key)
        // update the player
        audioDelegate?.muteMusic()
        print("Music Off.")
    }
    
    func doMusicOn()
    {
        // retain the default
        defaults.setBool(true, forKey: music_key)
        
        // update the player
        audioDelegate?.unmuteMusic()
        print("Music On")
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
