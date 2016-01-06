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
    // the dimension of the game depends on the level
    // every level will have a new GameBoard
    // the cmdQueue is where cmds are stored
    var dimension : Int
    var gameTiles : GameBoard
    var cmdQueue : [Command]
    let maxCmd = 50
    var score : Int
    
    // level info
    var curLevel : Int
    var curLevelString : String
    var levelScore : Int
    
    
    init(startLevel: int, levelPath: String)
    {
        // set delegate for view
        // load first level
    }
    
    // starts the level indicated
    // levels do not need sequence, but can use it
    func startLevel (levelNum: Int)
    {
        
    }
    
    // how we change levels
    func swapLevels ()
    {
        
    }
    
    // reset level - if player requests
    func resetLevel ()
    {
        levelScore = 0
        gameTiles.clearMap()
        cmdQueue.removeAll(keepCapacity: true)
        startLevel(curLevel)
    }
    
    // quit level at player request == return to menu
    func quitLevel ()
    {
        
    }
    
    // Handling commands
    
    // enqueueCommand appends a command to the queue
    func enqueueCommand (cmd: Command)
    {
        // make sure the queue is not full - if full, ignore the cmd, sorry
        guard cmdQueue.count <= maxCmd else { return }
        
        cmdQueue.append(cmd)
    }
    
    // doCmds fetches commands from queue and performs them
    func doCmds ()
    {
        
    }
}