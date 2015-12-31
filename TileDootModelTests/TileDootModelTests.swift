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
        XCTAssertFalse(tileTest.moveInProgress)
        
        XCTAssertEqual(tileTest.type, testType)
        XCTAssertEqual(tileTest.color, testColor)
        XCTAssertEqual(tileTest.rank, 0)
        
    }
    
    func testTileOperatorIsEqual()
    {
        let testColor = Color.kRed
        let testType = TileType.colorTile
        var testTile1 = Tile(initType: testType, initColor: testColor)
        var testTile2 = Tile(initType: testType, initColor: testColor)
        
        // the first test should be true
        XCTAssert(testTile1 == testTile2)
        
        // change something
        testTile1.color = Color.kOrange
        // now they should be unequal
        XCTAssertFalse(testTile1 == testTile2)
        
    }
    
    func testGameBoardInit()
    {
        let testDim = 16
        
        var testBoard = GameBoard(initDimension: testDim)
        
        XCTAssertEqual(testBoard.dimension, testDim)
        XCTAssertEqual(testBoard.numTiles, testDim*testDim)
        
    }
    
    func testGameBoardAddDelete()
    {
        let testDim = 16
        let testType = TileType.colorTile
        let tileLoc = Coordinate(x: 10,y: 10)
        let testTile = Tile(initType: testType, initColor: Color.kRed)
        var testBoard = GameBoard(initDimension: testDim)
        
        testBoard.addTile(testTile, loc: tileLoc)
        XCTAssert(testBoard.tileMap![tileLoc.x, tileLoc.y] == testTile)
        
        // also sneak the operator overload tests here
        testBoard.deleteTile(tileLoc)
        XCTAssertFalse(testBoard.tileMap![tileLoc.x, tileLoc.y] == testTile)
        XCTAssertTrue(testBoard.tileMap![tileLoc.x, tileLoc.y] != testTile)
        XCTAssertTrue(testBoard.tileMap![tileLoc.x, tileLoc.y].type == TileType.nullTile)
        XCTAssertFalse(testBoard.tileMap![tileLoc.x, tileLoc.y].type != TileType.nullTile)
        
    }
    
    func testGameBoardRange()
    {
        let testDim = 16
        var testBoard = GameBoard(initDimension: testDim)
        let outOfRangeTest = Coordinate(x: 17, y: -2)
        let inRangeTest = Coordinate(x: 2, y: 6)
        
        XCTAssertTrue(testBoard.isLocInRange(inRangeTest))
        XCTAssertFalse(testBoard.isLocInRange(outOfRangeTest))
    }
    
    func testGameBoardOccupied()
    {
        let testDim = 16
        let testType = TileType.colorTile
        let tileLoc = Coordinate(x: 10,y: 10)
        let tileLoc2 = Coordinate(x: 0,y: 0)
        let testTile = Tile(initType: testType, initColor: Color.kRed)
        var testBoard = GameBoard(initDimension: testDim)
        
        testBoard.addTile(testTile, loc: tileLoc)
        
        XCTAssert(testBoard.isLocOccupied(tileLoc))
        XCTAssertFalse(testBoard.isLocOccupied(tileLoc2))
    }
    
    func testGameBoardStopTile()
    {
        let testDim = 16
        let testType = TileType.colorTile
        let tileLoc = Coordinate(x: 4,y: 2)
        let testTile = Tile(initType: testType, initColor: Color.kRed)
        var testBoard = GameBoard(initDimension: testDim)
        
        testBoard.addTile(testTile, loc: tileLoc)
        
        testBoard.setTileStop(tileLoc)
        XCTAssert(testBoard.isTileStop(tileLoc))

        testBoard.setTileNotStop(tileLoc)
        XCTAssertFalse(testBoard.isTileStop(tileLoc))
        
        testBoard.setTileStop(tileLoc)
        testBoard.deleteTile(tileLoc)
        XCTAssertFalse(testBoard.isTileStop(tileLoc))
    }
    
    func testGameBoardTileColor()
    {
        let testDim = 16
        let testType = TileType.colorTile
        let tileLoc = Coordinate(x: 4,y: 2)
        let testTile = Tile(initType: testType, initColor: Color.kRed)
        let testColor = Color.kGreen
        var testBoard = GameBoard(initDimension: testDim)
        
        testBoard.addTile(testTile, loc: tileLoc)
        
        // get/set
        testBoard.setTileColor(tileLoc, color: testColor)
        XCTAssert(testBoard.getTileColor(tileLoc) == testColor)
        
        // clear
        testBoard.clearTileColor(tileLoc)
        XCTAssert(testBoard.getTileColor(tileLoc) == Color.kNoColor)
        
    }
    
    func testGameBoardTileMoveFlag()
    {
        let testDim = 16
        let testType = TileType.colorTile
        let tileLoc = Coordinate(x: 4,y: 2)
        let testTile = Tile(initType: testType, initColor: Color.kRed)
        var testBoard = GameBoard(initDimension: testDim)
        
        testBoard.addTile(testTile, loc: tileLoc)
        
        testBoard.setTileMoving(tileLoc)
        XCTAssert(testBoard.isTileMoving(tileLoc))
        
        testBoard.setTileNotMoving(tileLoc)
        XCTAssertFalse(testBoard.isTileMoving(tileLoc))
        
    }
    
    func testGameBoardTileActualMoving()
    {
        let testDim = 16

        let testType = TileType.colorTile
        let tileColor = Color.kOrange
        let tileFromLoc = Coordinate(x: 4,y: 2)
        let tileToLoc = Coordinate(x: 7, y: 13)
        
        let testTile = Tile(initType: testType, initColor: tileColor)
        var testBoard = GameBoard(initDimension: testDim)
        
        testBoard.addTile(testTile, loc: tileFromLoc)
        testBoard.setTileStop(tileFromLoc)

        testBoard.moveTile(tileFromLoc, toLoc: tileToLoc)
        
        XCTAssert(testBoard.isLocOccupied(tileToLoc))
        XCTAssert(testBoard.isTileStop(tileToLoc))
        XCTAssert(testBoard.isLocOccupied(tileToLoc))
        XCTAssert(testBoard.getTileColor(tileToLoc)==tileColor)
        XCTAssert(testBoard.getTileType(tileToLoc)==testType)
        
        // make sure the move was destructive
        XCTAssertFalse(testBoard.isLocOccupied(tileFromLoc))
    }

    func testGameBoardTileCopy()
    {
        let testDim = 16
        
        let testType = TileType.colorTile
        let tileColor = Color.kYellow
        let tileFromLoc = Coordinate(x: 0,y: 2)
        let tileToLoc = Coordinate(x: 5, y: 15)
        
        let testTile = Tile(initType: testType, initColor: tileColor)
        var testBoard = GameBoard(initDimension: testDim)
        
        testBoard.addTile(testTile, loc: tileFromLoc)
        testBoard.setTileStop(tileFromLoc)
        
        testBoard.copyTile(tileFromLoc, toLoc: tileToLoc)
        
        XCTAssert(testBoard.isLocOccupied(tileToLoc))
        XCTAssert(testBoard.isTileStop(tileToLoc))
        XCTAssert(testBoard.isLocOccupied(tileToLoc))
        XCTAssert(testBoard.getTileColor(tileToLoc)==tileColor)
        XCTAssert(testBoard.getTileType(tileToLoc)==testType)
        
        // make sure the original is still there
        XCTAssert(testBoard.isLocOccupied(tileFromLoc))
        XCTAssert(testBoard.isTileStop(tileFromLoc))
        XCTAssert(testBoard.isLocOccupied(tileFromLoc))
        XCTAssert(testBoard.getTileColor(tileFromLoc)==tileColor)
        XCTAssert(testBoard.getTileType(tileFromLoc)==testType)
        
        // make sure they are distinct under modification
        // just one change should short circuit
        testBoard.setTileNotStop(tileFromLoc)
        XCTAssert(testBoard.tileMap![tileFromLoc.x, tileFromLoc.y] != testBoard.tileMap![tileToLoc.x, tileToLoc.y])
        XCTAssert(testBoard.getTileType(tileFromLoc) != testBoard.getTileType(tileToLoc))
        // etc
    }
    
    func testGameBoardTileDeleteFlag()
    {
        let testDim = 16
        
        let testType = TileType.colorTile
        let tileColor = Color.kYellow
        let tileLoc = Coordinate(x: 0,y: 2)
        
        let testTile = Tile(initType: testType, initColor: tileColor)
        var testBoard = GameBoard(initDimension: testDim)
        
        testBoard.addTile(testTile, loc: tileLoc)
        XCTAssertFalse(testBoard.checkTileForDelete(tileLoc))
        
        testBoard.markTileForDelete(tileLoc)
        XCTAssert(testBoard.checkTileForDelete(tileLoc))
        
        
        
    }
    
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
