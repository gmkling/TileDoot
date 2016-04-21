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
    var actionQ : [SequencedAction]
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
    
    func markComplete()
    {
        complete = true
    }
    
    func getNextIncompleteSubturn() -> [SequencedAction]?
    {
        var subturnIndexes = [0]
        var subturn : [SequencedAction]
        subturn = []
        
        for (index, item) in actionQ.enumerate()
        {
            if item is SubturnMark
            {
                subturnIndexes.append(index)
            }
        }
        
        var prevSubturn = 0
        var curSubturn = 0
        
        for index in subturnIndexes
        {
            // if this one is complete, make it the lastSubturn, and move to next
            if actionQ[index].complete
            {
                prevSubturn = index
            } else if !actionQ[index].complete {
                curSubturn = index
            }
        }
        
        // check the range, and pack them in
        // if both are 0, then nothing has been scheduled
        // if prev>cur, then we are done
        if prevSubturn == curSubturn { return nil }
        if prevSubturn > curSubturn { return nil }
        
        // get all items from lastSubturn to curSubturn, including the subturn mark itself
        
        for i in (prevSubturn)...curSubturn
        {
            subturn.append(actionQ[i])
        }
        
        return subturn
    }
    
//    func getSubturn(num: Int) -> [SequencedAction]?
//    {
//        
//    }
    
    func scanComplete() -> Bool
    {
        var allDone = true
        var i = 0
        for item in actionQ
        {
            if !item.complete
            {
                allDone = false
                print(i)
            }
            i += 1
        }
        
        if allDone { self.markComplete() }
        
        return allDone
    }
}