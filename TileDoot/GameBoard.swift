//
//  GameBoard.swift
//  TileDoot
//
//  Created by Garry Kling on 12/30/15.
//  Copyright © 2015 Garry Kling. All rights reserved.
//

import Foundation

enum MoveDirection
{
    case up, down, left, right, none
}

protocol GameBoardProtocol : class {
    
    // for synchronization
    func startPuzzle()
    func startTurn(dir: MoveDirection)
    func addSubturn()
    func endTurn()
    func endPuzzle()
    
    func addTile(loc: Coordinate, tile: Tile)
    func deleteTile(loc: Coordinate, group: Int)
    
    // these are the only properties we need to make the sprite look right
    func setColor(loc: Coordinate, color: Color)
    func setTileType(loc: Coordinate, newType: TileType)
    
    func moveTile(fromLoc: Coordinate, toLoc: Coordinate)
    
    // this protocol could probably use a signal at the end of a turn, after collapses etc, to trigger all actions
}

// GameBoard is the game model wrapped around a TileBoard. It uses the GameBoard Protocol to communicate with its view

class GameBoard {
    
    var dimension, numTiles: Int
    var tileMap : TileBoard
    var tileMapDirty = false;
    var solved = false
    var nGameTiles = 0
    
    unowned let delegate : GameBoardProtocol
    
     // orig init is initMap which creates a new blank map
    init(boardDimension: Int, delegate: GameBoardProtocol)
    {
        self.dimension = boardDimension
        self.numTiles = boardDimension*boardDimension
        
        tileMap = TileBoard(dim: boardDimension)
        self.delegate = delegate
    }
    
    init(boardDimension: Int, delegate: GameBoardProtocol, boardString: String)
    {
        self.dimension = boardDimension
        self.numTiles = boardDimension*boardDimension
        
        tileMap = TileBoard(dim: boardDimension)
        self.delegate = delegate
        
        self.initBoardFromString(boardString)
    }
    
    func initBoardFromString (boardString: String) ->Bool
    {
        var curTile : Character
        var i = 0
        let boardSize = boardString.characters.count
        
        // check bounds/size - drop out if it is too big or small (arbitrarily set to 4)
        if numTiles < boardSize || boardSize < 4
        {
            return false
        }
        
        // iterate over string to construct it in a GameBoard object
        // you can't just cruise through a string index by index since some chars
        // take up more than one position, so swift lets you do this:
        for index in boardString.characters.indices
        {
            curTile = boardString[index]
            
            // make a null tile. If the input matches nothing valid, we add nullTile and move on
            var newTile = Tile(initType: TileType.nullTile, initColor: Color.kNoColor)
            
            if let curType = self.getTypeForChar(curTile)
            {
                // this is a non-color tile
                newTile = Tile(initType: curType, initColor: Color.kNoColor)
                if curType==TileType.barrierTile { newTile.isStop = true }
                
            } else if let curColor = self.getColorForChar(curTile)
            {
                // this is a color tile
                newTile = Tile(initType: TileType.colorTile, initColor: curColor)
            }
            
            // unwrap the index
            let curCol = i % self.dimension
            let curRow = (i-curCol)/self.dimension
            
            // insert the tile
            
            self.addTile(newTile, loc: Coordinate(x:curCol, y:curRow))
            
            i += 1
        }
        
        delegate.startPuzzle()
        return true
        
    }
    
    // add/delete
    
    func addTile(newTile: Tile, loc: Coordinate)
    {
        // if it is a nullTile, overwrite it with the new one
        if tileMap[loc.x, loc.y].type == TileType.nullTile
        {
            tileMap[loc.x, loc.y] = newTile
            delegate.addTile(loc, tile: newTile)
            // if it is a game tile, count it
            if newTile.type == .colorTile { nGameTiles += 1 }
        }
        
    }
    
    func deleteTile(loc: Coordinate)
    {
        var delTile = tileMap[loc.x, loc.y]
        
        // insert a nullTile if one is not already there
        if delTile.type != TileType.nullTile
        {
            // get the ID of the parent
            // TODO: we want the ID of the ROOT, hello?
            //if delTile.parent == nil {
            delegate.deleteTile(loc, group: findSetID(delTile))
            //}  else {
            //    delegate.deleteTile(loc, group: (delTile.parent?.tileID)!)
            //}
            
            tileMap[loc.x, loc.y] = Tile(initType: TileType.nullTile, initColor: Color.kNoColor)
        }
    }
    
    
    func emptyTile (loc: Coordinate)
    {
        tileMap[loc.x, loc.y] = Tile(initType: TileType.emptyTile, initColor: Color.kNoColor)
    }
    
