//
//  GameBoard.swift
//  TileDoot
//
//  Created by Garry Kling on 12/30/15.
//  Copyright © 2015 Garry Kling. All rights reserved.
//

import Foundation



class GameBoard {
    
    var dimension, numTiles: Int
    
    // was a std::vector<std::vector<Tile>> tileMap
    // we should really look at not making this an optional
    // it made sense when I was first learning, but I admit that might be false.
    // can it be declared empty and filled in later?
    var tileMap = TileBoard?()
    
    // orig init is initMap which creates a new blank map
    init(initDimension: Int)
    {
        self.dimension = initDimension
        self.numTiles = initDimension*initDimension
        
        tileMap = TileBoard(dim: initDimension)
    }
    
    
    // add/delete
    
    func addTile(newTile: Tile, loc: Coordinate)
    {
        // if it is a nullTile, overwrite it with the new one
        if tileMap?[loc.x, loc.y].type == TileType.nullTile
        {
            tileMap![loc.x, loc.y] = newTile
            // issue the addTile command to the View delegate
        }
        
    }
    
    func deleteTile(loc: Coordinate)
    {
        // insert a nullTile if one is not already there

        if tileMap?[loc.x, loc.y].type != TileType.nullTile
        {
            tileMap![loc.x, loc.y] = Tile(initType: TileType.nullTile, initColor: Color.kNoColor)
            // forward the cmd to the View delegate
        }
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
    
    // Occupied is implied by the presence of a non-null tile
    // this is not the same as a stop tile
 
    func isLocOccupied(loc: Coordinate) ->Bool
    {
        return tileMap![loc.x, loc.y].type != TileType.nullTile
    }

    // stop property
    
    func setTileStop(loc: Coordinate)
    {
        tileMap![loc.x, loc.y].isStop = true
    }

    func setTileNotStop(loc: Coordinate)
    {
        tileMap![loc.x, loc.y].isStop = false
    }

    func isTileStop(loc: Coordinate) ->Bool
    {
        return tileMap![loc.x, loc.y].isStop
    }
    
    // color - all need delegate notifs

    func setTileColor(loc: Coordinate, color: Color)
    {
        tileMap![loc.x, loc.y].color = color
    }
    
    func clearTileColor(loc: Coordinate)
    {
        tileMap![loc.x, loc.y].color = Color.kNoColor
    }
    
    func getTileColor(loc: Coordinate) ->Color
    {
        return tileMap![loc.x, loc.y].color
    }
    
    func setTileType(loc: Coordinate, newType: TileType)
    {
        tileMap![loc.x, loc.y].type = newType
    }
    
    func getTileType(loc: Coordinate) ->TileType
    {
        return tileMap![loc.x, loc.y].type
    }
    
    // moving tiles
    
    func setTileMoving(loc: Coordinate)
    {
        tileMap![loc.x, loc.y].moveInProgress = true
    }
    
    func setTileNotMoving(loc: Coordinate)
    {
        tileMap![loc.x, loc.y].moveInProgress = false
    }
    
    func isTileMoving(loc: Coordinate) ->Bool
    {
        return tileMap![loc.x, loc.y].moveInProgress
    }
    
    // copy, move
    
    // move in this case is instantaneous, 
    // the above "moveInProgress" property accounts for the time a tile moves
    // across the screen during an animated move
    func moveTile(fromLoc: Coordinate, toLoc: Coordinate)
    {
        let fromTile = tileMap![fromLoc.x, fromLoc.y]
        let toTile = tileMap![toLoc.x, toLoc.y]
        
        toTile.color = fromTile.color
        toTile.type = fromTile.type
        toTile.isStop = fromTile.isStop
        
        // needed?
        toTile.markedForDelete = fromTile.markedForDelete
        
        // null out the source
        self.deleteTile(fromLoc)
        
        // notify delegate of move
    }
    
    func copyTile(fromLoc: Coordinate, toLoc: Coordinate)
    {
        let fromTile = tileMap![fromLoc.x, fromLoc.y]
        let toTile = tileMap![toLoc.x, toLoc.y]
        
        toTile.color = fromTile.color
        toTile.type = fromTile.type
        toTile.isStop = fromTile.isStop
        
        // needed?
        toTile.markedForDelete = fromTile.markedForDelete
        // this method needs updated whenever the Tile class is changed
        // I don't like that, I need to find a better way
        
        // notify delegate of copy
    }
    
    // delete flag - game-driven
    
    func markTileForDelete(loc: Coordinate)
    {
        tileMap![loc.x, loc.y].markedForDelete = true
    }
    
    func checkTileForDelete(loc: Coordinate) ->Bool
    {
        return tileMap![loc.x, loc.y].markedForDelete
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
        return tileMap![loc.x, loc.y].rank
    }
    
    func getTile(loc: Coordinate) ->Tile?
    {
        if !isLocInRange(loc) { return nil }
        
        return tileMap?[loc.x, loc.y]
    }
    
    func initBoardFromString (boardString: String) ->Bool
    {
        var curTile : Character
        var i = 0
        var boardSize = boardString.characters.count
        
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
            } else if let curColor = self.getColorForChar(curTile)
            {
                // this is a color tile
                newTile = Tile(initType: TileType.colorTile, initColor: curColor)
            }
            
            // unwrap the index
            let curCol = i % self.dimension
            let curRow = (i-curCol)/self.dimension
            
            // insert the tile
            
            self.addTile(newTile, loc: Coordinate(x:curRow, y:curCol))
            
            i++
        }
        
