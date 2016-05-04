//
//  SequencedAction.swift
//  TileDoot
//
//  Created by Garry Kling on 4/20/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation
import SpriteKit

// since actions on tiles may need to be passed around, deferred, processed, etc
// we'll make a token that can transformed into different concrete SKAction sequences
// depending on our needs.


class SequencedAction
{
    var processed = false
    var complete = false
    
    init()
    {
        
    }
    
    func markComplete()
    {
        complete = true
    }
    
    func markProcessed()
    {
        processed = true
    }
    
}

class SubturnMark : SequencedAction
{
    // this is the piece of the current turn that tokens after this belong to
    // marks are placed, but the ID is dependent on context
    
    var subturnID = 0
    
    func setSubturnID(newID: Int)
    {
        subturnID = newID
    }
    
}

class EndTurnMark : SequencedAction
{
    
}

class EndPuzzleMark : SequencedAction
{
    
    
}

class TileAction : SequencedAction
{
    // abstract node in the tree above tile actions
    // as opposed to actions that operate on Puzzles, Turns, context, etc.
    var target : Coordinate?
    
    init(tile: Coordinate?)
    {
        target = tile
    }
    
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
//        default: // the impossible default
//            print("Unrecognized TileType: \(tile.type)")
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

