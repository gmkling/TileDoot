//
//  TileDootPuzzleTests.swift
//  TileDoot
//
//  Created by Garry Kling on 2/11/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import XCTest
@testable import TileDoot

class TileDootPuzzleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPuzzleInit()
    {
        var testString =    "****"
        testString +=       "RRRR"
        testString +=       "GGGG"
        testString +=       "...."
        
        let testPuzzle = Puzzle(dim: 4, inPar: 1, levelString: testString, levelName: "Doot")
        
        XCTAssert(testPuzzle.stringRep.hasPrefix("****"))
        XCTAssert(testPuzzle.stringRep.hasSuffix("...."))
        
        // test truncation
    }
    
    func testPuzzleReplaceRow()
    {
        let testDim = 4
        var testString =    "****"
        testString +=       "RRRR"
        testString +=       "GGGG"
        testString +=       "...."
        
        let testPuzzle = Puzzle(dim: testDim, inPar: 1, levelString: testString, levelName: "Doot")
        
        XCTAssert(testPuzzle.stringRep.hasPrefix("****"))
        XCTAssert(testPuzzle.stringRep.hasSuffix("...."))
        
        let testRow = "$$$$"
        
        testPuzzle.replaceRow(0, theRow: testRow)
        testPuzzle.replaceRow(3, theRow: testRow)
        
        XCTAssert(testPuzzle.stringRep.hasPrefix(testRow))
        XCTAssert(testPuzzle.stringRep.hasSuffix(testRow))
        
        let testRow1 = "JJJJ"
        let testRowNum = 1
        
        testPuzzle.replaceRow(testRowNum, theRow: testRow1)
        testPuzzle.replaceRow(testRowNum+1, theRow: testRow1)
        // I could test the substring, but as long as the count is good and the prefix/suffix don't change, it works
        XCTAssert(testPuzzle.stringRep.characters.count == testDim*testDim)
        XCTAssert(testPuzzle.stringRep.hasPrefix(testRow))
        XCTAssert(testPuzzle.stringRep.hasSuffix(testRow))
        XCTAssert(testPuzzle.stringRep.containsString(testRow1))
    }
    
    func testPuzzleReplaceRowFails()
    {
        let testDim = 4
        var testString =    "****"
        testString +=       "RRRR"
        testString +=       "GGGG"
        testString +=       "...."
        
        let testPuzzle = Puzzle(dim: testDim, inPar: 1, levelString: testString, levelName: "Doot")
        
        // row too far
        XCTAssertFalse(testPuzzle.replaceRow(4, theRow: "0000"))
        
        // row too long
        XCTAssertFalse(testPuzzle.replaceRow(0, theRow: "00000"))

    }
    
    func testPuzzlePrependRow()
    {
        let testDim = 4
        var testString =    "RRRR"
        testString +=       "GGGG"
        testString +=       "...."
        
        let testPuzzle = Puzzle(dim: testDim, inPar: 1, levelString: testString, levelName: "Doot")
        
        XCTAssert(testPuzzle.prependRow("****"))
        
        XCTAssert(testPuzzle.stringRep.containsString("****"))
        XCTAssert(testPuzzle.stringRep.hasPrefix("****"))
    }
    
    func testPuzzleAppendRow()
    {
        let testDim = 4
        var testString =    "RRRR"
        testString +=       "GGGG"
        testString +=       "...."
        
        let testPuzzle = Puzzle(dim: testDim, inPar: 1, levelString: testString, levelName: "Doot")
        
        XCTAssert(testPuzzle.appendRow("****"))
        
        XCTAssert(testPuzzle.stringRep.containsString("****"))
        XCTAssert(testPuzzle.stringRep.hasSuffix("****"))
    }
    
    func testPuzzleReverseString()
    {
        let testDim = 2
        let testString = "1234"
        let reverse = "4321"
        let testPuzzle1 = Puzzle(dim: testDim, inPar: 1, levelString: testString, levelName: "Doot")
        
        XCTAssert(testPuzzle1.reverseString() == reverse)
        
        var longerTest = "1111"
        longerTest += "2222"
        longerTest += "3333"
        longerTest += "4444"
        let longerDim = 4
        
        let testPuzzle2 = Puzzle(dim: longerDim, inPar: 2, levelString: longerTest, levelName: "Doot")
        
        testPuzzle2.replaceRow(0, theRow: "5555")
        let testRev = testPuzzle2.reverseString()
        
        XCTAssert(testRev.hasSuffix("5555"))
        XCTAssert(testRev.hasPrefix("4444"))
    }
    
    func testPuzzleCheckValid()
    {
        let testDim = 4
        var testString =    "****"
        testString +=       "RRRR"
        testString +=       "GGGG"
        testString +=       "...."
        
        let testPuzzle = Puzzle(dim: testDim, inPar: 1, levelString: testString, levelName: "Doot")
        
        
        // abuse private data
        XCTAssert(testPuzzle.checkValid())
        
        testPuzzle.stringRep.appendContentsOf("Garbage")
        
        XCTAssertFalse(testPuzzle.checkValid())
        
        testPuzzle.stringRep.removeAll()
        
        XCTAssertFalse(testPuzzle.checkValid())
        
        testPuzzle.stringRep.appendContentsOf(testString)
        XCTAssert(testPuzzle.checkValid())
        
    }
    
}
