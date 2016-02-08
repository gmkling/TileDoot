//
//  GameLevel.swift
//  TileDoot
//
//  Created by Garry Kling on 2/4/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation

class GameLevelManager
{
    let levelFileName = "levels_1.txt"
    let levelSetName = "default"
    var levels : [GameLevel] = []
    var levelStrings : [String] = []
    var numLevels = 0
    
    init()
    {
        do{
            var rawLevels = try String.init(contentsOfFile: levelFileName, encoding: NSUTF8StringEncoding)
            levelStrings = rawLevels.componentsSeparatedByString("\n")
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        for var i=0; i<levelStrings.count;
        {
            // parse the first line of the set. If it doesn't make sense, skip and go around the horn
            var levelHeader : [String] = levelStrings[i].componentsSeparatedByString(" ")
            var levelString = ""
            
            if let dim = Int(levelHeader[i])
            {
                // err handling!
                let levelNumTemp = Int(levelHeader[i+1])
                let parTemp = Int(levelHeader[i+2])
                var n = dim
                while n>=0
                {
                    levelString.appendContentsOf(levelStrings[i+n])
                    n--
                }
                
                levels.append(GameLevel(dim: dim, num: levelNumTemp!, inPar: parTemp!, levelString: levelString))
                i+=dim
            } else {
                print("Line ", String(i), "does not make sense, skipping.")
                i++;
                // check for end of file - a blank line followed by the eof
                continue
            }
            
        }
        
    }
    
    
    
}

class GameLevel
{
    var dimension : Int
    var levelNumber : Int
    var par : Int
    
    // the stringRep
    
    var stringRep : String
    
    init(dim: Int, num: Int, inPar: Int, levelString: String?)
    {
        self.dimension = dim
        self.levelNumber = num
        self.par = inPar
        
        // or use dim size to init the string?
        if levelString != nil
        {
            stringRep = levelString!
        } else { stringRep = "" }
    }
    
}
