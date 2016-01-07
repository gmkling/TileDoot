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
        let puzRow4 = "******Y..B******"
        
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
        XCTAssert(testBoard.tileMap[9,8].color == Color.kYellow)
        XCTAssert(testBoard.tileMap[9,9].color == Color.kBlue)
        XCTAssert(testBoard.tileMap[9,6].type == TileType.emptyTile)
        
        // then left
        testBoard.clearMap()
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        testBoard.dootTiles(MoveDirection.left)
        testBoard.printBoardState()
        XCTAssert(testBoard.tileMap[9,6].color == Color.kYellow)
        XCTAssert(testBoard.tileMap[9,7].color == Color.kBlue)
        
        // then up
        testBoard.clearMap()
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        testBoard.dootTiles(MoveDirection.up)
        testBoard.printBoardState()
        XCTAssert(testBoard.tileMap[6,6].color == Color.kYellow)
        XCTAssert(testBoard.tileMap[6,9].color == Color.kBlue)
        
        // and down - nothing should move in this case
        testBoard.clearMap()
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        testBoard.dootTiles(MoveDirection.down)
        testBoard.printBoardState()
        XCTAssert(testBoard.tileMap[9,6].color == Color.kYellow)
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

    func testGameBoardTileMovesWithDeletes ()
    {
        let testDim = 8
        
        // construct the String rep of the game board
        let puzRow1 = "BBBB****"
        let puzRow2 = "BBBB****"
        let puzRow3 = "....GGGG"
        let puzRow4 = "....GGGG"
        let puzRow5 = "...RR***"
        let puzRow6 = "...RR*OO"
        let puzRow7 = "YO***OO*"
        let puzRow8 = "GB**OO**"
        
        let puzzleString = puzRow1+puzRow2+puzRow3+puzRow4+puzRow5+puzRow6+puzRow7+puzRow8
        
        let testBoard = GameBoard(initDimension: testDim)
        
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        
        // some simple serial tests that should be ok with deletes
        
        // moving all left should delete Blue, Green, and Red groups
        testBoard.dootTiles(MoveDirection.left)
        
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[0,0].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[2,0].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[4,0].color)
        testBoard.printBoardState()

    }
    
    func testGameBoardTileMovesWithDeletesAndCollapse ()
    {
        let testDim = 8
        
        // construct the String rep of the game board
        let puzRow1 = "BBBB****"
        let puzRow2 = "BBBB****"
        let puzRow3 = "....GGGG"
        let puzRow4 = "....GGGG"
        let puzRow5 = "...RR***"
        let puzRow6 = "...RR.OO"
        let puzRow7 = "YO...OOY"
        let puzRow8 = "GB..OO**"
        
        let puzzleString = puzRow1+puzRow2+puzRow3+puzRow4+puzRow5+puzRow6+puzRow7+puzRow8
        
        let testBoard = GameBoard(initDimension: testDim)
        
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        
        // some simple serial tests that should be ok with deletes
        
        // moving all left should delete Blue, Green, Red, and Orange groups
        testBoard.dootTiles(MoveDirection.left)
        
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[0,0].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[2,0].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[4,0].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[6,2].color)
        
        // yellow tile should collapse, and form group for delete
        // deleting the group at 6,0 & 6,1
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[6,0].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[6,1].color)
        
        testBoard.printBoardState()

    }
    
    func testGameBoardTileMovesSerialWithDeletesAndCollapse ()
    {
        let testDim = 8
        
        // construct the String rep of the game board
        let puzRow1 = "BBBB****"
        let puzRow2 = "BBBB****"
        let puzRow3 = "....GGGG"
        let puzRow4 = "....GGGG"
        let puzRow5 = "...RR***"
        let puzRow6 = "...RG.OO"
        let puzRow7 = "YO...OOY"
        let puzRow8 = "GB..OOB*"
        
        let puzzleString = puzRow1+puzRow2+puzRow3+puzRow4+puzRow5+puzRow6+puzRow7+puzRow8
        
        let testBoard = GameBoard(initDimension: testDim)
        
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        
        // some simple serial tests that should be ok with deletes
        
        // moving all left should delete Blue, Green, Red, and Orange groups
        testBoard.dootTiles(MoveDirection.left)
        
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[0,0].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[2,0].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[4,0].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[6,2].color)
        
        // yellow tile should collapse, and form group for delete
        // deleting the group at 6,0 & 6,1
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[6,0].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[6,1].color)
        
        testBoard.printBoardState()
        
        // one move to finish the green in the corner
        testBoard.dootTiles(MoveDirection.down)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[7,0].color)
        testBoard.printBoardState()
    }

}
