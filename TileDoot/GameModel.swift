//
//  GameModel.swift
//  TileDoot
//
//  Created by Garry Kling on 1/5/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation

class GameModel
{
    var dimension : Int
    var gameTiles : GameBoard?
    
    init()
    {
        
    }
    
    // starts game a level indicated
    // init code probably finds player's last level
    // and calls this
    func startAtLevel (levelNum: Int)
    {
        
    }
    
    // how we change levels
    func swapLevels ()
    {
        
    }
    
    // reset level - if player requests
    func resetLevel ()
    {
        
    }
    
    //
    
    // quit level at player request == return to menu
    func quitLevel ()
    {
        
    }
        
    // Handling commands
    
    // enqueueCommand appends a command to the queue
    func enqueueCommand ()
    {
        
    }
    
    // doMove fetches commands from queue and performs them
    func doMoves ()
    {
        
    }
}