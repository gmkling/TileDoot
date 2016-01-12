//
//  TDButton.swift
//  TileDoot
//
//  Created by Garry Kling on 1/11/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import SpriteKit

class TDButton : SKNode
{
    // MARK: Images
    
    var defaultImage: SKSpriteNode
    var selectedImage: SKSpriteNode
    var disabledImage: SKSpriteNode?
    
    var action: () -> Void
    
    // MARK: Initializers
    
    init(defaultImageName: String, selectImageName: String, buttonAction: () -> Void)
    {
        self.defaultImage = SKSpriteNode(imageNamed: defaultImageName)
        self.selectedImage = SKSpriteNode(imageNamed: selectImageName)
        
        selectedImage.hidden = true
        action = buttonAction
        
        super.init()
        userInteractionEnabled = true
        addChild(defaultImage)
        addChild(selectedImage)
        
    }
    
    // implement this once we have a better handle on things.
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
