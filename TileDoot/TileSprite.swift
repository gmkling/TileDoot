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
    var deleteMark = false
    
    func enqueueAction(action: SKAction)
    {
        actionQ.append(action)
    }
    
    func executeNext()
    {
        if actionQ.count == 0 { return }
        
        self.runAction(actionQ.removeFirst(), completion: {self.executeNext()})
    }
    
    func bundleActionQ()
    {
        if actionQ.count == 0 { return }
        
        var actionSeq = [SKAction]()
        
        for action in actionQ
        {
            actionSeq.append(action)
        }
        
        actionQ.removeAll()
        actionQ.append(SKAction.sequence(actionSeq))
    }
    
    func executeActions()
    {
        if actionQ.count == 0 { return }
        if actionQ.count > 1 { bundleActionQ() }
        
        self.runAction(actionQ[0], completion: {
            if self.deleteMark
            {
                let delay = SKAction.waitForDuration(0.25)
                let fadeAction = SKAction.fadeOutWithDuration(0.25)
                //let audioAction = SKAction.runBlock({audioDelegate?.playSFX(pileTap_key, typeKey: mono_key)})
                let delAction = SKAction.removeFromParent()
                self.runAction(SKAction.sequence([delay, fadeAction, delAction]))
            }
        }
        )
        actionQ.removeAll()
        //self.executeNext()
    }
    
}





