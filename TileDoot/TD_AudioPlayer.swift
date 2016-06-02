//
//  TD_AudioPlayer.swift
//  TileDoot
//
//  Created by Garry Kling on 3/31/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import Foundation
import AVFoundation

protocol SoundPlayer
{
    func playSFX(sfxKey: String, typeKey: String)
    func playMusic(musicKey: String)
    func muteSFX()
    func unmuteSFX()
    func muteMusic()
    func unmuteMusic()
}

let mono_key = "MONO_FILE"
let stereo_key = "STEREO_FILE"
let loud_key = "LOUD_FILE"

let singleTap_key = "ST_SFX"
let pileTap_key = "PT_SFX"
let woodSlide_key = "WS_SFX"
let smallFall_key = "SF_SFX"
let catch_key = "CT_SFX"



class TD_AudioPlayer : SoundPlayer
{    
    var sfxStatus : Bool
    var musicStatus : Bool
    
    // sound arrays
    var stSounds = [AVAudioPlayer()]
    var ptSounds = [AVAudioPlayer()]
    var wsLRSounds = [AVAudioPlayer()]
    var wsRLSounds = [AVAudioPlayer()]
    var gfSounds = [AVAudioPlayer()]
    var catchSounds = [AVAudioPlayer()]
    
    var sfxDict : [String : [AVAudioPlayer]]
    
    init()
    {
        // load defaults
        let defPref = NSUserDefaults.standardUserDefaults()
        sfxStatus = defPref.boolForKey(sfx_key)
        musicStatus = defPref.boolForKey(music_key)
        
        // initiate the audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
            
        } catch {
            print(error)
        }
        
        sfxDict = [:]
        
        // load sounds for game and music
        self.loadSFX()
        self.loadMusic()
        
    }
    
    func muteSFX()
    {
        sfxStatus = false
        
        let defPref = NSUserDefaults.standardUserDefaults()
        defPref.setBool(sfxStatus, forKey: sfx_key)
        
    }
    
    func unmuteSFX()
    {
        sfxStatus = true
        
        let defPref = NSUserDefaults.standardUserDefaults()
        defPref.setBool(sfxStatus, forKey: sfx_key)
    }
    
    func muteMusic()
    {
        musicStatus = false
        
        let defPref = NSUserDefaults.standardUserDefaults()
        defPref.setBool(musicStatus, forKey: music_key)
    }
    
    func unmuteMusic()
    {
        musicStatus = true
        
        let defPref = NSUserDefaults.standardUserDefaults()
        defPref.setBool(musicStatus, forKey: music_key)
    }
    
    func loadMusic()
    {
        // load that music chief
    }
    
    func loadSFX()
    {
        
        do {
            // wish list - A better way to manage content without changing code
            let monoStr = "_Mono"
            let stereoStr = "_Stereo"
            let aifStr = ".aiff"

            // single tap
            let stPrefix = "SingleTap"
            let nST = 8
            
            stSounds.removeAtIndex(0)
            for i in 1...nST
            {
                let fileCur = stPrefix+monoStr+String(i)+aifStr
                let urlpath = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(fileCur, ofType: nil)!)
                try stSounds.append(AVAudioPlayer(contentsOfURL: urlpath))
            }
            
            sfxDict[singleTap_key] = stSounds
                
            // pile tap
            let ptPrefix = "PileTap"
            let nPT = 8
            
            ptSounds.removeAtIndex(0)
            for i in 1...nPT
            {
                let fileCur = ptPrefix+monoStr+String(i)+aifStr
                let urlpath = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(fileCur, ofType: nil)!)
                try ptSounds.append(AVAudioPlayer(contentsOfURL: urlpath))
            }
            
            sfxDict[pileTap_key] = ptSounds
            
            // wood slide
            let lr = "LR_"
            let rl = "RL_"
            let wsPrefix = "WoodSlide"
            let nLRS = 6
            let nRLS = 4
            
            wsLRSounds.removeAtIndex(0)
            for i in 1...nLRS
            {
                let fileCur = lr+wsPrefix+stereoStr+String(i)+aifStr
                let urlpath = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(fileCur, ofType: nil)!)
                try wsLRSounds.append(AVAudioPlayer(contentsOfURL: urlpath))
            }
            
            wsRLSounds.removeAtIndex(0)
            for i in 1...nRLS
            {
                let fileCur = rl+wsPrefix+stereoStr+String(i)+aifStr
                let urlpath = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(fileCur, ofType: nil)!)
                try wsRLSounds.append(AVAudioPlayer(contentsOfURL: urlpath))
            }
            
            // Need to figure out how to use the LR vs RL versions
            // Only using LR for now
            sfxDict[woodSlide_key] = wsLRSounds
            
                
            // granite fall
            let gfPrefix = "SmallFall"
            let nGF = 8
            
            gfSounds.removeAtIndex(0)
            for i in 1...nGF
            {
                let fileCur = gfPrefix+stereoStr+String(i)+aifStr
                let urlpath = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(fileCur, ofType: nil)!)
                try gfSounds.append(AVAudioPlayer(contentsOfURL: urlpath))
            }
            
            sfxDict[smallFall_key] = gfSounds
            
            // catch
            let catPrefix = "Catch"
            let nCatch = 6
            
            catchSounds.removeAtIndex(0)
            for i in 1...nCatch
            {
                let fileCur = catPrefix+monoStr+String(i)+aifStr
                let urlpath = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(fileCur, ofType: nil)!)
                try catchSounds.append(AVAudioPlayer(contentsOfURL: urlpath))
            }
            
            sfxDict[catch_key] = catchSounds
                
            } catch {
                print("Error loading SFX files")
                print(error)
            }
        
        
    }
    
    func playSFX(sfxKey: String, typeKey: String)
    {
        // don't play if we are muted
        if sfxStatus==false { return }
        
        if let sound = sfxDict[sfxKey]
        {
            sound.randomItem().play()
        } else {
            print("Error playing sfx: \(sfxKey)")
        }
    }
    
    func playMusic(musicKey: String)
    {
        
    }
}
