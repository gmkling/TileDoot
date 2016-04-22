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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the view.
        let skView = self.view as! SKView
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        //skView.ignoresSiblingOrder = true
        
        // create the scene sized to fit
        setupAudio()
        let scene = MainMenuScene(size: view!.bounds.size)
        scene.audioDelegate = audioEngine
        //let scene = SceneInvertTest(size: view!.bounds.size)
        
        skView.presentScene(scene)
        
    }

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

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func loadPuzzleData()
    {
        // load all of the Puzzle data here, pass it to the scenes
    }
    
    func setupAudio()
    {
        // should be set up by the init on TD_AudioPlayer
    }
}
