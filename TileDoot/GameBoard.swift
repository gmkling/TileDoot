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
    var tileMap = TileBoard?()
    
    // orig init is initMap which creates a new blank map
    init(initDimension: Int)
    {
        self.dimension = initDimension
        self.numTiles = initDimension*initDimension
        
        tileMap = TileBoard(dim: initDimension)
    }
    
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
        return !((loc.x < 0 || loc.y < 0) && (loc.x > dimension || loc.y > dimension))
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
    
    // color

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
    
    // copy, move, clear, delete
    
    // move in this case is instantaneous, 
    // the above "moveInProgress" property accounts for the time a tile moves
    // across the screen during an animated move
    func moveTile(fromLoc: Coordinate, toLoc: Coordinate)
    {
        let fromTile = tileMap![fromLoc.x, fromLoc.y]
        var toTile = tileMap![toLoc.x, toLoc.y]
        
        toTile.color = fromTile.color
        toTile.type = fromTile.type
        toTile.isStop = fromTile.isStop
        
        // needed?
        toTile.markedForDelete = fromTile.markedForDelete
        
        // null out the source
        self.deleteTile(fromLoc)
    }
    
    func copyTile(fromLoc: Coordinate, toLoc: Coordinate)
    {
        let fromTile = tileMap![fromLoc.x, fromLoc.y]
        var toTile = tileMap![toLoc.x, toLoc.y]
        
        toTile.color = fromTile.color
        toTile.type = fromTile.type
        toTile.isStop = fromTile.isStop
        
        // needed?
        toTile.markedForDelete = fromTile.markedForDelete
        
    }
//
//    func clearTile(loc: Coordinate) {
//        
//    }
//    
//    func checkTileToDeleteMark(loc: Coordinate) ->Bool {
//        
//    }
//    
//    func setAsDeleted(loc: Coordinate) {
//        
//    }
//    
//    func wasTileDeleted(loc: Coordinate) ->Bool {
//        
//    }
//    
//    func convertPxToCoord(loc: Coordinate) ->Coordinate {
//        
//    }
//    
//    func printState() {
//        
//    }
//    
//    // disjoint set methods
//    func makeSet(loc: Coordinate) ->Tile {
//        
//    }
//    
//    func findSet(loc: Tile) ->Tile {
//        
//    }
//    
//    func unionSets(setA: Tile, setB: Tile) {
//        
//    }
//    
//    func connectComponents() {
//        
//    }
//    
//    func setMapSize(x: Int, y: Int) ->Bool {
//        
//    }
//    
//    func mapValid() ->Bool {
//        
//    }
//    
//    func clearMap() {
//        
//    }
//    
//    func createTile(loc: Coordinate, occupy: Bool, stop: Bool) ->Tile {
//        
//    }
//    
}
