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
    
    // MARK: Text
    var labelString : String
    var buttonLabel = SKLabelNode(fontNamed: "Futura-medium")
        
    var action: () -> Void
    
    // MARK: Initializers
    
    init(defaultImageName: String, selectImageName: String, buttonAction: () -> Void, labelStr: String?)
    {
        self.defaultImage = SKSpriteNode(imageNamed: defaultImageName)
        self.selectedImage = SKSpriteNode(imageNamed: selectImageName)
        
        selectedImage.hidden = true
        action = buttonAction
        
        if labelStr == nil
        {
            labelString = "Untitled"
        } else
        {
            labelString = labelStr!
        }
        
        buttonLabel.text = labelString
        buttonLabel.fontSize = 64
        
        super.init()
        
        buttonLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        buttonLabel.zPosition = 1.0
        userInteractionEnabled = true
        addChild(defaultImage)
        addChild(selectedImage)
        addChild(buttonLabel)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        // if the touch begins on button, swap the selected image in for default
        selectedImage.hidden = false
        defaultImage.hidden = true
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        // if the user moves a touch, find out if it moved onto or off of the button
        // and do the right thing
        for touch in touches
        {
            var location: CGPoint = touch.locationInNode(self)
            
            if defaultImage.containsPoint(location)
            {
                selectedImage.hidden = false
                defaultImage.hidden = true
            } else {
                selectedImage.hidden = true
                defaultImage.hidden = false
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        for touch in touches
        {
            let location: CGPoint = touch.locationInNode(self)
            
            if defaultImage.containsPoint(location)
            {
                action()
            }
            
            selectedImage.hidden = true
            defaultImage.hidden = false
        }
    }
    
    // implement this once we have a better handle on things.
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
