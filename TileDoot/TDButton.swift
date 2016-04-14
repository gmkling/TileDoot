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
    var disabled = false
        
    var action: () -> Void
    
    // MARK: Initializers
    
    override init()
    {
        self.defaultImage = SKSpriteNode()
        self.selectedImage = SKSpriteNode()
        
        selectedImage.hidden = true
        labelString = ""
        
        buttonLabel.text = labelString
        buttonLabel.fontSize = 12
        
        action = {}
        
        super.init()
        
//        buttonLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
//        buttonLabel.zPosition = 1.0
        userInteractionEnabled = true
//        addChild(defaultImage)
//        addChild(selectedImage)
//        addChild(buttonLabel)
        
    }
    
    init(defaultImageName: String, selectImageName: String, buttonAction: () -> Void, disabledImageName: String?, labelStr: String?)
    {
        self.defaultImage = SKSpriteNode(imageNamed: defaultImageName)
        self.selectedImage = SKSpriteNode(imageNamed: selectImageName)
        if disabledImageName != nil{
            self.disabledImage = SKSpriteNode(imageNamed: disabledImageName!)
            disabledImage!.hidden = true
        }
        
        selectedImage.hidden = true
        action = buttonAction
        
        if labelStr == nil
        {
            labelString = ""
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
        if disabled { return }
        // if the touch begins on button, swap the selected image in for default
        selectedImage.hidden = false
        defaultImage.hidden = true
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        if disabled { return }
        // if the user moves a touch, find out if it moved onto or off of the button
        // and do the right thing
        for touch in touches
        {
            let location: CGPoint = touch.locationInNode(self)
            
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
        if disabled { return }
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
    
    override func setScale(scale: CGFloat) {
        super.setScale(scale)
    }
    
    func disable()
    {
        disabled = true
        disabledImage?.hidden = false
        defaultImage.hidden = true
        selectedImage.hidden = true
    }
    
    func enable()
    {
        disabled = false
        disabledImage?.hidden = true
        defaultImage.hidden = false
        selectedImage.hidden = true
    }
}

class TDToggleButton : TDButton
{
    var isEnabled = false
    
    var disableAction : () -> Void
    
    
    init(defaultImageName: String, selectImageName: String, enableAction: () -> Void, disableAction: () -> Void, withState: Bool, labelStr: String?)
    {
        isEnabled = withState
        self.disableAction = disableAction
        
        super.init(defaultImageName: defaultImageName, selectImageName: selectImageName, buttonAction: enableAction, disabledImageName: nil, labelStr: labelStr)
        
        if isEnabled
        {
            defaultImage.hidden = true
            selectedImage.hidden = false
            action()
        } else {
            defaultImage.hidden = false
            selectedImage.hidden = true
            disableAction()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        swapImages()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        // if the user moves a touch, find out if it moved onto or off of the button
        // and swap
        for touch in touches
        {
            let location: CGPoint = touch.locationInNode(self)
            
            if defaultImage.containsPoint(location) 
            {
                selectedImage.hidden = isEnabled
                defaultImage.hidden = !isEnabled
            } else {
                selectedImage.hidden = !isEnabled
                defaultImage.hidden = isEnabled
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
                isEnabled = !isEnabled
                if isEnabled {
                    action()
                    selectedImage.hidden = false
                    defaultImage.hidden = true
                } else {
                    disableAction()
                    selectedImage.hidden = true
                    defaultImage.hidden = false
                }
            }
            
        }
    }
    
    func swapImages()
    {
        selectedImage.hidden = !selectedImage.hidden
        defaultImage.hidden = !defaultImage.hidden
    }
    
    // implement this once we have a better handle on things.
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
