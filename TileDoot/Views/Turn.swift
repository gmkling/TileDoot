//
//  Turn.swift
//  TileDoot
//
//  Created by Garry Kling on 4/20/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation

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
        if action is SubturnMark
        {
            subTurns += 1
        }
        
        actionQ.append(action)
    }
    
    // probably use subscripts read/write/archive
    
}