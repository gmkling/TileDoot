//
//  TileDootPuzzleSetTests.swift
//  TileDoot
//
//  Created by Garry Kling on 2/11/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import XCTest

class TileDootPuzzleSetTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPuzzleSetInit()
    {
        let testName = "Test Set"
        let testPuzzleSet = PuzzleSet(withName: testName)
        
        XCTAssert(testPuzzleSet.name == testName)
        
    }
    
    func testPuzzleSetAdd()
    {
        let testName = "Test Set"
        let testPuzzle = Puzzle(dim: 4, inPar: 1, levelString: "****************", levelName: testName)
        let testPuzzleSet = PuzzleSet(withName: testName)
        
        testPuzzleSet.appendPuzzle(testPuzzle)
        
        XCTAssert(testPuzzleSet.name == testName)
        XCTAssert(testPuzzleSet.nPuzzles == 1)
    }
    
    func testPuzzleSetRemove()
    {
        let testName = "Test Set"
        let testPuzzle = Puzzle(dim: 4, inPar: 1, levelString: "****************", levelName: testName)
        let testPuzzleSet = PuzzleSet(withName: testName)
        
        testPuzzleSet.appendPuzzle(testPuzzle)
        
        XCTAssert(testPuzzleSet.name == testName)
        XCTAssert(testPuzzleSet.nPuzzles == 1)
        
        testPuzzleSet.removePuzzleNumber(1)
        
        XCTAssert(testPuzzleSet.nPuzzles == 0)
    }
   
    func testPuzzleSetCheck()
    {
        let testName = "Test Set"
        let testPuzzle = Puzzle(dim: 4, inPar: 1, levelString: "****************", levelName: testName)
        let testPuzzleSet = PuzzleSet(withName: testName)
        
        testPuzzleSet.appendPuzzle(testPuzzle)
        
        XCTAssert(testPuzzleSet.name == testName)
        XCTAssert(testPuzzleSet.nPuzzles == 1)
        XCTAssert(testPuzzleSet.checkForLevel(1))
        
        testPuzzleSet.removePuzzleNumber(1)
        
        XCTAssert(testPuzzleSet.nPuzzles == 0)
        XCTAssertFalse(testPuzzleSet.checkForLevel(1))
    }
    
    func testPuzzleSetGetPuzzle()
    {
        let testName = "Test Set"
        let testPuzzle = Puzzle(dim: 4, inPar: 1, levelString: "****************", levelName: testName)
        let testPuzzle1 = Puzzle(dim: 4, inPar: 1, levelString: "................", levelName: testName)
        let testPuzzleSet = PuzzleSet(withName: testName)
        
        testPuzzleSet.appendPuzzle(testPuzzle)
        testPuzzleSet.appendPuzzle(testPuzzle1)
        
        XCTAssert(testPuzzleSet.name == testName)
        XCTAssert(testPuzzleSet.nPuzzles == 2)
        XCTAssert(testPuzzleSet.checkForLevel(1))
        
        let testPuzzleBack = testPuzzleSet.getPuzzle(1)!
        XCTAssert( testPuzzleBack.checkValid())
        XCTAssert( testPuzzleBack.stringRep.containsString("....") )
        
    }
    
    // MARK: File I/O tests
    
    func testPuzzleSetCheckFileHeader()
    {
        let testSet = PuzzleSet(withName: "George")
        
        // too many items
        let bigHeader = "20 Too long 200"
        XCTAssertFalse(testSet.checkPuzzleSetHeader(bigHeader))
        
        // not enough
        let smallHeader = "20 short"
        XCTAssertFalse(testSet.checkPuzzleSetHeader(smallHeader))
        
        // perfect header
        let goodHeader = "1 4x4 5"
        // simulate file i/o (ish)
        testSet.puzzleSetStrings = [goodHeader, "XXXX", "XXXX", "XXXX", "XXXX"]
        XCTAssert(testSet.checkPuzzleSetHeader(goodHeader))
        
        // empty header
        let emptyHeader = ""
        XCTAssertFalse(testSet.checkPuzzleSetHeader(emptyHeader))
        
    }
    
    func testPuzzleSetCheckPuzzleHeader()
    {
        let testSet = PuzzleSet(withName: "Bernie")
        // generate headers
        // good case
        let testHeader1 = "8.2.GoodPuzzle"
        // too many items
        let testHeader2 = "8.2.Not.So.Good"
        // too few
        let testHeader3 = "8.2"
        // wrong types of characters in 1st, 2nd, 3d slots
        let testHeader4 = "Very.VeryBad.6"
        
        XCTAssert(testSet.checkPuzzleHeader(testHeader1.componentsSeparatedByString(".")))
        XCTAssertFalse(testSet.checkPuzzleHeader(testHeader2.componentsSeparatedByString(".")))
        XCTAssertFalse(testSet.checkPuzzleHeader(testHeader3.componentsSeparatedByString(".")))
        XCTAssertFalse(testSet.checkPuzzleHeader(testHeader4.componentsSeparatedByString(".")))
    }
    
    func testPuzzleSetCheckPuzzleLine()
    {
        // set parameters
        let testSet = PuzzleSet(withName: "Bernie")
        let testDim = 4
        
        // generate puzzle lines
        // good one
        let lineGood = "****"
        // extra spaces
        let lineExtraSpace = "* **"
        // wrong length
        let lineTooLong = "**** "
        let lineTooShort = "***"
        
        // begin with digits
        let lineWDigits = "5***"
        
        // various illegal chars
        let lineBadChar = "?`\\"
        
        // empty string
        let lineEmpty = ""
        
        XCTAssert(testSet.checkPuzzleLine(lineGood, puzDim: testDim))
        XCTAssertFalse(testSet.checkPuzzleLine(lineExtraSpace, puzDim: testDim))
        XCTAssertFalse(testSet.checkPuzzleLine(lineTooLong, puzDim: testDim))
        XCTAssertFalse(testSet.checkPuzzleLine(lineTooShort, puzDim: testDim))
        XCTAssertFalse(testSet.checkPuzzleLine(lineWDigits, puzDim: testDim))
        XCTAssertFalse(testSet.checkPuzzleLine(lineBadChar, puzDim: testDim))
        XCTAssertFalse(testSet.checkPuzzleLine(lineEmpty, puzDim: testDim))
    }
    
    func testPuzzleSetFileLoad()
    {
        // load a short file with known contents - levels_1.txt
        let testFile = "levels_1.txt"
        let testSet = PuzzleSet(withName: "Bernie")
        
        XCTAssert(testSet.loadPuzzleSetFile(testFile))
        
        // check that the set.rawPuzzleFile matches
        XCTAssert(testSet.puzzleSetStrings[0] == "1 Test1 7")
        XCTAssert(testSet.puzzleSetStrings[1] == "4.1.TestLevel1")
        XCTAssert(testSet.puzzleSetStrings[2] == "****")
        XCTAssert(testSet.puzzleSetStrings[3] == "*..*")
        XCTAssert(testSet.puzzleSetStrings[4] == "*..*")
        XCTAssert(testSet.puzzleSetStrings[5] == "****")
        
        // check nPuzzles, puzzles.count, name, nLines, fileName
    }
    
    // test parsePuzzle
    // test parsePuzzleSet
    
    func testPuzzleSetInitWithFile()
    {
        // test against a good file
        let testFile = "levels_1.txt"
        let testSet = PuzzleSet(withFileName:testFile)
        
        // test PuzzleSet variables
        XCTAssert(testSet.name=="Test1")
        XCTAssert(testSet.nPuzzles==1)
        XCTAssert(testSet.nLines==7)
        XCTAssert(testSet.puzzles[0]?.stringRep == "*****..**..*****")
        XCTAssert(testSet.fileName ==  NSBundle.mainBundle().pathForResource(testFile, ofType: nil))
        
        // test against various bad ones
        // test against empty one
        // bad filename
    }
    
    
}
