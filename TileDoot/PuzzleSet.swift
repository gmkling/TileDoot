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

//class PuzzleSetManager
//{
//    var nPuzzleSets = 0
//    var puzzleSets : [PuzzleSet?]
//    
//    
//    
//    init()
//    {
//        puzzleSets = []
//
//    }
//    
//    
//}

class PuzzleSet
{
    var nPuzzles = 0
    var puzzles : [Puzzle?]
    var name : String
    
    // storage for file i/o
    var rawPuzzleFile : String
    var puzzleSetStrings : [String]
    var nLines = 0
    
    // optional file name
    var fileName : String
    
    init(withName: String) // for building puzzle sets manually
    {
        self.name = withName
        fileName = ""
        puzzles = []
        rawPuzzleFile = String()
        puzzleSetStrings = []
    }
    
    init(withFileName: String) // for loading files
    {
        self.name = String()
        fileName = String(withFileName)
        puzzles = []
        rawPuzzleFile = String()
        puzzleSetStrings = []
        
        // this should then load, check, and parse the input file with funcs below
        
        if !loadPuzzleSetFile(fileName) { return }
        
        if !checkPuzzleSetHeader( puzzleSetStrings[0] )
        {
            print("Error reading header of PuzzleSet file: \(fileName)")
            print("Bad Header")
            return
        }
        
        if !parsePuzzleSet(1)
        {
            print("Problem in parsePuzzleSet")
            return
        }
    }
    
    func loadPuzzleSetFile(fileInBundle: String) ->Bool
    {
        let filePath = NSBundle.mainBundle().pathForResource(fileInBundle, ofType: nil)
        
        if filePath == nil
        {
            print("Failed to find PuzzleSet file in the Bundle: \(fileInBundle)")
            return false
        }
        
        // copy the path we used for reference
        fileName = filePath!
        
        do{
            rawPuzzleFile = try String(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding)
            puzzleSetStrings = rawPuzzleFile.componentsSeparatedByString("\n")
        } catch let error as NSError{
            print("Failure while reading file: \(fileInBundle)")
            print(error.localizedDescription)
            return false
        }
        
        // is there a good way to check success here?
        
        return true
    }
    
    func checkPuzzleSetHeader(headerString : String) ->Bool
    {
        // this assumes that the corresponding puzzleFile data is already loaded in the rawPuzzleFile and puzzleSetStrings vars
        
        // split it into substrings
        var fileHeader : [String] = headerString.componentsSeparatedByString(" ")
        
        // there are three items in the header
        if fileHeader.count != 3 { return false }
        
        // first member should be an Integer for the number of puzzles in the file
        // this is hard to check, I might create a max, but would rather not
        // nPuzzles = Int(fileHeader[0])! // change to be updated when puzzles are parsed
        
        // second member should be a String name of the PuzzleSet
        name = fileHeader[1]
        
        // third should be the total number of lines in the raw file as an Int
        nLines = Int(fileHeader[2])!
        if nLines != puzzleSetStrings.count { return false }
        
        return true
        
    }
    
    func checkPuzzleHeader(puzzleHeader: [String]) -> Bool
    {
        if puzzleHeader.count != 3
        {
            return false
        }
        
        // Int Dim, Int Par, String Nickname
        
        if let dimChar = puzzleHeader[0].characters.first
        {
            if dimChar >= "0" && dimChar <= "9"  {} else {return false}
        } else { return false }
        
        if let parChar = puzzleHeader[1].characters.first
        {
            if parChar >= "0" && parChar <= "9"  {} else {return false}
        } else { return false }
        
        if let nickChar = puzzleHeader[2].characters.first
        {
            if nickChar >= "0" && nickChar <= "9"  {return false}
        } else { return false }
        
        // a place for future checks
        // ...
        
        return true
    }
    
    func checkPuzzleLine(puzLine: String, puzDim: Int) ->Bool
    {

        // should match the dim - newlines have been removed we assume
        if puzLine.characters.count != puzDim { return false }
        
        // check for legal chars: TBD for all of them, need to finalize spec
        if puzLine.characters.contains(" ") { return false }
        
        // puzzle lines should begin with a char, but not digits
        // fail if we can't get char
        if let firstChar = puzLine.characters.first
        {
            if firstChar >= "0" && firstChar <= "9"  {return false}
        } else { return false }
        
        return true
    }
    
