//
//  PuzzleSetDirectoryController.swift
//  TileDoot
//
//  Created by Garry Kling on 5/6/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import UIKit

class PuzzleSetDirectoryController: UIViewController {

    @IBOutlet var directoryTitle: UILabel!
    @IBOutlet weak var directoryContainer: UIView!
    weak var audioDelegate : TD_AudioPlayer?
    weak var puzzleSetControl : PuzzleSetViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func unwindToSetMenu(unwindSegue: UIStoryboardSegue)
    {
        audioDelegate?.playSFX(singleTap_key, typeKey: mono_key)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "backToMain"
        {
            if puzzleSetControl != nil
            {
                // clear puzzle data
                puzzleSetControl?.cleanup()
            }
        }
        
        if segue.identifier == "PuzzleSetSegue"
        {
            puzzleSetControl = segue.destinationViewController as! PuzzleSetViewController
            puzzleSetControl!.audioDelegate = self.audioDelegate
        }
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
