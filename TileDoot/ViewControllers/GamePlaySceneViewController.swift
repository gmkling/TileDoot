//
//  GamePlaySceneViewController.swift
//  TileDoot
//
//  Created by Garry Kling on 5/10/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import UIKit
import SpriteKit

class GamePlaySceneViewController: UIViewController {
    
    var puzzles : PuzzleSet?
    var curPuz : String = ""
    var curSet : String = ""
    weak var scene : GamePlayScene?
    weak var audioDelegate : TD_AudioPlayer?
    weak var puzzMenu : PuzzleCollectionViewController?
    
    
    override func viewWillAppear(animated: Bool)
    {
        if puzzMenu != nil
        {
            // stop the spinner
            puzzMenu!.loadSpinner?.stopAnimating()
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        let skView = self.view as! SKView
        let scene = GamePlayScene(size: view.frame.size, puzSet: puzzles!, puzID: curPuz)
        scene.delegateController = self
        scene.audioDelegate = self.audioDelegate
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func returnToPuzzleSelection()
    {
        // TODO: Effective cleanup
        // clear the scene and delete
        let skView = self.view as! SKView
        skView.presentScene(nil)
        scene = nil
        audioDelegate?.playSFX(pileTap_key, typeKey: stereo_key)
        
        // manually unwind the modal segue
        self.performSegueWithIdentifier("unwindToPuzzleMenu", sender: self)
    }
    
    func returnToPuzzleSetScreen()
    {
        // TODO: Effective cleanup
        // clear the scene and delete
        let skView = self.view as! SKView
        skView.presentScene(nil)
        scene = nil
        audioDelegate?.playSFX(pileTap_key, typeKey: stereo_key)
        
        self.performSegueWithIdentifier("unwindToSetMenu", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
