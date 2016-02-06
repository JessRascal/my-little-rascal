//
//  MonsterImage.swift
//  My-Little-Monster
//
//  Created by Michael Jessey on 29/01/2016.
//  Copyright © 2016 JustOneJess. All rights reserved.
//

import Foundation
import UIKit

class MonsterImage: UIImageView {
    private var _characterNumber: Int = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setCharacter(characterNumber: Int) {
        self._characterNumber = characterNumber
    }
    
    func playIdleAnimation() {
        
        self.image = UIImage(named: "character\(_characterNumber)_idle1.png")
        self.animationImages = nil
        
        var imageArray = [UIImage]()
        
        for var x in 1...4 {
            let img = UIImage(named: "character\(_characterNumber)_idle\(x).png")
            imageArray.append(img!)
        }
        
        animateCharacter(imageArray, repeatCount: 0, duration: 1.2)
    }
    
    func playDeathAnimation() {
        
        self.image = UIImage(named: "character\(_characterNumber)_dead5.png")
        self.animationImages = nil
        
        var imageArray = [UIImage]()
        
        for var x in 1...5 {
            let img = UIImage(named: "character\(_characterNumber)_dead\(x).png")
            imageArray.append(img!)
        }
        
        animateCharacter(imageArray, repeatCount: 1, duration: 0.8)
    }
    
    func playReviveAnimation () {
        self.image = UIImage(named: "character\(_characterNumber)_idle1.png")
        self.animationImages = nil
        var imageArray = [UIImage]()
        
        for var x in 5.stride(through: 1, by: -1) {
            let img = UIImage(named: "character\(_characterNumber)_dead\(x).png")
            imageArray.append(img!)
        }
        
        animateCharacter(imageArray, repeatCount: 1, duration: 0.8)
    }
    
    func animateCharacter(imageArray: [UIImage], repeatCount: Int, duration: Double) {
        self.animationImages = imageArray
        self.animationDuration = duration
        self.animationRepeatCount = repeatCount
        self.startAnimating()
    }
}
