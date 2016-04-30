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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the view.
        let skView = self.view as! SKView
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        //skView.ignoresSiblingOrder = true
        
        // create the scene sized to fit
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

    @IBAction func playButtonPush(sender: UIButton) {
        
    }
    
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue)
    {
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    

}
