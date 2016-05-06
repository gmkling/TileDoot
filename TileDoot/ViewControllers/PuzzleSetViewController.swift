//
//  PuzzleSetViewController.swift
//  TileDoot
//
//  Created by Garry Kling on 5/5/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import UIKit

let puzzleSetFiles = ["TestSet1.txt", "TestSet2.txt", "TestSet3.txt"]

class PuzzleSetViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var collectionView : UICollectionView!
    var puzzleData : [PuzzleSet]!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // background
        
        
        // configure the layout object
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        // init the PuzzleSet array - TODO: How to preload this data?
        puzzleData = []
        for name in puzzleSetFiles
        {
            puzzleData.append(PuzzleSet(withFileName: name))
        }
        
        // create the UICollectionView and hook up delegate, cell class, and data source
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(PuzzleSetCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.init(colorLiteralRed: 144.0/255.0, green: 172.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        
        self.view.addSubview(collectionView)
        // constrain to center
        NSLayoutConstraint(item: self.view, attribute: .CenterX, relatedBy: .Equal, toItem: collectionView, attribute: .CenterX, multiplier: 1, constant: 0).active = true
        
        NSLayoutConstraint(item: self.view, attribute: .CenterY, relatedBy: .Equal, toItem: collectionView, attribute: .CenterY, multiplier: 1, constant: 0).active = true
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
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if puzzleData != nil
        {
            return self.puzzleData.count
        } else {
            return 0
        }
        
    }
    
    // make a cell for each cell index path
   
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        // configure cell visual attributes
        cell.backgroundColor = UIColor.orangeColor()
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        // handle tap events
        // selected item launch a new collection view of the puzzles
    }

}


class PuzzleSetCell : UICollectionViewCell
{
    
}