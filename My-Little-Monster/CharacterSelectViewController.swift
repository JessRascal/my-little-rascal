//
//  CharacterSelectViewController.swift
//  My-Little-Monster
//
//  Created by Michael Jessey on 03/02/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import UIKit
import AVFoundation

class CharacterSelectViewController: UIViewController {
    
    var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Play background music.
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        musicPlayer.prepareToPlay()
        musicPlayer.volume = 0.1
        musicPlayer.numberOfLoops = -1
        musicPlayer.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func callCharacterSelectedSegue(sender: UIButton) {
        performSegueWithIdentifier("characterSelectedSegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "characterSelectedSegue" {
            let mainVc = segue.destinationViewController as! ViewController
            mainVc.characterSelected = sender!.tag
        }
    }
}
