//
//  PuzzleSetViewController.swift
//  TileDoot
//
//  Created by Garry Kling on 5/5/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import UIKit

let puzzleSetFiles = ["TestSet1.txt", "TestSet2.txt", "TestSet3.txt"]

class PuzzleSetViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    //var collectionView : UICollectionView!
    var puzzleData : [PuzzleSet?] = []
    var selectedIndex = 0
    weak var audioDelegate : TD_AudioPlayer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // set the size of the items in the collectionView
        collectionView?.contentSize = CGSize(width: 75, height: 150)
        
        // init the PuzzleSet array - TODO: How to preload this data?
        puzzleData = []
        for name in puzzleSetFiles
        {
            puzzleData.append(PuzzleSet(withFileName: name))
        }

        collectionView!.backgroundColor = lightGreenTileColor.colorWithAlphaComponent(1.0)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        // 5 items per page
        if puzzleData.count > 0
        {
            return puzzleData.count
        } else {
            return 0
        }
        
    }
    
    // make a cell for each cell index path
   
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PuzzleSetCell
        
        // configure cell visual attributes, indexing the puzzle set
        // create a blank/grey tile if there is no set to use
       
        cell.backgroundColor = purpleTileColor.colorWithAlphaComponent(1.0)
        let index = (indexPath.section*2)+indexPath.row
        cell.titleLabel.text = puzzleData[index]?.name
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        // hand off the index for the selected Puzzle
        selectedIndex = (indexPath.section*2)+indexPath.row
        audioDelegate?.playSFX(singleTap_key, typeKey: stereo_key)
        self.performSegueWithIdentifier("PuzzleSetSelectedSegue", sender: self)
    }
    
//    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue)
//    {
//        // TODO: keep the audioEngine relevant
//        //audioEngine.playSFX(singleTap_key, typeKey: mono_key)
//    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PuzzleSetSelectedSegue"
        {
            let vc = segue.destinationViewController as? PuzzleSelectionViewController
            vc!.puzzleData = self.puzzleData[selectedIndex]
            vc!.audioDelegate = self.audioDelegate
            print("Added Puzzle set named \(vc!.puzzleData.name) to selectionView")
        }
    }

}


class PuzzleSetCell : UICollectionViewCell
{
    @IBOutlet var titleLabel: UILabel!
    
}