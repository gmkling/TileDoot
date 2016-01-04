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
        let outOfRangeTest2 = Coordinate(x: 0, y: 17)
        let inRangeTest = Coordinate(x: 2, y: 6)
        
        XCTAssertTrue(testBoard.isLocInRange(inRangeTest))
        XCTAssertFalse(testBoard.isLocInRange(outOfRangeTest))
        XCTAssertFalse(testBoard.isLocInRange(outOfRangeTest2))
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
    
    func testGameBoardBuild()
    {
        let testDim = 16
        
        // construct the String rep of the game board
        let barrierRow = "****************"
        let puzRow1 = "******....******"
        let puzRow2 = "******....******"
        let puzRow3 = "******....******"
        let puzRow4 = "******B..B******"
        
        let block6 = barrierRow + barrierRow + barrierRow + barrierRow + barrierRow + barrierRow
        
        let puzzleString = block6 + puzRow1 + puzRow2 + puzRow3 + puzRow4 + block6
        
        var testBoard = GameBoard(initDimension: testDim)
        
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        
        testBoard.printBoardState()
        
        // how to further test?
        
    }
    
    // test union find methods - these are in the GameBoard class for now, but it may be good to push them over to the TileBoard class
    
    func testGameBoardMakeSet()
    {
        let testDim = 16
        
        // construct the String rep of the game board
        let barrierRow = "****************"
        let puzRow1 = "******....******"
        let puzRow2 = "******....******"
        let puzRow3 = "******....******"
        let puzRow4 = "******B..B******"
        
        let block6 = barrierRow + barrierRow + barrierRow + barrierRow + barrierRow + barrierRow
        
        let puzzleString = block6 + puzRow1 + puzRow2 + puzRow3 + puzRow4 + block6
        
        let testBoard = GameBoard(initDimension: testDim)
        
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        
        // test for out of range fail (should return nil)
        XCTAssert((testBoard.makeSet(Coordinate(x:0, y:testDim+1))) == nil)
        
        // check that it sets things up: rank=0, parent is nil
        let testLoc = Coordinate(x: 5, y: 5)
        let testTile = testBoard.makeSet(testLoc)
        XCTAssert(testTile?.rank==0)
        XCTAssert(testTile?.parent==nil)
        
    }
    
    // test find set
    
    func testGameBoardFindSet()
    {
        let testDim = 16
        
        // construct the String rep of the game board
        let barrierRow = "****************"
        let puzRow1 = "******....******"
        let puzRow2 = "******....******"
        let puzRow3 = "******....******"
        let puzRow4 = "******B..B******"
        
        let block6 = barrierRow + barrierRow + barrierRow + barrierRow + barrierRow + barrierRow
        
        let puzzleString = block6 + puzRow1 + puzRow2 + puzRow3 + puzRow4 + block6
        
        let testBoard = GameBoard(initDimension: testDim)
        
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        
        // find set looks for the root of the tree, 
        // and then shortens the tree so all nodes point to the root
        
        // test that the root is correct after stacking the deck
        // root is at [0,0], [1,0]->[1,1]->[0,1]->[0,0]
        // after calling findSet, all parents should be set to [0,0]
        // and the root returned should be [0,0]
        testBoard.tileMap![0, 1].parent = testBoard.tileMap![0, 0]
        testBoard.tileMap![1, 1].parent = testBoard.tileMap![0, 1]
        testBoard.tileMap![1, 0].parent = testBoard.tileMap![1, 1]
        
        var testRoot = testBoard.findSet(testBoard.tileMap![1,0])
        
        XCTAssert(testBoard.tileMap![1,0].parent!==testBoard.tileMap![0, 0])
        XCTAssert(testBoard.tileMap![1,1].parent!==testBoard.tileMap![0, 0])
        XCTAssert(testBoard.tileMap![0,1].parent!==testBoard.tileMap![0, 0])
        XCTAssert(testBoard.tileMap![0,0].parent==nil)
        XCTAssert(testRoot==testBoard.tileMap![0, 0])
        
    }
    
    // test unionSets
    
    func testGameBoardUnionSets()
    {
        let testDim = 16
        
        // construct the String rep of the game board
        let barrierRow = "****************"
        let puzRow1 = "******....******"
        let puzRow2 = "******....******"
        let puzRow3 = "******....******"
        let puzRow4 = "******B..B******"
        
        let block6 = barrierRow + barrierRow + barrierRow + barrierRow + barrierRow + barrierRow
        
        let puzzleString = block6 + puzRow1 + puzRow2 + puzRow3 + puzRow4 + block6
        
        let testBoard = GameBoard(initDimension: testDim)
        
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        
        // given two Tiles, A and B, unionSets will set the high ranked Tile (Tile.rank) as the parent of the other Tile
        // if A.rank == B.rank, A will parent B.
        
        // create two parents of the same rank with makeSet
        var setATile1 = testBoard.makeSet(Coordinate(x: 0, y: 0))!
        var setBTile1 = testBoard.makeSet(Coordinate(x: 0, y: 1))!
        
        // union those 1-tile sets, see that A is the parent and that setBTile.rank<setATile.rank
        testBoard.unionSets(setATile1, setB: setBTile1)
        XCTAssert(setBTile1.parent!==setATile1)
        XCTAssert(setATile1.rank>setBTile1.rank)
        
        // create two parents makeSet, change the rank of B>A
        var setATile2 = testBoard.makeSet(Coordinate(x: 1, y: 0))!
        var setBTile2 = testBoard.makeSet(Coordinate(x: 1, y: 1))!
        
        setBTile2.rank = 20
        testBoard.unionSets(setATile2, setB: setBTile2)
        
        // check that B is made parent, A's rank is lower
        XCTAssert(setATile2.parent! == setBTile2)
        XCTAssert(setATile2.rank < setBTile2.rank)
        
    }
    
    // test connectComponents
    
    func testGameBoardConnectComponents()
    {
        let testDim = 8
        
        // construct the String rep of the game board
        let puzRow1 = "BBBB****"
        let puzRow2 = "BBBB****"
        let puzRow3 = "****GGGG"
        let puzRow4 = "****GGGG"
        let puzRow5 = "***RR***"
        let puzRow6 = "***RR*OO"
        let puzRow7 = "RO***OO*"
        let puzRow8 = "GB**OO**"
        
        let puzzleString = puzRow1+puzRow2+puzRow3+puzRow4+puzRow5+puzRow6+puzRow7+puzRow8
        
        let testBoard = GameBoard(initDimension: testDim)
        
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        
        // connectComponents groups tiles of the same color that are vertically or horizontally adjoint
        // the groups are not stored in a seperate data structures, they are implied by sharing a common root node ptr
        // in the existing tileMap. eg tile A B and C are in a group since A&B point to C or A->B->C
        // the group is constructed using the connected components proceedure with tree shortening
        
        testBoard.connectComponents()
        
        // test that the 4 groups (B, G, R, and O) are distinct (share no root)
        var g1Root = Tile(initType: TileType.nullTile, initColor: Color.kNoColor)
        var g2Root = Tile(initType: TileType.nullTile, initColor: Color.kNoColor)
        var g3Root = Tile(initType: TileType.nullTile, initColor: Color.kNoColor)
        var g4Root = Tile(initType: TileType.nullTile, initColor: Color.kNoColor)
        
        if let g1Tile = testBoard.getTile(Coordinate(x: 0,y: 0))
        {
            g1Root = testBoard.findSet(g1Tile)
        }
        
        if let g2Tile = testBoard.getTile(Coordinate(x: 2,y: 4))
        {
            g2Root = testBoard.findSet(g2Tile)
        }
        
        if let g3Tile = testBoard.getTile(Coordinate(x: 4,y: 4))
        {
            g3Root = testBoard.findSet(g3Tile)
        }
        
        if let g4Tile = testBoard.getTile(Coordinate(x: 5,y: 7))
        {
            g4Root = testBoard.findSet(g4Tile)
        }
        
        var tileGroups = [g1Root, g2Root, g3Root, g4Root]
        
        // make sure we got them all
        for item in tileGroups
        {
            XCTAssertNotNil(item)
        }
        
        // they are distinct
        XCTAssert(g1Root != g2Root)
        XCTAssert(g1Root != g3Root)
        XCTAssert(g1Root != g4Root)
        XCTAssert(g2Root != g3Root)
        XCTAssert(g2Root != g4Root)
        XCTAssert(g3Root != g4Root)
        
        // Now test the singletons in the corner to make sure they have nil parents
        
        if let g1Tile = testBoard.getTile(Coordinate(x: 6,y: 0))
        {
            g1Root = testBoard.findSet(g1Tile)
        }
        
        if let g2Tile = testBoard.getTile(Coordinate(x: 6,y: 1))
        {
            g2Root = testBoard.findSet(g2Tile)
        }
        
        if let g3Tile = testBoard.getTile(Coordinate(x: 7,y: 0))
        {
            g3Root = testBoard.findSet(g3Tile)
        }
        
        if let g4Tile = testBoard.getTile(Coordinate(x: 7,y: 1))
        {
            g4Root = testBoard.findSet(g4Tile)
        }
        
        tileGroups = [g1Root, g2Root, g3Root, g4Root]
        
        // make sure they are all nil parents
        for item in tileGroups
        {
            XCTAssertNil(item.parent)
        }
        
        // what else?
    }
    
    // test clearMap
    func testGameBoardClearMap()
    {
        let testDim = 8
        
        // construct the String rep of the game board
        let puzRow1 = "BBBB****"
        let puzRow2 = "BBBB****"
        let puzRow3 = "****GGGG"
        let puzRow4 = "****GGGG"
        let puzRow5 = "***RR***"
        let puzRow6 = "***RR*OO"
        let puzRow7 = "RO***OO*"
        let puzRow8 = "GB**OO**"
        
        let puzzleString = puzRow1+puzRow2+puzRow3+puzRow4+puzRow5+puzRow6+puzRow7+puzRow8
        
        let testBoard = GameBoard(initDimension: testDim)
        
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        
        testBoard.clearMap()
        
        // now every Tile should be the nullTile type
        
        for i in 0..<testBoard.dimension {
            for j in 0..<testBoard.dimension {
                
                XCTAssert(testBoard.tileMap![i,j].type == TileType.nullTile)
            }
        }
        
        // good enough for me
        
    }
    

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
