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

// since actions on tiles may need to be passed around, deferred, processed, etc
// we'll make a token that can transformed into different concrete SKAction sequences
// depending on our needs.


class SequencedAction
{
    init()
    {
        
    }
}

class SubturnMark : SequencedAction
{
    // this is the piece of the current turn that tokens after this belong to
    var subturnID : Int
    
    init(subturnNum: Int)
    {
        subturnID = subturnNum
    }
}

class TileAction : SequencedAction
{
    var target : Coordinate?

    init(tile: Coordinate?)
    {
        target = tile
    }
    
    // no execute for now
}

class AddAction : TileAction
{
    var color : Color
    var type : TileType
    var tileFile = ""
    var pos : CGPoint
    
    init(loc: Coordinate, tile: Tile, pos: CGPoint)
    {
        color = tile.color
        self.type = tile.type
        self.pos = pos
        
        switch tile.type {
        case .colorTile:
            tileFile = filenameForColor(tile.color)
        case .barrierTile:
            tileFile = "StopTileTest3.png"
        case .emptyTile:
            //tileFile = ""
            break
        case .nullTile:
            break
        default:
            print("Unrecognized TileType: \(tile.type)")
        }
        
        super.init(tile: loc)
    }
    
    func getTileSprite() -> TileSprite
    {
        let tempT = TileSprite(imageNamed: tileFile)
        
        tempT.position = self.pos
        
        return tempT
    }
}

class MoveAction : TileAction
{
    var to : Coordinate
    
    init(from: Coordinate, to: Coordinate)
    {
        self.to = to
        super.init(tile: from)
    }
}

class DeleteAction : TileAction
{
    var groupID : Int
    
    init(loc: Coordinate, group: Int)
    {
        groupID = group
        super.init(tile: loc)
    }
}

class AudioAction : TileAction
{
    var keyString : String
    var audioTypeKey : String
    
    init(loc: Coordinate, sfxKey: String, sfxType: String)
    {
        keyString = sfxKey
        audioTypeKey = sfxType
        
        super.init(tile: loc)
    }

}



// if we make a data structure for this, can we log entire sessions this way? Undos, etc.

class Turn
{
    var move : MoveDirection
    var actionQ : [SequencedAction?]
    var complete = false
    var subTurns = 0
    
    init(dir: MoveDirection)
    {
        move = dir
        actionQ = []
    }
    
    func appendAction(action: SequencedAction)
    {
        actionQ.append(action)
    }
    
// probably use subscripts read/write/archive
    
}

