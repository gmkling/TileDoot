//
//  GameLevel.swift
//  TileDoot
//
//  Created by Garry Kling on 2/4/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation

//class PuzzleSetManager
//{
//    let levelFileName = "levels_1.txt"
//    let levelSetName = "default"
//    var levels : [GameLevel] = []
//    var levelStrings : [String] = []
//    var numLevels = 0
//    
//    init()
//    {
//        do{
//            var rawLevels = try String.init(contentsOfFile: levelFileName, encoding: NSUTF8StringEncoding)
//            levelStrings = rawLevels.componentsSeparatedByString("\n")
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//        
//        for var i=0; i<levelStrings.count;
//        {
//            // parse the first line of the set. If it doesn't make sense, skip and go around the horn
//            var levelHeader : [String] = levelStrings[i].componentsSeparatedByString(" ")
//            var levelString = ""
//            
//            if let dim = Int(levelHeader[i])
//            {
//                // err handling!
//                let levelNumTemp = Int(levelHeader[i+1])
//                let parTemp = Int(levelHeader[i+2])
//                var n = dim
//                while n>=0
//                {
//                    levelString.appendContentsOf(levelStrings[i+n])
//                    n--
//                }
//                
//                levels.append(GameLevel(dim: dim, num: levelNumTemp!, inPar: parTemp!, levelString: levelString))
//                i+=dim
//            } else {
//                print("Line ", String(i), "does not make sense, skipping.")
//                i++;
//                // check for end of file - a blank line followed by the eof
//                continue
//            }
//            
//        }
//        
//    }
//    
//    
//    
//}
//
//class PuzzleSet
//{
//    
//}

class Puzzle
{
    var dimension : Int
    var levelNumber : Int
    var par : Int
    var puzzleValid = false
    
    // the stringRep
    
    var stringRep = String()
    
    init(dim: Int, num: Int, inPar: Int, levelString: String)
    {
        self.dimension = dim
        self.levelNumber = num
        self.par = inPar
        
        // check to see that the string will fit the dim
        if levelString.characters.count != dimension*dimension
        {
            puzzleValid = false
            return
        }
        
        stringRep.appendContentsOf(levelString)
        puzzleValid = true
    }
    
    // all puzzle editing funcs will return false if they are out of range, make the puzzle too big, etc with no info
    
    func replaceRow(rowNum: Int, theRow: String) ->Bool
    {
        // check that rowNum is in range
        if rowNum > dimension { return false }
        
        // check the row is proper dim
        if theRow.characters.count == self.dimension
        {
            var repRange = stringRep.startIndex.advancedBy(rowNum*dimension)..<stringRep.startIndex.advancedBy(rowNum*dimension + dimension)
            stringRep.replaceRange(repRange, with: theRow)
            return true
        } else { return false }
    }
    
    func prependRow(theRow: String) ->Bool
    {
        // we can only do this if
        // - theRow is the correct size
        // - prepending will leave stringRep.count <= dim*dim
        
        if theRow.characters.count != dimension { return false }
        if theRow.characters.count + stringRep.characters.count > dimension*dimension { return false }
        
        var tempString = theRow + stringRep
        stringRep = tempString
        
        self.checkValid()
        
        return true
    }
    
    func appendRow(theRow: String) ->Bool
    {
        // we can only do this if
        // - theRow is the correct size
        // - appending will leave stringRep.count <= dim*dim
        
        if theRow.characters.count != dimension { return false }
        if theRow.characters.count + stringRep.characters.count > dimension*dimension { return false }
        
        var tempString = stringRep + theRow
        stringRep = tempString
        
        self.checkValid()
        
        return true
    }
    
    func reverseString() ->String
    {
        return String(stringRep.characters.reverse())
    }
    
    func checkValid() ->Bool
    {
        if stringRep.characters.count == dimension*dimension { puzzleValid = true } else { puzzleValid=false }
        return puzzleValid
    }
}
