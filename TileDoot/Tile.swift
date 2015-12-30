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

