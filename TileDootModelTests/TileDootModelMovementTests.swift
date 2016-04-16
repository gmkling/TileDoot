//
//  TileDootModelMovementTests.swift
//  TileDoot
//
//  Created by Garry Kling on 1/7/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import XCTest
@testable import TileDoot

class TileDootModelMovementTests: XCTestCase , GameBoardProtocol {

    // these are dummies for testing
    
    func startPuzzle()
    {}
    func startTurn(dir: MoveDirection)
    {}
    func endTurn()
    {}
    func endPuzzle()
    {}
    
    
    
    func addTile(loc: Coordinate, tile: Tile)
    {}
    
    func deleteTile(loc: Coordinate, group: Int)
    {}
    
    func setColor(loc: Coordinate, color: Color)
    {}
    
    func setTileType(loc: Coordinate, newType: TileType)
    {}
    
    func moveTile(fromLoc: Coordinate, toLoc: Coordinate)
    {}
    
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
        let puzRow4 = "******....******"
        let puzRow3 = "******....******"
        let puzRow2 = "******....******"
        let puzRow1 = "******Y..B******"
        
        let block6 = barrierRow + barrierRow + barrierRow + barrierRow + barrierRow + barrierRow
        
        let puzzleString = block6 + puzRow1 + puzRow2 + puzRow3 + puzRow4 + block6
        
        let testBoard = GameBoard(boardDimension: testDim, delegate: self)
        
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        
        // the first test uses the same initial conditions, so the board is re-inited each time
        // connectComponents is run after each move, which interferes with moving
        // not to mention that once we start deleting tiles, re-init will be a must
        
        //print(puzzleString)
        
        // put the B's together - move right
        // check that the source is now empty in this case
        testBoard.dootTiles(MoveDirection.right)
        testBoard.printBoardState()
        XCTAssert(testBoard.tileMap[8,6].color == Color.kYellow)
        XCTAssert(testBoard.tileMap[9,6].color == Color.kBlue)
        XCTAssert(testBoard.tileMap[6,6].type == TileType.emptyTile)
        
        // then left
        testBoard.clearMap()
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        testBoard.dootTiles(MoveDirection.left)
        testBoard.printBoardState()
        XCTAssert(testBoard.tileMap[6,6].color == Color.kYellow)
        XCTAssert(testBoard.tileMap[7,6].color == Color.kBlue)
        
        // then up
        testBoard.clearMap()
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        testBoard.dootTiles(MoveDirection.up)
        testBoard.printBoardState()
        XCTAssert(testBoard.tileMap[6,9].color == Color.kYellow)
        XCTAssert(testBoard.tileMap[9,9].color == Color.kBlue)
        
