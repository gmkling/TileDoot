//
//  TileDootModelTests.swift
//  TileDootModelTests
//
//  Created by Garry Kling on 12/30/15.
//  Copyright © 2015 Garry Kling. All rights reserved.
//

import XCTest
@testable import TileDoot

class TileDootModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTileInit()
    {
        let testColor = Color.kRed
        let testType = TileType.colorTile
        var tileTest = Tile(initType: testType, initColor: testColor)
        
        // basic.
        XCTAssertFalse(tileTest.isStop)
        XCTAssertFalse(tileTest.markedForDelete)
        XCTAssertFalse(tileTest.deleted)
        XCTAssertFalse(tileTest.moveInProgress)
        
        XCTAssertEqual(tileTest.type, testType)
        XCTAssertEqual(tileTest.color, testColor)
        XCTAssertEqual(tileTest.rank, 0)
        
    }
    
    func testGameBoardInit()
    {
        
    }

    
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
