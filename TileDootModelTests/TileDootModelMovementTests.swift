//
//  TileDootModelMovementTests.swift
//  TileDoot
//
//  Created by Garry Kling on 1/7/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import XCTest
@testable import TileDoot

class TileDootModelMovementTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGameBoardTileMovesBasic()
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
        
        // the first test uses the same initial conditions, so the board is re-inited each time
        // connectComponents is run after each move, which interferes with moving
        // not to mention that once we start deleting tiles, re-init will be a must
        
        //print(puzzleString)
        
        // put the B's together - move right
        // check that the source is now empty in this case
        testBoard.dootTiles(MoveDirection.right)
        testBoard.printBoardState()
        XCTAssert(testBoard.tileMap[9,8].color == Color.kBlue)
        XCTAssert(testBoard.tileMap[9,9].color == Color.kBlue)
        XCTAssert(testBoard.tileMap[9,6].type == TileType.emptyTile)
        
        // then left
        testBoard.clearMap()
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        testBoard.dootTiles(MoveDirection.left)
        testBoard.printBoardState()
        XCTAssert(testBoard.tileMap[9,6].color == Color.kBlue)
        XCTAssert(testBoard.tileMap[9,7].color == Color.kBlue)
        
        // then up
        testBoard.clearMap()
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        testBoard.dootTiles(MoveDirection.up)
        testBoard.printBoardState()
        XCTAssert(testBoard.tileMap[6,6].color == Color.kBlue)
        XCTAssert(testBoard.tileMap[6,9].color == Color.kBlue)
        
        // and down - nothing should move in this case
        testBoard.clearMap()
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        testBoard.dootTiles(MoveDirection.down)
        testBoard.printBoardState()
        XCTAssert(testBoard.tileMap[9,6].color == Color.kBlue)
        XCTAssert(testBoard.tileMap[9,9].color == Color.kBlue)
        
    }
    
    func testGameBoardTileMovesSerial ()
    {
        let testDim = 16
        
        // construct the String rep of the game board
        let barrierRow = "****************"
        let puzRow1 = "******Y..O******"
        let puzRow2 = "******....******"
        let puzRow3 = "******....******"
        let puzRow4 = "******B..G******"
        
        let block6 = barrierRow + barrierRow + barrierRow + barrierRow + barrierRow + barrierRow
        
        let puzzleString = block6 + puzRow1 + puzRow2 + puzRow3 + puzRow4 + block6
        
        let testBoard = GameBoard(initDimension: testDim)
        
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        
        // some simple serial tests that should be ok with or without deletes
        
        // up - down - up
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        testBoard.dootTiles(MoveDirection.up)
        testBoard.dootTiles(MoveDirection.down)
        testBoard.dootTiles(MoveDirection.up)
        testBoard.printBoardState()
        XCTAssert(testBoard.tileMap[6,6].color == Color.kYellow)
        XCTAssert(testBoard.tileMap[6,9].color == Color.kOrange)
        XCTAssert(testBoard.tileMap[7,6].color == Color.kBlue)
        XCTAssert(testBoard.tileMap[7,9].color == Color.kGreen)
        
        // RLR
        testBoard.clearMap()
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        testBoard.dootTiles(MoveDirection.right)
        testBoard.dootTiles(MoveDirection.left)
        testBoard.dootTiles(MoveDirection.right)
        testBoard.printBoardState()
        XCTAssert(testBoard.tileMap[6,8].color == Color.kYellow)
        XCTAssert(testBoard.tileMap[6,9].color == Color.kOrange)
        XCTAssert(testBoard.tileMap[9,8].color == Color.kBlue)
        XCTAssert(testBoard.tileMap[9,9].color == Color.kGreen)
        
        // RUL
        testBoard.clearMap()
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        testBoard.dootTiles(MoveDirection.right)
        testBoard.dootTiles(MoveDirection.up)
        testBoard.dootTiles(MoveDirection.left)
        testBoard.printBoardState()
        XCTAssert(testBoard.tileMap[6,6].color == Color.kYellow)
        XCTAssert(testBoard.tileMap[6,7].color == Color.kOrange)
        XCTAssert(testBoard.tileMap[7,6].color == Color.kBlue)
        XCTAssert(testBoard.tileMap[7,7].color == Color.kGreen)
        
        // RUDLRLU
        testBoard.clearMap()
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        testBoard.dootTiles(MoveDirection.right)
        testBoard.dootTiles(MoveDirection.up)
        testBoard.dootTiles(MoveDirection.down)
        testBoard.dootTiles(MoveDirection.left)
        testBoard.dootTiles(MoveDirection.right)
        testBoard.dootTiles(MoveDirection.left)
        testBoard.dootTiles(MoveDirection.up)
        testBoard.printBoardState()
        
        XCTAssert(testBoard.tileMap[6,6].color == Color.kYellow)
        XCTAssert(testBoard.tileMap[6,7].color == Color.kOrange)
        XCTAssert(testBoard.tileMap[7,6].color == Color.kBlue)
        XCTAssert(testBoard.tileMap[7,7].color == Color.kGreen)
        
    }


}
