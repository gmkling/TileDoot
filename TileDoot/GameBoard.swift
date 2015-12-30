//
//  GameBoard.swift
//  TileDoot
//
//  Created by Garry Kling on 12/30/15.
//  Copyright © 2015 Garry Kling. All rights reserved.
//

import Foundation



class GameBoard {
    
    var dimension, numTiles, tileWidth, tileHeight: Int
    // was a std::vector<std::vector<Tile>> tileMap
    var tileMap = [[Tile?]]()
    
    // orig init is initMap which creates a new blank map
    init(initDimension: Int, tileW: Int, tileH: Int)
    {
        self.dimension = initDimension
        self.tileWidth = tileW
        self.tileHeight = tileH
        self.numTiles = initDimension*initDimension
        
        // the way I'm doing the Tiles bothers me
        tileMap.reserveCapacity(numTiles)
        
        // init the map arrays
        for var row=0; row<initDimension; row++ {
            for var col=0; col<initDimension; col++ {
                tileMap[row][col] = nil
            }
        }
    }
    
    func addTile(newTile: Tile, loc: Coordinate)
    {
        // if a Tile exists, we ignore this action
        if tileMap[loc.x][loc.y] == nil
        {
            tileMap[loc.x][loc.y] = newTile
            // issue the addTile command to the View delegate
        }
    }
    
    func deleteTile(loc: Coordinate)
    {
        if tileMap[loc.x][loc.y] != nil
        {
            tileMap[loc.x][loc.y] = nil
            // forward the cmd to the View delegate
        }
    }
    
//
//    func isLocInRange(loc: Coordinate) ->Bool {
//        
//    }
//    
//    func setTileOccupied(loc: Coordinate) {
//        
//    }
//    
//    func setTileNotOccupied(loc: Coordinate) {
//        
//    }
//    
//    func isTileOccupied(loc: Coordinate) ->Bool {
//        
//    }
//    
//    //    func setSpriteForTile(Vec2 loc, Sprite * newSprite);
//    //    Sprite * getSpriteForTile(Vec2 loc);
//    
//    func setTileStop(loc: Coordinate) {
//        
//    }
//    
//    func setTileNotStop(loc: Coordinate) {
//        
//    }
//    
//    func isTileStop(loc: Coordinate) ->Bool {
//        
//    }
//    
//    func setTileColor(loc: Coordinate, color: Color) {
//        
//    }
//    
//    func clearTileColor(loc: Coordinate) {
//        
//    }
//    
//    func getTileColor(loc: Coordinate) ->Color {
//        
//    }
//    
//    func setTileMoving(loc: Coordinate) {
//        
//    }
//    
//    func setTileNotMoving(loc: Coordinate) {
//        
//    }
//    
//    func isTileMoving(loc: Coordinate) ->Bool {
//        
//    }
//    
//    func setTile(loc: Coordinate, occupy: Bool, stop: Bool) {
//        
//    }
//    
//    // utility
//    func moveTile(fromLoc: Coordinate, toLoc: Coordinate) {
//        
//    }
//    
//    func copyTile(fromLoc: Coordinate, toLoc: Coordinate) {
//        
//    }
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