    func emptyTile (x: Int, y: Int)
    {
        tileMap[x, y] = Tile(initType: TileType.emptyTile, initColor: Color.kNoColor)
    }

    func isLocInRange(loc: Coordinate) ->Bool
    {
        let lessThanZero = loc.x < 0 || loc.y < 0
        let greaterThanDim = loc.x > (dimension-1) || loc.y > (dimension-1)
        return !(lessThanZero || greaterThanDim)
    }
    
    func isLocInRange(x: Int, y: Int) ->Bool
    {
        return isLocInRange(Coordinate(x: x, y: y))
    }
    
    // Occupied is implied by the presence of a non-null, non-empty tile
    // this is not the same as a stop tile
 
    func isLocOccupied(loc: Coordinate) ->Bool
    {
        let tileNull = tileMap[loc.x, loc.y].type == TileType.nullTile
        let tileEmpty = tileMap[loc.x, loc.y].type == TileType.emptyTile
        
        if !tileNull && !tileEmpty
        { return true }
        
        return false
    }
    
    func isPuzzleSolved() -> Bool
    {
        // for each tile, check to see if a game tile is present
        for i in 0..<dimension
        {
            for j in 0..<dimension
            {
                // if we ever add another type of game tile, we will need to account for it
                // or change to test a playable property or somesuch thing
                if tileMap[i,j].type == TileType.colorTile
                {
                    return false
                }
            }
        }
        
        return true
    }

    // stop property
    
    func setTileStop(loc: Coordinate)
    {
        tileMap[loc.x, loc.y].isStop = true
    }

    func setTileNotStop(loc: Coordinate)
    {
        tileMap[loc.x, loc.y].isStop = false
    }

    func isTileStop(loc: Coordinate) ->Bool
    {
        return tileMap[loc.x, loc.y].isStop
    }
    
    // color - all need delegate notifs

    func setTileColor(loc: Coordinate, color: Color)
    {
        tileMap[loc.x, loc.y].color = color
        delegate.setColor(loc, color: color)
    }
    
    func clearTileColor(loc: Coordinate)
    {
        tileMap[loc.x, loc.y].color = Color.kNoColor
    }
    
    func getTileColor(loc: Coordinate) ->Color
    {
        return tileMap[loc.x, loc.y].color
    }
    
    func setTileType(loc: Coordinate, newType: TileType)
    {
        tileMap[loc.x, loc.y].type = newType
        delegate.setTileType(loc, newType: newType)
    }
    
    func getTileType(loc: Coordinate) ->TileType
    {
        return tileMap[loc.x, loc.y].type
    }
    
    // moving tiles
    
    func setTileMoving(loc: Coordinate)
    {
        tileMap[loc.x, loc.y].moveInProgress = true
    }
    
    func setTileNotMoving(loc: Coordinate)
    {
        tileMap[loc.x, loc.y].moveInProgress = false
    }
    
    func isTileMoving(loc: Coordinate) ->Bool
    {
        return tileMap[loc.x, loc.y].moveInProgress
    }
    
    // copy, move: tiles
    
    // move in this case is instantaneous, 
    // the above "moveInProgress" property accounts for the time a tile moves
    // across the screen during an animated move
    func moveTile(fromLoc: Coordinate, toLoc: Coordinate)
    {
        let fromTile = tileMap[fromLoc.x, fromLoc.y]
        let toTile = tileMap[toLoc.x, toLoc.y]
        
        toTile.color = fromTile.color
        toTile.type = fromTile.type
        toTile.isStop = fromTile.isStop
        
        // needed?
        toTile.markedForDelete = fromTile.markedForDelete
        
        // empty out the source
        self.emptyTile(fromLoc)
        
        // notify delegate of move
        delegate.moveTile(fromLoc, toLoc: toLoc)
    }
    
//    func copyTile(fromLoc: Coordinate, toLoc: Coordinate)
//    {
//        let fromTile = tileMap[fromLoc.x, fromLoc.y]
//        let toTile = tileMap[toLoc.x, toLoc.y]
//        
//        toTile.color = fromTile.color
//        toTile.type = fromTile.type
//        toTile.isStop = fromTile.isStop
//        
//        // needed?
//        toTile.markedForDelete = fromTile.markedForDelete
//        // this method needs updated whenever the Tile class is changed
//        // I don't like that, I need to find a better way
//        
//        // notify delegate of copy
//    }
    
