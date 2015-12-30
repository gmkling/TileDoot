//
//  GameBoard.swift
//  TileDoot
//
//  Created by Garry Kling on 12/30/15.
//  Copyright © 2015 Garry Kling. All rights reserved.
//

import Foundation



class GameBoard {
    
    var sizeX, sizeY, numTiles, tileWidth, tileHeight: Int
    // was a std::vector<std::vector<Tile>> tileMap
    var tileMap = [[Tile?]]()
    
    // orig init is initMap which creates a new blank map
    init(xSize: Int, ySize: Int, tileW: Int, tileH: Int)
    {
        self.sizeX = xSize
        self.sizeY = ySize
        self.tileWidth = tileW
        self.tileHeight = tileH
        self.numTiles = xSize*ySize
        
        // the way I'm doing the Tiles bothers me
        tileMap.reserveCapacity(numTiles)
        
        // init the map arrays
        for var row=0; row<xSize; row++ {
            for var col=0; col<ySize; col++ {
                tileMap[row][col] = Tile(inCoord: Coordinate.init(x: row, y: col), inColor: Color.kNoColor)
            }
        }
    }
    
//    func addTile(loc: Coordinate){
//        
//    }
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
