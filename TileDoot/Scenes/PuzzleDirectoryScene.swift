//
//  PuzzleDirectoryScene.swift
//  TileDoot
//
//  Created by Garry Kling on 1/28/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation
import SpriteKit

class PuzzleDirectoryScene: SKScene {
    
    
    override func didMoveToView(view: SKView)
    {
        self.backgroundColor = greenTileColor
        
        // some layout tools
        let gridSize = self.frame.width/12.0
        let littleButtonSize = 0.5*gridSize
        let littleButtonScale = littleButtonSize/500.0
        let imageWidth = 8.0*gridSize
        
        let normalTextSize = CGFloat(16.0)
        let smallTextSize = CGFloat(8.0)
        
        // hamburger button at top left
        let backButton = TDButton(defaultImageName: "PurpleMenu_def.png", selectImageName: "PurpleMenu_sel.png", buttonAction: doBackButton, labelStr: "")
        backButton.setScale(littleButtonScale*2.0)
        backButton.position = CGPoint(x: gridSize*1.5, y: self.frame.height - gridSize*1.5)
        
        // info button
        self.addChild(backButton)
        
    }
    
    func doBackButton()
    {
        // slide from left, where we came from
        let mmTransition = SKTransition.pushWithDirection(.Right, duration: 0.5)
        let mmScene = MainMenuScene(size: view!.bounds.size)
        scene!.view!.presentScene(mmScene, transition: mmTransition)
    }
}
