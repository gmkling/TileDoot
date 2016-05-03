//
//  InfoViewController.swift
//  TileDoot
//
//  Created by Garry Kling on 4/30/16.
//  Copyright © 2016 Garry Kling. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet var LI_Button: UIButton!
    @IBOutlet var Web_Button: UIButton!
    @IBOutlet var Git_Button: UIButton!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var SFX_Switch: UISwitch!
    @IBOutlet var Music_Switch: UISwitch!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var audioDelegate : TD_AudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @IBAction func doWeb_Button(sender: UIButton)
    {
        audioDelegate?.playSFX(singleTap_key, typeKey: mono_key)
        let webUrl = NSURL(string: "http://www.garrykling.com")!
        UIApplication.sharedApplication().openURL(webUrl)
    }
    
    @IBAction func doGit_Button()
    {
        audioDelegate?.playSFX(singleTap_key, typeKey: mono_key)
        let gitUrl = NSURL(string: "http://www.github.com/gmkling")!
        UIApplication.sharedApplication().openURL(gitUrl)
    }
    
    @IBAction func doLI_Button(sender: UIButton)
    {
        audioDelegate?.playSFX(singleTap_key, typeKey: mono_key)
        let webUrl = NSURL(string: "http://www.linkedin.com/in/garrykling")!
        UIApplication.sharedApplication().openURL(webUrl)
    }
    
    @IBAction func SFX_toggle(switchState: UISwitch)
    {
        // sent on status change
        if switchState.on
        {
            // retain the default
            defaults.setBool(true, forKey: sfx_key)
            // update the player
            audioDelegate?.unmuteSFX()
            audioDelegate?.playSFX(pileTap_key, typeKey: stereo_key)
            print("SFX On")
        } else {
            // retain default
            defaults.setBool(false, forKey: sfx_key)
            // update the player
            audioDelegate?.muteSFX()
            print("SFX Off")
        }
    }
    
    @IBAction func Music_toggle(switchState: UISwitch)
    {
        
        // sent on status change
        if switchState.on
        {
            // retain the default
            defaults.setBool(false, forKey: music_key)
            // update the player
            audioDelegate?.muteMusic()
            print("Music Off")
        } else {
            // retain the default
            defaults.setBool(true, forKey: music_key)
            
            // update the player
            audioDelegate?.unmuteMusic()
            print("Music On")
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
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
    

}
