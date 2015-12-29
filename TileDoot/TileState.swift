//
//  TileState.swift
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

struct gridCoordinate {
    var x: Int
    var y: Int
}

class TileState {
    var parent: TileState?
    // hmmm 
    //var sprite: SKSpriteNode
    
    var coordinates : gridCoordinate
    var color: Color
    var rank : Int
    
    var occupied = false
    var isStop = false
    var markedForDelete: Bool = false
    var deleted: Bool = false
    var moveInProgress: Bool = false
    
    init(inCoordinates: gridCoordinate, inColor: Color)
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
                mapState[row][col] = TileState(inCoordinates: gridCoordinate.init(x: row, y: col), inColor: Color.kNoColor)
            }
        }
    }
    
    func addTile(loc: gridCoordinate){
        
    }
    
    func isLocInRange(loc: gridCoordinate) ->Bool {
        
    }
    
    func setTileOccupied(loc: gridCoordinate) {
        
    }
    
    func setTileNotOccupied(loc: gridCoordinate) {
    
    }
    
    func isTileOccupied(loc: gridCoordinate) ->Bool {
        
    }
    
//    func setSpriteForTile(Vec2 loc, Sprite * newSprite);
//    Sprite * getSpriteForTile(Vec2 loc);
    
    func setTileStop(loc: gridCoordinate) {
        
    }
    
    func setTileNotStop(loc: gridCoordinate) {
        
    }
    
    func isTileStop(loc: gridCoordinate) ->Bool {
        
    }
    
    func setTileColor(loc: gridCoordinate, color: Color) {
        
    }
    
    func clearTileColor(loc: gridCoordinate) {
        
    }
    
    func getTileColor(loc: gridCoordinate) ->Color {
        
    }
    
    func setTileMoving(loc: gridCoordinate) {
        
    }
    
    func setTileNotMoving(loc: gridCoordinate) {
        
    }
    
    func isTileMoving(loc: gridCoordinate) ->Bool {
        
    }
    
    func setTileState(loc: gridCoordinate, occupy: Bool, stop: Bool) {
        
    }
    
    // utility
    func moveTileState(fromLoc: gridCoordinate, toLoc: gridCoordinate) {
        
    }
    
    func copyTileState(fromLoc: gridCoordinate, toLoc: gridCoordinate) {
        
    }
    
    func clearTileState(loc: gridCoordinate) {
        
    }
    
    func checkTileToDeleteMark(loc: gridCoordinate) ->Bool {
        
    }
    
    func setAsDeleted(loc: gridCoordinate) {
        
    }
    
    func wasTileDeleted(loc: gridCoordinate) ->Bool {
        
    }
    
    func convertPxToCoord(loc: CGPoint) ->gridCoordinate {
        
    }
    
    func printState() {
        
    }
    
    // disjoint set methods
    func makeSet(loc: gridCoordinate) ->TileState {
        
    }
    
    func findSet(loc: TileState) ->TileState {
        
    }
    
    func unionSets(setA: TileState, setB: TileState) {
        
    }
    
    func connectComponents() {
        
    }
    
    func setMapSize(x: Int, y: Int) ->Bool {
        
    }
    
    func mapValid() ->Bool {
        
    }
    
    func clearMap() {
        
    }
    
    func createTileState(loc: gridCoordinate, occupy: Bool, stop: Bool) ->TileState {
        
    }
    
    // was a std::vector<std::vector<TileState>> mapState
    var mapState = [[TileState?]]()
    
}