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

enum TileType: Int {
    case colorTile, barrierTile
}

struct Coordinate {
    var x: Int
    var y: Int
}

class Tile {
    
    var parent: Tile?
    var color: Color
    var type: TileType
    var rank : Int
    
    var isStop = false
    var markedForDelete: Bool = false
    var deleted: Bool = false
    var moveInProgress: Bool = false
        
    init(initType: TileType, initColor: Color)
    {
        self.color = initColor
        self.type = initType
        self.rank = 0
        
        self.isStop = false
        self.markedForDelete = false
        self.deleted = false
        self.moveInProgress = false
    }
    

}

