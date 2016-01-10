//
//  Tile.swift
//  TileDoot
//
//  Created by Garry Kling on 12/28/15.
//  Copyright © 2015 Garry Kling. All rights reserved.
//

import Foundation
import CoreGraphics

// I don't like that I have to reference type when I use these: Color.kRed
// What am I missing?
enum Color: Int {
    case kNoColor=1
    case kBlue, kRed, kGreen, kYellow, kOrange, kPurple
}

// this is a var so we can customize/add colors
var colorChars: [Color : Character] = [
    Color.kNoColor : "X",
    Color.kBlue : "B",
    Color.kRed : "R",
    Color.kGreen : "G",
    Color.kYellow : "Y",
    Color.kOrange : "O",
    Color.kPurple : "P"
]


// should this be changed to bitfield version - struct?
// Or put another way, can a Tile be more that one type?
enum TileType: Int {
    case nullTile = 0
    case colorTile, barrierTile, emptyTile
}

var typeChars : [TileType : Character] = [
    TileType.nullTile : "0",
    TileType.colorTile : "-",
    TileType.barrierTile : "*",
    TileType.emptyTile : "."
]

// to use these Dictionaries to parse input, extend Dictionary to return the first key for a given value

extension Dictionary where Value: Equatable {
    
    func someKeyFor(value: Value) -> Key? {
        
        guard let index = indexOf({ $0.1 == value }) else {
            return nil
        }
        
        return self[index].0
        
    }
    
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
    var moveInProgress: Bool = false
        
    init(initType: TileType, initColor: Color)
    {
        self.color = initColor
        self.type = initType
        self.rank = 0
        
        self.isStop = false
        self.markedForDelete = false
        self.moveInProgress = false
    }

}

// overrides for Tiles

func == (left: Tile, right: Tile) -> Bool
{
    // we only test properties, not state
    if left.color != right.color { return false }
    if left.type != right.type { return false }
    if left.isStop != right.isStop { return false }
    
    return true
}

func != (left: Tile, right: Tile) -> Bool
{
    return !(left == right)
}

class TileBoard {
    var dimension: Int = 0
    var board = [Tile]()
    
    init(dim: Int) {
        let nullTile = Tile(initType: TileType.nullTile, initColor: Color.kNoColor)
        self.dimension = dim
        self.board = [Tile](count:dim*dim, repeatedValue:nullTile)
    }
    
    subscript(row: Int, col: Int) -> Tile {
        get {
            assert(row >= 0 && row < dimension)
            assert(col >= 0 && col < dimension)
            return board[row*dimension + col]
        }
        set {
            assert(row >= 0 && row < dimension)
            assert(col >= 0 && col < dimension)
            board[row*dimension + col] = newValue
        }
    }
    
    func setAll(item: Tile) {
        for i in 0..<dimension {
            for j in 0..<dimension {
                self[i, j] = item
            }
        }
    }
}
