//
//  CharacterSelectViewController.swift
//  My-Little-Monster
//
//  Created by Michael Jessey on 03/02/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import UIKit

class CharacterSelectViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
