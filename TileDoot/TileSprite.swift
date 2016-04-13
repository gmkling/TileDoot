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
    
    func bundleActionQ()
    {
        // collect enqueued actions into 1 sequence of actions
    }
}

// since actions on tiles may need to be passed around, deferred, processed, etc
// we'll make a token that can transformed into different concrete SKAction sequences
// depending on our needs. I don't think TileSprites will process their own actions

// this is not a command

enum ActionType : Int{
    case add, move, delete
}
class TileAction
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
    
    init(loc: Coordinate, tileColor: Color, type: TileType)
    {
        color = tileColor
        self.type = type
        
        super.init(tile: loc)
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



// if we make a data structure for this, can we log entire sessions this way? Undos, etc.

class Turn
{
    var move : MoveDirection
    var actionQ : [TileAction?]
    
    init(dir: MoveDirection)
    {
        move = dir
        actionQ = []
    }
    
    func addAction(action: TileAction)
    {
        actionQ.append(action)
    }
    
// probably use subscripts read/write/archive
    
}