        // and down - nothing should move in this case
        testBoard.clearMap()
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        testBoard.dootTiles(MoveDirection.down)
        testBoard.printBoardState()
        XCTAssert(testBoard.tileMap[6,6].color == Color.kYellow)
        XCTAssert(testBoard.tileMap[9,6].color == Color.kBlue)
        
    }
    
    func testGameBoardTileMovesSerial ()
    {
        let testDim = 16
        
        // construct the String rep of the game board
        let barrierRow = "****************"
        let puzRow4 = "******Y..O******"
        let puzRow3 = "******....******"
        let puzRow2 = "******....******"
        let puzRow1 = "******B..G******"
        
        let block6 = barrierRow + barrierRow + barrierRow + barrierRow + barrierRow + barrierRow
        
        let puzzleString = block6 + puzRow1 + puzRow2 + puzRow3 + puzRow4 + block6
        
        let testBoard = GameBoard(boardDimension: testDim, delegate: self)
        
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        
        // some simple serial tests that should be ok with or without deletes
        
        // up - down - up
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        testBoard.dootTiles(MoveDirection.up)
        testBoard.dootTiles(MoveDirection.down)
        testBoard.dootTiles(MoveDirection.up)
        testBoard.printBoardState()
        XCTAssert(testBoard.tileMap[6,9].color == Color.kYellow)
        XCTAssert(testBoard.tileMap[9,9].color == Color.kOrange)
        XCTAssert(testBoard.tileMap[6,8].color == Color.kBlue)
        XCTAssert(testBoard.tileMap[9,8].color == Color.kGreen)
        
        // RLR
        testBoard.clearMap()
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        testBoard.dootTiles(MoveDirection.right)
        testBoard.dootTiles(MoveDirection.left)
        testBoard.dootTiles(MoveDirection.right)
        testBoard.printBoardState()
        XCTAssert(testBoard.tileMap[8,9].color == Color.kYellow)
        XCTAssert(testBoard.tileMap[9,9].color == Color.kOrange)
        XCTAssert(testBoard.tileMap[8,6].color == Color.kBlue)
        XCTAssert(testBoard.tileMap[9,6].color == Color.kGreen)
        
        // RUL
        testBoard.clearMap()
        print("RUL TEST********")
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        testBoard.dootTiles(MoveDirection.right)
        testBoard.printBoardState()
        testBoard.dootTiles(MoveDirection.up)
        testBoard.printBoardState()
        testBoard.dootTiles(MoveDirection.left)
        testBoard.printBoardState()
        XCTAssert(testBoard.tileMap[6,9].color == Color.kYellow)
        XCTAssert(testBoard.tileMap[7,9].color == Color.kOrange)
        XCTAssert(testBoard.tileMap[6,8].color == Color.kBlue)
        XCTAssert(testBoard.tileMap[7,8].color == Color.kGreen)
        
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
        
        XCTAssert(testBoard.tileMap[6,9].color == Color.kYellow)
        XCTAssert(testBoard.tileMap[7,9].color == Color.kOrange)
        XCTAssert(testBoard.tileMap[6,8].color == Color.kBlue)
        XCTAssert(testBoard.tileMap[7,8].color == Color.kGreen)
        
    }

    func testGameBoardTileMovesWithDeletes ()
    {
        let testDim = 8
        
        // construct the String rep of the game board
        let puzRow8 = "BBBB****"
        let puzRow7 = "BBBB****"
        let puzRow6 = "....GGGG"
        let puzRow5 = "....GGGG"
        let puzRow4 = "...RR***"
        let puzRow3 = "...RR*OO"
        let puzRow2 = "YO***OO*"
        let puzRow1 = "GB**OO**"
        
        let puzzleString = puzRow1+puzRow2+puzRow3+puzRow4+puzRow5+puzRow6+puzRow7+puzRow8
        
        let testBoard = GameBoard(boardDimension: testDim, delegate: self)
        
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        
        // some simple serial tests that should be ok with deletes
        
        // moving all left should delete Blue, Green, and Red groups
        testBoard.dootTiles(MoveDirection.left)
        
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[0,7].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[0,5].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[0,4].color)
        
        // but not singletons
        XCTAssertEqual(Color.kGreen, testBoard.tileMap[0,0].color)
        XCTAssertEqual(Color.kBlue, testBoard.tileMap[1,0].color)
        XCTAssertEqual(Color.kYellow, testBoard.tileMap[0,1].color)
        XCTAssertEqual(Color.kOrange, testBoard.tileMap[1,1].color)

        testBoard.printBoardState()

    }
    
    func testGameBoardTileMovesWithDeletesAndCollapse ()
    {
        let testDim = 8
        
        // construct the String rep of the game board
        let puzRow8 = "BBBB****"
        let puzRow7 = "BBBB****"
        let puzRow6 = "....GGGG"
        let puzRow5 = "....GGGG"
        let puzRow4 = "...RR***"
        let puzRow3 = "...RR.OO"
        let puzRow2 = "YO...OOY"
        let puzRow1 = "GB..OO**"
        
        let puzzleString = puzRow1+puzRow2+puzRow3+puzRow4+puzRow5+puzRow6+puzRow7+puzRow8
        
        let testBoard = GameBoard(boardDimension: testDim, delegate: self)
        
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        
        // some simple serial tests that should be ok with deletes
        
        // moving all left should delete Blue, Green, Red, and Orange groups
        testBoard.dootTiles(MoveDirection.left)
        
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[0,7].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[0,4].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[0,3].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[2,1].color)
        
        // yellow tile should collapse, and form group for delete
        // deleting the new yellow group at 0,1 & 1,1
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[0,1].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[1,1].color)
        
        testBoard.printBoardState()

    }
    
    func testGameBoardTileMovesSerialWithDeletesAndCollapse ()
    {
        let testDim = 8
        
        // construct the String rep of the game board
        let puzRow8 = "BBBB****"
        let puzRow7 = "BBBB****"
        let puzRow6 = "....GGGG"
        let puzRow5 = "....GGGG"
        let puzRow4 = "...RR***"
        let puzRow3 = "...RG.OO"
        let puzRow2 = "YO...OOY"
        let puzRow1 = "GB..OOB*"
        
        let puzzleString = puzRow1+puzRow2+puzRow3+puzRow4+puzRow5+puzRow6+puzRow7+puzRow8
        
        let testBoard = GameBoard(boardDimension: testDim, delegate: self)
        
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        
        // some simple serial tests that should be ok with deletes
        
        // moving all left should delete Blue, Green, Red, and Orange groups
        testBoard.dootTiles(MoveDirection.left)
        
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[0,7].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[0,5].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[0,3].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[2,2].color)
        
        // yellow tile should collapse, and form group for delete
        // deleting the group at 0,1 & 1,1
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[0,1].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[1,1].color)
        
        testBoard.printBoardState()
        
        // one move to finish the green in the corner
        testBoard.dootTiles(MoveDirection.down)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[0,0].color)
        XCTAssertEqual(Color.kNoColor, testBoard.tileMap[0,2].color)
        testBoard.printBoardState()
    }
    
    func testGameBoardTileMovesSerialWithDeletesAndMultiStageCollapse ()
    {
        let testDim = 16
        
        // construct the String rep of the game board
        let puzRow1 =  "BRY............."
        let puzRow2 =  ".BRY............"
        let puzRow3 =  "..BRY..........."
        let puzRow4 =  "...BPR.........."
        let puzRow5 =  "....BRR........."
        let puzRow6 =  ".....BPR........"
        let puzRow7 =  "......BRP......."
        let puzRow8 =  ".......BOR......"
        let puzRow9 =  "........BGP....."
        let puzRow10 = ".........BOR...."
        let puzRow11 = "..........BGO..."
        let puzRow12 = "...........BYG.."
        let puzRow13 = "............BYO."
        let puzRow14 = ".............BYG"
        let puzRow15 = "..............BY"
        let puzRow16 = "...............B"
        
        let puzzleString = puzRow1+puzRow2+puzRow3+puzRow4+puzRow5+puzRow6+puzRow7+puzRow8+puzRow9+puzRow10+puzRow11+puzRow12+puzRow13+puzRow14+puzRow15+puzRow16
        
        let testBoard = GameBoard(boardDimension: testDim, delegate: self)
        
        XCTAssert(testBoard.initBoardFromString(puzzleString))
        
    }

}
