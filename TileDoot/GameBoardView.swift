//
//  GameBoardView.swift
//  TileDoot
//
//  Created by Garry Kling on 3/16/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation
import CoreGraphics
import SpriteKit

// this view will be a part of the gameplay scene to represent the board
// It must be the delegate of the game model since a new model is created each time a puzzle is loaded

class GameBoardView : SKNode , GameBoardProtocol
{
    var size: CGSize
    var gameBoard : GameBoard?
    var dimension : Int
    var background = SKShapeNode()
    var tiles : SpriteBoard
    var moves : [Turn]
    weak var game : GamePlayScene?
    var tilesDooted = 0
    var puzzleObj : Puzzle
    
    weak var audioDelegate : TD_AudioPlayer?
    
    // grid
    var gridPath : CGMutablePath
    var gridLines = SKShapeNode()
    
    // victory screen
    weak var victoryScreen : VictoryView?
    
    
    
    // boardSize is the size in Pixels of the UI element
    init(puzzle: Puzzle, boardSize: CGSize, audioDel: TD_AudioPlayer?, game: GamePlayScene?)
    {
        self.size = boardSize
        self.dimension = puzzle.dimension
        tiles = SpriteBoard(dim: dimension)
        gridPath = CGPathCreateMutable()
        moves = []
        moves.append(Turn(dir: .none))
        
        if audioDel != nil
        {
            self.audioDelegate = audioDel
        }
        
        if game != nil
        {
            self.game = game!
        }
        
        //victoryScreen = VictoryView(size: boardSize, stars: 2, moves: 0, par: 0, tilesDooted: 0, game: game)
        puzzleObj = puzzle
        super.init()

        // TODO: animate this
        // init background
        drawBackground()
        drawGrid()
        
        // init board
        self.gameBoard = GameBoard(boardDimension: dimension, delegate: self, boardString: puzzle.reverseRows())
        
    }
    
    deinit
    {
        gameBoard = nil
        game = nil
        audioDelegate = nil
    }
    
    
    func drawBackground()
    {
        
        background = SKShapeNode.init(rectOfSize: size)
        background.fillColor = SKColor.lightGrayColor()
        background.strokeColor = SKColor.blackColor()
        background.position = self.center()
        self.addChild(background)
        
    }
    
    func drawGrid()
    {
        let theWidth = self.size.width
        let theHeight = self.size.height
        let gridSize = theWidth/CGFloat(dimension)
        
        // create the subpaths for the grid
        for num in 1..<dimension
        {
            let curX = gridSize*CGFloat(num)
            let curY = self.size.height - curX
            
            // vertical
            CGPathMoveToPoint(gridPath, nil, curX, theHeight)
            CGPathAddLineToPoint(gridPath, nil, curX, 0)
            CGPathCloseSubpath(gridPath)
            
            // horizontal
            CGPathMoveToPoint(gridPath, nil, 0, curY)
            CGPathAddLineToPoint(gridPath, nil, theWidth, curY)
            CGPathCloseSubpath(gridPath)
        }
        // turn the paths into a SKNode
        gridLines = SKShapeNode.init(path: gridPath)
        
        // set line style
        gridLines.strokeColor = SKColor.darkGrayColor()
        gridLines.lineWidth = 1.0
        gridLines.position = CGPointMake(0, 0)
        self.addChild(gridLines)
    }
    