        return true

    }
  
    func printBoardState()
    {
        var curLoc : Coordinate
        var curType : TileType
        
        for i in 0..<tileMap!.dimension {
            for j in 0..<tileMap!.dimension {
                curLoc = Coordinate(x: i,y: j)
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

    // disjoint set methods
    func makeSet(loc: Coordinate) ->Tile?
    {
        if isLocInRange(loc)==false { return nil }
        
        let curTile = tileMap![loc.x, loc.y]
        curTile.parent = nil
        curTile.rank = 0
        
        return curTile
    }
    
    func findSet(var node: Tile) ->Tile
    {
        var tempTile : Tile?
        var root = node
        
        // get down to the root
        while root.parent != nil
        {
            root = root.parent!
        }
        
        // update the parent pointers
        while node.parent != nil
        {
            tempTile = node.parent
            node.parent = root
            node = tempTile!
        }
        return root
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
            setA.rank++
        }
    }
    
    func connectComponents()
    {
        var occupiedTiles = [Coordinate]()
        
        if numTiles<1 {return} // map is empty
        
        for i in 0..<tileMap!.dimension
        {
            for j in 0..<tileMap!.dimension
            {
                if tileMap![i, j].type == TileType.colorTile
                {
                    let curCoord = Coordinate(x: i,y: j)
                    makeSet(curCoord)
                    occupiedTiles.append(curCoord)
                }
            }
        }
        
        // for each occupied tile, check neighbors for color
        // push them onto the stack for grouping
        
        var x = 0 ; var y = 0;
        var tileColor = Color.kNoColor
        var tileRank = 0
        var upColor, dwnColor, leftColor, rightColor: Color?
        rightColor = Color.kNoColor; upColor = Color.kNoColor; dwnColor = Color.kNoColor; leftColor = Color.kNoColor
        
        var neighbors = [Tile]()
        var tileLoc : Coordinate
        
        for loc in occupiedTiles
        {
            tileLoc = loc
            
            x = loc.x; y = loc.y;
            
            tileColor = getTileColor(loc)
            tileRank = getTileRank(loc)
            
            // checking adjacent tiles
            // bug will show up if we have an occupied tile in a corner ex. 0,0 ; 0,dim; dim,0; or dim,dim;
            // use protection
            if isLocInRange(x+1, y: y)
            {
                rightColor = tileMap![x+1, y].color
            } else { rightColor = Color.kNoColor }
            
            if isLocInRange(x-1, y: y)
            {
                leftColor = tileMap![x-1, y].color
            } else { leftColor = Color.kNoColor }
            
            if isLocInRange(x, y: y-1)
            {
                upColor = tileMap![x, y-1].color
            } else { leftColor = Color.kNoColor }
            
            if isLocInRange(x, y: y+1)
            {
                dwnColor = tileMap![x, y+1].color
            } else { dwnColor = Color.kNoColor }
            
            if tileColor != Color.kNoColor
            {
                // find all connected neighbors not already merged into the same group, set them aside
                if (tileColor == leftColor)
                {
                    neighbors.append(tileMap![x-1, y])
                    
                } else if (tileColor == dwnColor)
                {
                    neighbors.append(tileMap![x, y+1]);
                    
                } else if (tileColor == rightColor)
                {
                    neighbors.append(tileMap![x+1, y]);
                    
                } else if (tileColor == upColor)
                {
                    neighbors.append(tileMap![x, y-1]);
                }
            }
            
            // the second pass
            // merge all the neighbors we pushed back, if we have any
            if (neighbors.count>0) {

                for item in neighbors
                {
                    unionSets(tileMap![loc.x, loc.y], setB: item)
                    
                    // if we merge any tiles, we need to delete - mark the group's parent
                    findSet(tileMap![loc.x, loc.y]).markedForDelete = true
                    
                    // mark this tile as well
                    item.markedForDelete = true
                }
            }
            
            // clear the neighbors
            neighbors.removeAll()
        }
        
        occupiedTiles.removeAll()
        
        
    }
    
    func clearMap()
    {
        tileMap?.setAll(Tile(initType: TileType.nullTile, initColor: Color.kNoColor))
    }
        
}