    // delete flag - game-driven
    
    func markTileForDelete(loc: Coordinate)
    {
        tileMap[loc.x, loc.y].markedForDelete = true
    }
    
    func checkTileForDelete(loc: Coordinate) ->Bool
    {
        return tileMap[loc.x, loc.y].markedForDelete
    }
    
    // handling chars for board maps
    
    func getTypeForChar(tc: Character) ->TileType?
    {
        return typeChars.someKeyFor(tc)
    }
    
    func getStringForType(tt: TileType) ->Character
    {
        return typeChars[tt]!
    }
    
    func getColorForChar(cc: Character) ->Color?
    {
        return colorChars.someKeyFor(cc)
    }
    
    func getStringForColor(inColor: Color) ->Character
    {
        return colorChars[inColor]!
    }
    
    func getTileRank(loc: Coordinate) ->Int
    {
        return tileMap[loc.x, loc.y].rank
    }
    
    func getTile(loc: Coordinate) ->Tile?
    {
        if !isLocInRange(loc) { return nil }
        
        return tileMap[loc.x, loc.y]
    }
    
    
  
    func printBoardState()
    {
        var curLoc : Coordinate
        var curType : TileType
        
        // Todo - need this to print out the matrix in the new (left-handed, column major) way
        for (var i=(tileMap.dimension-1); i>=0; i -= 1){
            for j in 0..<tileMap.dimension {
                curLoc = Coordinate(x: j,y: i)
                curType = getTileType(curLoc)
                // if it isn't a color tile, print the typeChar and bail
                if  curType != TileType.colorTile
                {
                    print(typeChars[getTileType(curLoc)]!, terminator:"")
                } else if curType == TileType.colorTile
                {
                    print(colorChars[getTileColor(curLoc)]!, terminator:"")
                } else
                {
                    print(" ")
                }
            }
            print("\n", terminator:"")
        }
        
    }
    
    // sliding all tiles - the "doots"
    
    func dootTiles(dir: MoveDirection)
    {
        // for each puzzle tile, check if they should move and how far.
        // construct the movement action in direction dir
        // don't move tiles that are already moving until they stop.
        
        var x, y : Int
        let maxX = dimension - 1;
        let maxY = dimension - 1;
        var curLoc = Coordinate(x: 0,y: 0)
        
        // these sentinels indicate whether we need to check for grouped colors and/or if we need to delete tiles and recurse
        // should this be a switch?

        
        
        if dir == MoveDirection.up
        {
            
            for (y=maxY; y>=0; y -= 1) {
                for (x=0; x<=maxX; x += 1) {
                    curLoc = Coordinate(x: x,y: y);
                    if checkTileCanMove(curLoc)
                    {
                        createTileMove(curLoc, dir: dir)
                    }
                }
            };
        } else if dir == MoveDirection.down {
            for (y=0; y<=maxY; y += 1) {
                for (x=maxX; x>=0; x -= 1) {
                    curLoc = Coordinate(x: x,y: y);
                    if checkTileCanMove(curLoc)
                    {
                        createTileMove(curLoc, dir: dir)
                    }
                }
            };
        } else if dir == MoveDirection.left {
            for (y=maxY; y>=0; y -= 1) {
                for (x=0; x<=maxX; x += 1) {
                    curLoc = Coordinate(x: x,y: y)
                    if checkTileCanMove(curLoc)
                    {
                        createTileMove(curLoc, dir: dir)
                    }
                }
            };
        } else if dir == MoveDirection.right {
            for (x=maxX; x>=0; x -= 1) {
                for (y=0; y<=maxY; y += 1) {
                    curLoc = Coordinate(x: x,y: y);
                    if checkTileCanMove(curLoc)
                    {
                        createTileMove(curLoc, dir: dir)
                    }
                }
            };
        }
        
        // mark the movement subturn
        delegate.addSubturn()
        
        // if we moved anything, check for connected components
        if(tileMapDirty)
        {
            
            if connectComponents()
            {
                // remove deleted tiles, mark the subturn
                emptyMarkedTiles()
                delegate.addSubturn()
                // repeat the move to collapse, until connectComponents returns false
                dootTiles(dir)
            }
            
        }
        
        
        // tell the delegate if the puzzle is solved
        if isPuzzleSolved() && !self.solved
        {
            delegate.endPuzzle()
            self.solved = true
        }
        
        // the endTurn signal is sent from the Scene in the swipe selector
    
    }
    
