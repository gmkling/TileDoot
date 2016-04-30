//
//  InfoViewController.swift
//  TileDoot
//
//  Created by Garry Kling on 4/30/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet var doneButton: UIButton!


    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doDoneButton(sender: UIButton)
    {
        self.navigationController?.popViewControllerAnimated(true)
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
