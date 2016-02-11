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
        
        var testPuzzle = Puzzle(dim: 4, num: 1, inPar: 1, levelString: testString)
        
        XCTAssert(testPuzzle.stringRep.hasPrefix("****"))
        XCTAssert(testPuzzle.stringRep.hasSuffix("...."))
    }
    
    func testPuzzleReplaceRow()
    {
        var testDim = 4
        var testString =    "****"
        testString +=       "RRRR"
        testString +=       "GGGG"
        testString +=       "...."
        
        var testPuzzle = Puzzle(dim: testDim, num: 1, inPar: 1, levelString: testString)
        
        XCTAssert(testPuzzle.stringRep.hasPrefix("****"))
        XCTAssert(testPuzzle.stringRep.hasSuffix("...."))
        
        let testRow = "$$$$"
        
        testPuzzle.replaceRow(0, theRow: testRow)
        testPuzzle.replaceRow(3, theRow: testRow)
        
        XCTAssert(testPuzzle.stringRep.hasPrefix(testRow))
        XCTAssert(testPuzzle.stringRep.hasSuffix(testRow))
        
        let testRow1 = "JJJJ"
        var testRowNum = 1
        
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
        
    }
    
    func testPuzzlePrependRow()
    {
        
    }
    
    func testPuzzleAppendRow()
    {
        
    }
    
    func testPuzzleReverseString()
    {
        
    }
    
    func testPuzzleCheckValid()
    {
        
    }
    
}
