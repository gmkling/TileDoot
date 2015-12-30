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
    var coordinate : Coordinate
    var color: Color
    var rank : Int
    
    var isStop = false
    var markedForDelete: Bool = false
    var deleted: Bool = false
    var moveInProgress: Bool = false
        
    init(inCoord: Coordinate, inColor: Color)
    {
        self.coordinate = inCoord
        self.color = inColor
        self.rank = 0
        
        self.isStop = false
        self.markedForDelete = false
        self.deleted = false
        self.moveInProgress = false
    }
}

