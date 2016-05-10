//
//  PuzzleSelectionViewController.swift
//  TileDoot
//
//  Created by Garry Kling on 5/7/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import UIKit

class PuzzleSelectionViewController: UIViewController {

    @IBOutlet var selectionTitle: UILabel!
    @IBOutlet var selectionContainer: UIView!
    var puzzleData : PuzzleSet!
    
    func setPuzzleSet(newSet: PuzzleSet)
    {
       puzzleData = newSet
    }
    
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
    
    // get the segue for the container view to pass the puzzleSet there
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PuzzleSelectSegue"
        {
            let vc = segue.destinationViewController as? PuzzleCollectionViewController
            vc!.puzzleData = self.puzzleData
            print("Added Puzzle set named \(puzzleData.name) to selectionView")
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