    func checkTileCanMove(inLoc: Coordinate) -> Bool
    {
        let curType = getTileType(inLoc);
        let moving = isTileMoving(inLoc);
        let delMar = checkTileForDelete(inLoc);
        
        // if the tile is a color tile, isn't already moving, and isn't about to be deleted, we can move
        return ( curType == TileType.colorTile && !moving && !delMar )
        
    }
    
    func createTileMove (inLoc: Coordinate, dir: MoveDirection) ->Bool
    {
        // create the actions for the tile moving in the specified direction and schedule/run them
        // accommodating more complicated and special tile actions here may require creating stacks of actions
        // before wrapping them in a sequence and sending them to runAction.
        // For now the simple construction below will suffice.
        
        var stopped = false;
        var currentPos = Coordinate(x:inLoc.x, y:inLoc.y);
        let oldPos = inLoc;
        var nextPos : Coordinate
        var numTilesInMove = 0
        
        while !stopped
        {
            nextPos = getAdjacentCoord(currentPos, direction: dir)
            
            if !isLocInRange(nextPos) || isTileStop(nextPos) || isLocOccupied(nextPos)
            {
                stopped = true;
                continue
            } else {
                currentPos = nextPos // otherwise we move ahead
                numTilesInMove += 1;
            }
            
        }
        
        // if we move nothing, let the caller know and leave
        // check the delete status first in case adjacent tile moves have marked the tile
        
        if (numTilesInMove==0)
        { return false }
        
        // else, we move
        // tell the delegate to move from oldPos to currentPos
        moveTile(oldPos, toLoc: currentPos);
        
        // the moving flag is to prevent events from triggering a movement on a new thread before this is done
        // find a better way - queueing commands may do it, but may lead to unexpected behavior for the user
        //setTileMoving(currentPos);
        
        // if we move anything
        tileMapDirty = true
        
        // let the caller know we moved something
        return true;
        
    }
    
    func getAdjacentCoord(inCoord: Coordinate, direction: MoveDirection) -> Coordinate
    {
        // calculate the map coordinates of the next tile towards the specified direction
        let xIncrement = 1;
        let yIncrement = 1;
        
        var newPos : Coordinate
        
        switch (direction) {
            case MoveDirection.up:
                newPos = Coordinate(x: inCoord.x, y: inCoord.y+yIncrement)
            break;
            
            case MoveDirection.down:
                newPos = Coordinate(x: inCoord.x, y: inCoord.y-yIncrement)
            break;
            
            case MoveDirection.left:
                newPos = Coordinate(x: inCoord.x-xIncrement, y: inCoord.y)
            break;
            
            case MoveDirection.right:
                newPos = Coordinate(x: inCoord.x+xIncrement, y: inCoord.y)
            break;
            
            case .none:
                newPos = Coordinate(x: inCoord.x, y: inCoord.y)
        }
        
        return newPos;
    }



    // disjoint set methods
    func makeSet(loc: Coordinate) ->Tile?
    {
        if isLocInRange(loc)==false { return nil }
        
        let curTile = tileMap[loc.x, loc.y]
        curTile.parent = nil
        curTile.rank = 0
        
        return curTile
    }
    
    func findSet(inout node: Tile) ->Tile
    {
       // var tempTile : Tile?
        var root = node
        
        // get down to the root
        while root.parent != nil
        {
            root = root.parent!
        }
        
        // strictly this tree shortening isn't needed, it is an optimization. But Swift switching from var to inout broke it
        // TODO: Figure out why this broke and decide if it is needed. It is breaking trees and leaving tiles all over the place!
        // update the parent pointers
//        while node.parent != nil
//        {
//            tempTile = node.parent
//            node.parent = root
//            node = tempTile!
//        }
        return root
    }
    