    func parsePuzzleSet(firstLineNum: Int) ->Bool
    {
        var nPuzzlesRead = 0
        
        // loop through the file and load each puzzle, skipping levels that don't make sense without failing
        for var i=firstLineNum; puzzleSetStrings[i] != "%END%";
        {
            if puzzleSetStrings[i]=="%END%"
            {
                print("Early end to file in set file \(fileName)")
                break
            }
            
            var puzzleHeader = puzzleSetStrings[i].componentsSeparatedByString(".")
            
            // parse the level header
            if !checkPuzzleHeader(puzzleHeader)
            {
                print("Puzzle header skipped at line \(i) in \(fileName)")
                i += 1
                continue
            }
            i += 1
            // we checked the header, we know it can be unwrapped
            let pDim = Int(puzzleHeader[0])!
            let tailIndex = i+pDim-1
            let templines = puzzleSetStrings[i...tailIndex]
                
            // create Puzzle and append to set
            if let newPuzzle = parsePuzzle(templines, dim: pDim)
            {
                if newPuzzle.puzzleValid
                {
                    newPuzzle.par = Int(puzzleHeader[1])!
                    newPuzzle.puzzleID = puzzleHeader[2]
                    self.appendPuzzle(newPuzzle)
                    nPuzzlesRead += 1
                }
            }
            
            // incr i by how many lines we read
            i+=pDim
        }
        
        return true
    }
    
    func parsePuzzle(puzzleLines: ArraySlice<String>, dim: Int) ->Puzzle?
    {
        var tempPuzzleString = String()
        for pLine in puzzleLines
        {
            // check a line
            let lineGood = checkPuzzleLine(pLine, puzDim: dim)
        
            // append if true, return nil Puzzle otherwise
            if lineGood
            {
                tempPuzzleString.appendContentsOf(pLine)
            } else {
                print("Bad puzzle line found")
                return nil
            }
        }
        
        return Puzzle(dim: dim, inPar: 0, levelString: tempPuzzleString, levelName: "")

    }
    
    // should overload this to be able to use a string + dimension
    func appendPuzzle(inPuzzle: Puzzle)
    {
        puzzles.append(inPuzzle)
        nPuzzles += 1
    }
    
    func removePuzzleNumber(inout puzNum: Int)
    {
        // adjust the index
        puzNum -= 1
        
        // check if index is in range or the puzzles are empty
        if puzNum>puzzles.count || puzNum<puzzles.startIndex || puzzles.count==0 { return }
        
        if puzzles[puzNum] == nil
        { return }
        
        puzzles.removeAtIndex(puzNum)
        nPuzzles -= 1
    }
    
    func checkForLevel(inout puzNum: Int) ->Bool
    {
        // adjust the index
        puzNum -= 1
        
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
    var progress = 0
    
    // the stringRep
    var puzzleID = String()
    var stringRep = String()
    
    init(dim: Int, inPar: Int, levelString: String, levelName: String?)
    {
        self.dimension = dim
        self.par = inPar
        
        // if the string is too big, truncate it
        if levelString.characters.count > dimension*dimension
        {
            let maxIndex = levelString.startIndex.advancedBy(dimension*dimension)
            stringRep = levelString.substringToIndex(maxIndex)
        } else { stringRep = levelString }
        
        if levelName != nil
        { puzzleID = levelName! } 
        
        getSavedProgress()
        
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
            let repRange = stringRep.startIndex.advancedBy(rowNum*dimension)..<stringRep.startIndex.advancedBy(rowNum*dimension + dimension)
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
        
        stringRep = theRow + stringRep
        
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
        
        stringRep = stringRep + theRow
        
        self.checkValid()
        
        return true
    }
    
    // this should return a String suitable to init the GameBoard object
    func reverseString() ->String
    {
        return String(stringRep.characters.reverse())
    }
    
    func reverseRows() ->String
    {
        var tempString = ""
//        var strIndex = stringRep.endIndex.advancedBy(-dimension)
        for index in 0...(dimension-1)
        {
            let strIndex = stringRep.endIndex.advancedBy(-((dimension*index)+dimension))
            for j in 0...(dimension-1)
            {
                tempString.append(stringRep[strIndex.advancedBy(j)])
                
            }
            
        }
        
        return tempString
    }
    
    func getSavedProgress()
    {
        // luckily integerForKey fails to 0 if the key is not found
        let savedData = NSUserDefaults.standardUserDefaults()
        progress = savedData.integerForKey(self.puzzleID)

    }
    
    func setSavedProgress(newProgress: Int)
    {
        self.progress = newProgress
        let savedData = NSUserDefaults.standardUserDefaults()
        savedData.setInteger(newProgress, forKey: self.puzzleID)
    }
    
    func checkValid() ->Bool
    {
        if stringRep.characters.count == dimension*dimension { puzzleValid = true } else { puzzleValid=false }
        return puzzleValid
    }
}
