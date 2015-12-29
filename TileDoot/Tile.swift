//
//  Tile.swift
//  TileDoot
//
//  Created by Garry Kling on 12/28/15.
//  Copyright © 2015 Garry Kling. All rights reserved.
//

import Foundation
import CoreGraphics

enum Color: Int {
    case kNoColor=1
    case kBlue, kRed, kGreen, kYellow, kOrange
}

struct Coordinate {
    var x: Int
    var y: Int
}

class Tile {
    var parent: Tile?
    // hmmm 
    //var sprite: SKSpriteNode
    
    var coordinates : Coordinate
    var color: Color
    var rank : Int
    
    var occupied = false
    var isStop = false
    var markedForDelete: Bool = false
    var deleted: Bool = false
    var moveInProgress: Bool = false
    
    init(inCoordinates: Coordinate, inColor: Color)
    {
        self.coordinates = inCoordinates
        self.color = inColor
        self.rank = 0
        
        self.occupied = false
        self.isStop = false
        self.markedForDelete = false
        self.deleted = false
        self.moveInProgress = false
    }
}

class MapState {
    
    var sizeX, sizeY, numTiles, tileWidth, tileHeight: Int
    
    // orig init is initMap which creates a new blank map
    init(xSize: Int, ySize: Int, tileW: Int, tileH: Int)
    {
        self.sizeX = xSize
        self.sizeY = ySize
        self.tileWidth = tileW
        self.tileHeight = tileH
        self.numTiles = xSize*ySize
        
        // the way I'm doing the Tiles bothers me
        mapState.reserveCapacity(numTiles)
        
        // init the map arrays
        for var row=0; row<xSize; row++ {
            for var col=0; col<ySize; col++ {
                mapState[row][col] = Tile(inCoordinates: Coordinate.init(x: row, y: col), inColor: Color.kNoColor)
            }
        }
    }
    
    func addTile(loc: Coordinate){
        
    }
    
    func isLocInRange(loc: Coordinate) ->Bool {
        
    }
    
    func setTileOccupied(loc: Coordinate) {
        
    }
    
    func setTileNotOccupied(loc: Coordinate) {
    
    }
    
    func isTileOccupied(loc: Coordinate) ->Bool {
        
    }
    
//    func setSpriteForTile(Vec2 loc, Sprite * newSprite);
//    Sprite * getSpriteForTile(Vec2 loc);
    
    func setTileStop(loc: Coordinate) {
        
    }
    
    func setTileNotStop(loc: Coordinate) {
        
    }
    
    func isTileStop(loc: Coordinate) ->Bool {
        
    }
    
    func setTileColor(loc: Coordinate, color: Color) {
        
    }
    
    func clearTileColor(loc: Coordinate) {
        
    }
    
    func getTileColor(loc: Coordinate) ->Color {
        
    }
    
    func setTileMoving(loc: Coordinate) {
        
    }
    
    func setTileNotMoving(loc: Coordinate) {
        
    }
    
    func isTileMoving(loc: Coordinate) ->Bool {
        
    }
    
    func setTile(loc: Coordinate, occupy: Bool, stop: Bool) {
        
    }
    
    // utility
    func moveTile(fromLoc: Coordinate, toLoc: Coordinate) {
        
    }
    
    func copyTile(fromLoc: Coordinate, toLoc: Coordinate) {
        
    }
    
    func clearTile(loc: Coordinate) {
        
    }
    
    func checkTileToDeleteMark(loc: Coordinate) ->Bool {
        
    }
    
    func setAsDeleted(loc: Coordinate) {
        
    }
    
    func wasTileDeleted(loc: Coordinate) ->Bool {
        
    }
    
    func convertPxToCoord(loc: CGPoint) ->Coordinate {
        
    }
    
    func printState() {
        
    }
    
    // disjoint set methods
    func makeSet(loc: Coordinate) ->Tile {
        
    }
    
    func findSet(loc: Tile) ->Tile {
        
    }
    
    func unionSets(setA: Tile, setB: Tile) {
        
    }
    
    func connectComponents() {
        
    }
    
    func setMapSize(x: Int, y: Int) ->Bool {
        
    }
    
    func mapValid() ->Bool {
        
    }
    
    func clearMap() {
        
    }
    
    func createTile(loc: Coordinate, occupy: Bool, stop: Bool) ->Tile {
        
    }
    
    // was a std::vector<std::vector<Tile>> mapState
    var mapState = [[Tile?]]()
    
}