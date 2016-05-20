//
//  PuzzleCollectionViewController.swift
//  TileDoot
//
//  Created by Garry Kling on 5/9/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PuzzleCollectionViewController: UICollectionViewController
{
    var puzzleData : PuzzleSet!
    var puzzleSelected = 0
    var loadSpinner : UIActivityIndicatorView?
    weak var audioDelegate : TD_AudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(PuzzleSelectionCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    // segues &c



    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {

        if puzzleData.nPuzzles > 0
        {
            return puzzleData.nPuzzles
        } else {
            return 0
        }
        
    }
    
    // make a cell for each cell index path
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PuzzleCell", forIndexPath: indexPath) as! PuzzleSelectionCell
        
        // configure cell visual attributes, indexing the puzzle set
        // create a blank/grey tile if there is no set to use
        
        cell.backgroundColor = purpleTileColor.colorWithAlphaComponent(1.0)
        let index = (indexPath.section*2)+indexPath.row
        cell.puzzleLabel.text = String(index+1)
        return cell
    }
    
    // create and display the loading view
    
    
    
    // MARK: Loading the GamePlay screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
  
        if segue.identifier == "GamePlaySegue"
        {
            let indexPath = collectionView!.indexPathForCell(sender as! UICollectionViewCell)
            let index = (indexPath!.section*2)+indexPath!.row
            
            let vc = segue.destinationViewController as? GamePlaySceneViewController
            vc!.puzzles = self.puzzleData
            let thePuzzle = self.puzzleData.getPuzzle(index+1)
            vc!.curPuz = (thePuzzle!.puzzleID)
            vc!.curSet = puzzleData.name
            vc!.audioDelegate = self.audioDelegate
            print("Added Puzzle named \(vc!.curPuz) to GamePlayView")
            vc!.puzzMenu = self
            
        }
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        // handle tap events
        // selected item launch a new collection view of the puzzles
        let index = (indexPath.section*2)+indexPath.row
        
        // use the selected puzzle to present a gamePlayView
        print("Selected Puzzle: \(index+1)")
        puzzleSelected = index + 1
        audioDelegate?.playSFX(singleTap_key, typeKey: stereo_key)
        // start the spinner
        loadSpinner = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        loadSpinner?.hidesWhenStopped = true
        loadSpinner?.center = self.view.center
        //loadSpinner?.color =
        self.view.addSubview(loadSpinner!)
        loadSpinner?.startAnimating()
    }

}
