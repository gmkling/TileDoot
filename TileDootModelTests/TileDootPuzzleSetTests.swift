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
    
    func testPuzzleSetCheckHeader()
    {
        // too many items
        // not enough
        // perfect header
        // empty header
        
    }
    
    func testPuzzleSetCheckPuzzleHeader()
    {
        // generate headers
        // good case
        // too many items
        // too few
        // wrong types of characters in 1st, 2nd, 3d slots
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
