//
//  GameViewController.swift
//  TileDoot
//
//  Created by Garry Kling on 12/28/15.
//  Copyright (c) 2015 Garry Kling. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController
{
    let audioEngine = TD_AudioPlayer()
    
    @IBOutlet var playButton: UIButton!
    @IBOutlet var label: UILabel!

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    @IBAction func playButtonPush(sender: UIButton)
    {
        audioEngine.playSFX(pileTap_key, typeKey: stereo_key)
        
//        let puzzleSetController = PuzzleSetViewController()
//        puzzleSetController.modalPresentationStyle = .FullScreen
//        puzzleSetController.modalTransitionStyle = .FlipHorizontal
//        self.showViewController(puzzleSetController, sender: self)
    }
    
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue)
    {
        audioEngine.playSFX(singleTap_key, typeKey: mono_key)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        audioEngine.playSFX(pileTap_key, typeKey: stereo_key)
        // give the destination controller a pointer to the audio engine
        if segue.identifier == "InfoSegue"
        {
            let destControl = segue.destinationViewController as! InfoViewController
            destControl.audioDelegate = self.audioEngine
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

}
