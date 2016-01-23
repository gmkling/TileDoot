//
//  Tile.swift
//  TileDoot
//
//  Created by Garry Kling on 12/28/15.
//  Copyright © 2015 Garry Kling. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

// my tile colors. 
// needs more sophisticated storage so that I can swap out tile sets
let blueTileColor = UIColor(red: 36.0/255.0, green: 28.0/255.0, blue: 113.0/255.0, alpha: 0.0)
let redTileColor = UIColor(red: 239.0/255.0, green: 70.0/255.0, blue: 39.0/255.0, alpha: 0.0)
let greenTileColor = UIColor(red: 144.0/255.0, green: 172.0/255.0, blue: 95.0/255.0, alpha: 0.0)
let lightGreenTileColor = UIColor(red: 191.0/255.0, green: 199.0/255.0, blue: 152.0/255.0, alpha: 0.0)
let yellowTileColor = UIColor(red: 226.0/255.0, green: 198.0/255.0, blue: 72.0/255.0, alpha: 0.0)
let orangeTileColor = UIColor(red: 249.0/255.0, green: 171.0/255.0, blue: 73.0/255.0, alpha: 0.0)
let purpleTileColor = UIColor(red: 164.0/255.0, green: 74.0/255.0, blue: 135.0/255.0, alpha: 0.0)

let colorBank = [blueTileColor,
    redTileColor,
    greenTileColor,
    lightGreenTileColor,
    yellowTileColor,
    orangeTileColor,
    purpleTileColor]

// I don't like that I have to reference type when I use these: Color.kRed - is there something better for this?
enum Color: Int {
    case kNoColor=1
    case kBlue, kRed, kGreen, kLightGreen, kYellow, kOrange, kLightOrange, kPurple
}

// this is a var so we can customize/add colors
var colorChars: [Color : Character] = [
    Color.kNoColor : "X",
    Color.kBlue : "B",
    Color.kRed : "R",
    Color.kGreen : "G",
    Color.kLightGreen : "g",
    Color.kYellow : "Y",
    Color.kOrange : "O",
    Color.kLightOrange : "o",
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

var tileNames = [
    "Blue1_test.png",
    "Blue2_test.png",
    "Blue3_test.png",
    "Blue4_test.png",
    "Blue5_test.png",
    "Red1_test.png",
    "Red2_test.png",
    "Red3_test.png",
    "Red4_test.png",
    "Red5_test.png",
    "Yellow1_test.png",
    "Yellow2_test.png",
    "Yellow3_test.png",
    "Yellow4_test.png",
    "Yellow5_test.png",
    "Orange1_test.png",
    "Orange2_test.png",
    "Orange3_test.png",
    "Orange4_test.png",
    "Orange5_test.png",
    "LGreen1_test.png",
    "LGreen2_test.png",
    "LGreen3_test.png",
    "LGreen4_test.png",
    "LGreen5_test.png",
    "DGreen1_test.png",
    "DGreen2_test.png",
    "DGreen3_test.png",
    "DGreen4_test.png",
    "DGreen5_test.png",
    "Purple1_test.png",
    "Purple2_test.png",
    "Purple3_test.png",
    "Purple4_test.png",
    "Purple5_test.png"
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
