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

class PuzzleSet
{
    var nPuzzles = 0
    var puzzles : [Puzzle?]
    var name : String
    
    init(withName: String)
    {
        self.name = withName
        puzzles = []
    }
    
    // should overload this to be able to use a string + dimension
    func appendPuzzle(inPuzzle: Puzzle)
    {
        puzzles.append(inPuzzle)
        nPuzzles++
    }
    
    func removePuzzleNumber(var puzNum: Int)
    {
        // adjust the index
        puzNum--
        
        // check if index is in range or the puzzles are empty
        if puzNum>puzzles.count || puzNum<puzzles.startIndex || puzzles.count==0 { return }
        
        if puzzles[puzNum] == nil
        { return }
        
        puzzles.removeAtIndex(puzNum)
        nPuzzles--
    }
    
    func checkForLevel(var puzNum: Int) ->Bool
    {
        // adjust the index
        puzNum--
        
        // check if index is in range or the puzzles are empty
        if puzNum>puzzles.count || puzNum<puzzles.startIndex || puzzles.count==0 { return false }
        
        // see if the index is occupied by a valid puzzle
        if puzzles[puzNum]!.checkValid()
        {
            return true
        }
        
        return false
    }
    
    func getPuzzle(puzNum: Int) -> Puzzle?
    {
        // check if index is in range or the puzzles are empty
        if puzNum>puzzles.count || puzNum<puzzles.startIndex || puzzles.count==0 { return nil }
        
        return puzzles[puzNum]
    }
}

class Puzzle
{
    var dimension : Int
    var par : Int
    var puzzleValid = false
    
    // the stringRep
    
    var stringRep = String()
    
    init(dim: Int, inPar: Int, var levelString: String)
    {
        self.dimension = dim
        self.par = inPar
        
        // if the string is too big, truncate it
        if levelString.characters.count > dimension*dimension
        {
            var maxIndex = levelString.startIndex.advancedBy(dimension*dimension)
            var tempString = levelString.substringToIndex(maxIndex)
            levelString = tempString
        }
        
        stringRep.appendContentsOf(levelString)
        self.checkValid()
    }
    
    // all puzzle editing funcs will return false if they are out of range, make the puzzle too big, etc with no info
    
    func replaceRow(rowNum: Int, theRow: String) ->Bool
    {
        // check that rowNum is in range
        if rowNum >= dimension { return false }
        
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