    func findSetID(node: Tile) -> Int
    {
        // make a local copy
        var tempTile = Tile(copy: node)
        
        let tileOut = findSet(&tempTile)
        
        return tileOut.tileID
    }
    
    func unionSets(setA: Tile, setB: Tile)
    {
        if setA.rank > setB.rank
        {
            setB.parent = setA
        } else if setB.rank > setA.rank
        {
            setA.parent = setB
        } else
        {
            setB.parent = setA
            setA.rank += 1
        }
    }
    
    func connectComponents() -> Bool
    {
        var occupiedTiles = [Coordinate]()
        var result = false
        var localID = 1
        
        if numTiles<1 {return result} // map is empty
        
        for i in 0..<tileMap.dimension
        {
            for j in 0..<tileMap.dimension
            {
                if tileMap[i, j].type == TileType.colorTile
                {
                    let curCoord = Coordinate(x: i,y: j)
                    makeSet(curCoord)
                    occupiedTiles.append(curCoord)
                    
                    tileMap[i,j].tileID = localID
                    localID += 1
                }
            }
        }
        
        // for each occupied tile, check neighbors for color
        // push them onto the stack for grouping
        
        var x = 0 ; var y = 0;
        var tileColor = Color.kNoColor
        //var tileRank = 0
        var upColor, dwnColor, leftColor, rightColor: Color?
        rightColor = Color.kNoColor; upColor = Color.kNoColor; dwnColor = Color.kNoColor; leftColor = Color.kNoColor
        
        var neighbors = [Tile]()
        
        for loc in occupiedTiles
        {
            
            x = loc.x; y = loc.y;
            
            tileColor = getTileColor(loc)
            //tileRank = getTileRank(loc)
            
            // gather adjacent tiles
            
            if isLocInRange(x+1, y: y)
            {
                rightColor = tileMap[x+1, y].color
            } else { rightColor = Color.kNoColor }
            
            if isLocInRange(x-1, y: y)
            {
                leftColor = tileMap[x-1, y].color
            } else { leftColor = Color.kNoColor }
            
            if isLocInRange(x, y: y+1)
            {
                upColor = tileMap[x, y+1].color
            } else { upColor = Color.kNoColor }
            
            if isLocInRange(x, y: y-1)
            {
                dwnColor = tileMap[x, y-1].color
            } else { dwnColor = Color.kNoColor }
            
            if tileColor != Color.kNoColor
            {
                // find all connected neighbors not already merged into the same group, set them aside
                if (tileColor == leftColor)
                {
                    neighbors.append(tileMap[x-1, y])
                    
                } else if (tileColor == dwnColor)
                {
                    neighbors.append(tileMap[x, y-1]);
                    
                } else if (tileColor == rightColor)
                {
                    neighbors.append(tileMap[x+1, y]);
                    
                } else if (tileColor == upColor)
                {
                    neighbors.append(tileMap[x, y+1]);
                }
            }
            
            // the second pass
            // merge all the neighbors we pushed back, if we have any
            if (neighbors.count>0) {

                for item in neighbors
                {
                    unionSets(tileMap[loc.x, loc.y], setB: item)
                    
                    // if we merge any tiles, we need to delete - mark the group's parent
                    findSet(&tileMap[loc.x, loc.y]).markedForDelete = true
                    
                    // if this is the 1 and only time this loc is scanned, and is the parent
                    // findSet may return nil and this parent will not get marked
                    // redundant in most cases
                    // is findSet broken in this case?
                    tileMap[loc.x, loc.y].markedForDelete = true
                    
                    
                    // mark this tile as well
                    item.markedForDelete = true
                    
                    if result != true { result=true }
                }
            }
            
            // clear the neighbors
            neighbors.removeAll()
        }
        
        occupiedTiles.removeAll()
        
        return result
    }
    
    func emptyMarkedTiles()
    {
        // delete all marked tiles and notify delegate
        for i in 0..<tileMap.dimension
        {
            for j in 0..<tileMap.dimension
            {
                if tileMap[i, j].markedForDelete == true
                {
                    //emptyTile(i, y:j)
                    deleteTile(Coordinate(x: i,y: j))
                }
            }
        }
    }
    
    func clearMap()
    {
        tileMap.setAll(Tile(initType: TileType.nullTile, initColor: Color.kNoColor))
    }
        
}
