//
//  ViewController.swift
//  My-Little-Monster
//
//  Created by Michael Jessey on 29/01/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    // Outlets
    @IBOutlet weak var monsterImage: MonsterImage!
    @IBOutlet weak var foodImage: DragImage!
    @IBOutlet weak var heartImage: DragImage!
    @IBOutlet weak var gloveImage: DragImage!
    @IBOutlet weak var penalty1Image: UIImageView!
    @IBOutlet weak var penalty2Image: UIImageView!
    @IBOutlet weak var penalty3Image: UIImageView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var livesPanel: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var groundImage: UIImageView!
    
    // Constants
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTY = 3
    
    // Variables
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = true
    var currentItem: UInt32 = 0
    var characterSelected: Int!
    
    // Sound effects
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxHit: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        // Setup audio players.
        do {
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            try sfxHit = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("hit", ofType: "wav")!))
            
            sfxBite.prepareToPlay()
            sfxBite.volume = 0.2
            sfxHeart.prepareToPlay()
            sfxHeart.volume = 0.05
            sfxHit.prepareToPlay()
            sfxHit.volume = 0.2
            sfxDeath.prepareToPlay()
            sfxDeath.volume = 0.4
            sfxSkull.prepareToPlay()
            sfxSkull.volume = 0.2
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        // Set the character.
        monsterImage.setCharacter(characterSelected)
        
        setUpGame()
    }
    
    func setBgandGround() {
        backgroundImage.image = UIImage(named: "character\(characterSelected)_bg")
        groundImage.image = UIImage(named: "character\(characterSelected)_ground")
    }

    func setUpGame(restart: Bool = false) {
        setBgandGround()
        foodImage.dropTarget = monsterImage
        heartImage.dropTarget = monsterImage
        gloveImage.dropTarget = monsterImage
        
        foodImage.hidden = false
        heartImage.hidden = false
        gloveImage.hidden = false
        
        livesPanel.hidden = false
        penalty1Image.hidden = false
        penalty2Image.hidden = false
        penalty3Image.hidden = false
        
        penalty1Image.alpha = DIM_ALPHA
        penalty2Image.alpha = DIM_ALPHA
        penalty3Image.alpha = DIM_ALPHA
        foodImage.alpha = DIM_ALPHA
        heartImage.alpha = DIM_ALPHA
        gloveImage.alpha = DIM_ALPHA
        
        // Start the character idle animation.
        monsterImage.playIdleAnimation()
        monsterHappy = true
        startTimer()
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        if currentItem == 0 {
            sfxHeart.play()
        } else if currentItem == 1 {
            sfxBite.play()
        } else {
            sfxHit.play()
        }
        
        monsterHappy = true
        startTimer()
        
        foodImage.alpha = DIM_ALPHA
        foodImage.userInteractionEnabled = false
        heartImage.alpha = DIM_ALPHA
        heartImage.userInteractionEnabled = false
        gloveImage.alpha = DIM_ALPHA
        gloveImage.userInteractionEnabled = false
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        if !monsterHappy {
            penalties += 1
            
            sfxSkull.play()
            
            if penalties == 1 {
                penalty1Image.alpha = OPAQUE
                penalty2Image.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penalty2Image.alpha = OPAQUE
                penalty3Image.alpha = DIM_ALPHA
            } else if penalties >= 3 {
                penalty3Image.alpha = OPAQUE
            } else {
                penalty1Image.alpha = DIM_ALPHA
                penalty2Image.alpha = DIM_ALPHA
                penalty3Image.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTY {
                gameOver()
            }
        }
        
        let rand = arc4random_uniform(3) // 0, 1, or 2.
        
        if rand == 0 { // Heart selectable
            foodImage.alpha = DIM_ALPHA
            foodImage.userInteractionEnabled = false
            gloveImage.alpha = DIM_ALPHA
            gloveImage.userInteractionEnabled = false
            heartImage.alpha = OPAQUE
            heartImage.userInteractionEnabled = true
        } else if rand == 1 { // Food selectable.
            heartImage.alpha = DIM_ALPHA
            heartImage.userInteractionEnabled = false
            gloveImage.alpha = DIM_ALPHA
            gloveImage.userInteractionEnabled = false
            foodImage.alpha = OPAQUE
            foodImage.userInteractionEnabled = true
        } else { // Glove selectable.
            heartImage.alpha = DIM_ALPHA
            heartImage.userInteractionEnabled = false
            foodImage.alpha = DIM_ALPHA
            foodImage.userInteractionEnabled = false
            gloveImage.alpha = OPAQUE
            gloveImage.userInteractionEnabled = true
        }
        
        currentItem = rand
        monsterHappy = false
        
    }
    
    @IBAction func restartButtonTapped(sender: AnyObject) {
        monsterImage.playReviveAnimation()
        buttonStackView.hidden = true
        resetPenalties()
        delay(0.8) {
            self.setUpGame(true)
        }
    }
    
    @IBAction func startOverButtonTapped(sender: AnyObject?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resetPenalties() {
        self.penalties = 0
    }
    
    func gameOver() {
        sfxDeath.play()
        timer.invalidate()
        timer = nil
        foodImage.hidden = true
        heartImage.hidden = true
        gloveImage.hidden = true
        livesPanel.hidden = true
        penalty1Image.hidden = true
        penalty2Image.hidden = true
        penalty3Image.hidden = true
        monsterImage.playDeathAnimation()
        buttonStackView.hidden = false
    }
    
    
    // General delay function.
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    // Deinitializer just for debugging.
//    deinit {
//        debugPrint("ViewController deinitialized...")
//    }

}

