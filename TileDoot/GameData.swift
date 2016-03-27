//
//  GameData.swift
//  TileDoot
//
//  Created by Garry Kling on 3/24/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation

// this is data that is passed around between Scene objects for more or less global access

enum progressType : Int
{
    case none=0
    case some, complete
}

struct GameData
{
    // audio settings
    var sfxEnabled = true
    var musicEnabled = true
    
    // puzzle progress by puzzle number
    var progressDict = [Int : progressType]()
    
}