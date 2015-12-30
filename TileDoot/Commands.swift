//
//  Commands.swift
//  TileDoot
//
//  Created by Garry Kling on 12/30/15.
//  Copyright © 2015 Garry Kling. All rights reserved.
//

import Foundation

// commands are used at the GameBoard level to manipulate Tiles on the board
// not really true commands as the code to do that is elsewhere, more like tokens


enum MoveDirection
{
    case up, down, left, right
}

class Command {
    var cmdComplete: Bool
    
    init()
    {
        self.cmdComplete = false
    }
}

class MoveCommand : Command {
    var dir: MoveDirection
    
    init(dir: MoveDirection)
    {
        self.dir = dir
        super.init()
    }
}