    func runVictory()
    {
        // calc moves, par, stars
        let netMoves = moves.count-1 // first move is turn 0, which adds all tiles, ignore it
        let par = self.puzzleObj.par
        var stars = 0
        var curStatus = PuzzleStatus.unsolved
        
        if netMoves <= par { stars = 3; curStatus = PuzzleStatus.parMet}
        if netMoves == par+1 { stars = 2;  curStatus = PuzzleStatus.solved}
        if netMoves > par+1 { stars = 1; curStatus = PuzzleStatus.solved}
        
        saveProgress(self.puzzleObj.puzzleID, puzStatus: curStatus, nMoves: netMoves, nStars: stars, nTiles: self.tilesDooted)
        
        victoryScreen = VictoryView(size: self.size, stars: stars, moves: netMoves, par: par, tilesDooted: self.tilesDooted, game: self.game)
        victoryScreen!.alpha = 0.0
        
        self.addChild(victoryScreen!)
        self.gridLines.runAction(SKAction.fadeAlphaTo(0.0, duration: 0.025))
        victoryScreen!.runAction(SKAction.fadeInWithDuration(0.5))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func locationForCoord(coord: Coordinate) ->CGPoint
    {
        let newX = CGFloat(coord.x) * (self.size.width/CGFloat(self.dimension))
        let newY = CGFloat(coord.y) * (self.size.height/CGFloat(self.dimension))
        return CGPoint(x: newX, y: newY)
    }
    
    func clearTile(loc: Coordinate)
    {
        // this should not effect the existing sprite's behavior, just remove the reference. 
        // may need to protect this, I don't think it's threadsafe
        
        // make the location a blank sprite
        tiles[loc.x, loc.y] = TileSprite()
    }
    
    // the GameBoardProtocol
    func startPuzzle()
    {
        // triggers the scene to addTiles
        addSubturn()
    }
    
    func startTurn(dir: MoveDirection)
    {
        // TODO: Create a new Turn object for a new swipe, do anything else to get ready for a turn cycle
        moves.append(Turn(dir: dir))
        
        // can moves be disabled until endTurn() is called?
        // this dumps core now that gestures happen on a subview of skscene
//        for each in (self.scene!.view!.gestureRecognizers)!
//        {
//            each.enabled = false
//        }
    }
    
    func addSubturn()
    {
        // this signal is sent before a set of actions that take place as a single unit
        // currently (4/20/2016) this is after blocks of moves and blocks of deletes
        moves.last!.appendAction(SubturnMark())
    }
    
    func endTurn()
    {
        // if the swipe did not move any tiles, disregard it
        // a dry move will have 0 actions or only a subturn mark
        if moves.last!.actionQ.count <= 1
        {
            // if the swipe created no actions, throw it away and return
            moves.removeLast()
            // can moves be disabled until endTurn() is called?
            // this dumps core now that gestures happen on a subview of skscene
//            for each in (self.scene!.view!.gestureRecognizers)!
//            {
//                each.enabled = true
//            }
            print("Removed empty move")
            return
        }
        
        moves.last!.appendAction(EndTurnMark())
        
        // turn gesture recognizer back on
        // this dumps core now that gestures happen on a subview of skscene
//        for each in (self.scene!.view!.gestureRecognizers)!
//        {
//            each.enabled = true
//        }
    }
    
    func endPuzzle()
    {
        moves.last!.appendAction(EndPuzzleMark())
    }
    
    func addTile(loc: Coordinate, tile: Tile)
    {
        // no-op if the tileType is empty
        if tile.type == TileType.emptyTile { return }
        
        // get the location for the loc
        let tilePos = locationForCoord(loc)
        let tileAction = AddAction(loc: loc, tile: tile, pos: tilePos)

        moves.last!.appendAction(tileAction)
    
    }
    
    func deleteTile(loc: Coordinate, group: Int)
    {
        
        let delAction = DeleteAction(loc: loc, group: group)
        moves.last!.appendAction(delAction)
        tilesDooted += 1
    }
    
    func setColor(loc: Coordinate, color: Color)
    {
        // this should swap out the SKTexture in the sprite node I think
    }
    
    func setTileType(loc: Coordinate, newType: TileType)
    {
        // this should also muck with the tile image/texture I think
    }
    
    func moveTile(fromLoc: Coordinate, toLoc: Coordinate)
    {
        let moveCmd = MoveAction(from: fromLoc, to: toLoc)
        
        moves.last!.appendAction(moveCmd)
    }
    
    
    func addTileSprite(loc: Coordinate, tile: TileSprite)
    {
        tiles[loc.x, loc.y] = tile
        self.addChild(tile)
        
        tiles[loc.x, loc.y].executeActions()
    }
    
    
    func center () ->CGPoint
    {
        return CGPointMake((self.size.width/2.0), (self.size.height/2.0))
    }
    
    func saveProgress(puzID: String, puzStatus: PuzzleStatus, nMoves: Int, nStars: Int, nTiles: Int)
    {
        // retrieve progress, if it exists
        // save puzzle turn count
        // save solved state (unsolved, solved, par met)
        // save stars (* = solved, par + >2, ** = solved, par + 1 to 2, *** = par met or exceeded)
        // save tiles dooted
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var newProg = [ statusKey : puzStatus.rawValue,
                        movesKey : nMoves,
                        starKey : nStars,
                        tilesKey : nTiles
        ]
        
        if let oldProg = defaults.dictionaryForKey(puzID)
        {
            // overwrite if new nMoves is better or the old is 0
            let oldStatus = oldProg[statusKey] as! Int
            let oldMoves = oldProg[movesKey] as! Int
//            let oldStars = oldProg[starKey] as! Int
//            let oldTiles = oldProg[tilesKey] as! Int
            
            // if the old status was worse, overwrite it
            if oldStatus<puzStatus.rawValue {
                newProg[statusKey] = puzStatus.rawValue
            } else { // otherwise, use it
                newProg[statusKey] = oldStatus
            }
            if oldMoves>nMoves || oldMoves == 0
            {
                newProg[movesKey] = nMoves
                newProg[starKey] = nStars
                newProg[tilesKey] = nTiles
            }
            
            defaults.setObject(newProg, forKey: puzID)
            print("Created edited scores entry for puzID \(puzID)")
            
        } else { // create a progress entry if it doesn't exist
            
            defaults.setObject(newProg, forKey: puzID)
            print("Created brand new scores entry for puzID \(puzID)")
        }
        
    }
    
}

class SpriteBoard {
    var dimension: Int = 0
    var board = [TileSprite]()
    
    init(dim: Int) {
        let nullTile = TileSprite()
        self.dimension = dim
        self.board = [TileSprite](count:dim*dim, repeatedValue:nullTile)
    }
    
    subscript(row: Int, col: Int) -> TileSprite {
        get {
            assert(row >= 0 && row < dimension)
            assert(col >= 0 && col < dimension)
            return board[row*dimension + col]
        }
        set {
            assert(row >= 0 && row < dimension)
            assert(col >= 0 && col < dimension)
            board[row*dimension + col] = newValue
        }
    }
    
    func setAll(item: TileSprite) {
        for i in 0..<dimension {
            for j in 0..<dimension {
                self[i, j] = item
            }
        }
    }
}
