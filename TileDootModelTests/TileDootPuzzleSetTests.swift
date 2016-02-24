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
        var testName = "Test Set"
        var testPuzzle = Puzzle(dim: 4, inPar: 1, levelString: "****************")
        var testPuzzleSet = PuzzleSet(withName: testName)
        
        XCTAssert(testPuzzleSet.name == testName)
        
    }
    
    func testPuzzleSetAdd()
    {
        var testName = "Test Set"
        var testPuzzle = Puzzle(dim: 4, inPar: 1, levelString: "****************")
        var testPuzzleSet = PuzzleSet(withName: testName)
        
        testPuzzleSet.appendPuzzle(testPuzzle)
        
        XCTAssert(testPuzzleSet.name == testName)
        XCTAssert(testPuzzleSet.nPuzzles == 1)
    }
    
    func testPuzzleSetRemove()
    {
        var testName = "Test Set"
        var testPuzzle = Puzzle(dim: 4, inPar: 1, levelString: "****************")
        var testPuzzleSet = PuzzleSet(withName: testName)
        
        testPuzzleSet.appendPuzzle(testPuzzle)
        
        XCTAssert(testPuzzleSet.name == testName)
        XCTAssert(testPuzzleSet.nPuzzles == 1)
        
        testPuzzleSet.removePuzzleNumber(1)
        
        XCTAssert(testPuzzleSet.nPuzzles == 0)
    }
   
    func testPuzzleSetCheck()
    {
        var testName = "Test Set"
        var testPuzzle = Puzzle(dim: 4, inPar: 1, levelString: "****************")
        var testPuzzleSet = PuzzleSet(withName: testName)
        
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
        var testName = "Test Set"
        var testPuzzle = Puzzle(dim: 4, inPar: 1, levelString: "****************")
        var testPuzzle1 = Puzzle(dim: 4, inPar: 1, levelString: "................")
        var testPuzzleSet = PuzzleSet(withName: testName)
        
        testPuzzleSet.appendPuzzle(testPuzzle)
        testPuzzleSet.appendPuzzle(testPuzzle1)
        
        XCTAssert(testPuzzleSet.name == testName)
        XCTAssert(testPuzzleSet.nPuzzles == 2)
        XCTAssert(testPuzzleSet.checkForLevel(1))
        
        var testPuzzleBack = testPuzzleSet.getPuzzle(1)!
        XCTAssert( testPuzzleBack.checkValid())
        XCTAssert( testPuzzleBack.stringRep.containsString("....") )
        
    }
    
    // MARK: File I/O tests
    
    func testPuzzleSetCheckFileHeader()
    {
        var testSet = PuzzleSet(withName: "George")
        
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
        // generate puzzle lines
        // extra spaces
        // wrong length
        // begin with digits
        // various illegal chars
        // empty string
    }
    
    func testPuzzleSetFileLoad()
    {
        // load a short file with known contents
        // check that the set.rawPuzzleFile matches
        // test levelStrings as well
        // check nPuzzles, puzzles.count, name, nLines, fileName
    }
    
    func testPuzzleSetInitWithFile()
    {
        // test against a good file
        // test against various bad ones
        // test against empty one
        // bad filename
    }
    
    
}
