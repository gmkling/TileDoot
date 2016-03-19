//
//  TileSprite.swift
//  TileDoot
//
//  Created by Garry Kling on 3/17/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation
import SpriteKit

class TileSprite : SKSpriteNode
{
    var actionQ = [SKAction]()
    
    func enqueueAction(action: SKAction)
    {
        actionQ.append(action)
    }
    
    func executeNext()
    {
        if actionQ.count == 0 { return }
        
        self.runAction(actionQ.removeFirst())
    }
}
