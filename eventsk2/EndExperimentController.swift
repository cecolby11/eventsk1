//
//  EndExperimentController.swift
//  eventsk2
//
//  Created by Casey Colby on 5/7/16.
//  Copyright © 2016 Casey Colby. All rights reserved.
//

import Foundation
import UIKit

class EndExperimentController : UIViewController {
    
    @IBOutlet weak var blueCheetah: UIImageView!
    @IBOutlet weak var redCheetah: UIImageView!

    //MARK: Variables
    
    //init dynamics properties
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var elasticity: UIDynamicItemBehavior!

    var cheetahs : [UIDynamicItem]!
    
    
    
    
    
    //MARK: Background Animations
    
    func moveCheetahs() {
        cheetahs = [blueCheetah, redCheetah]
        
        animator = UIDynamicAnimator(referenceView: view)
        
        gravity = UIGravityBehavior(items: cheetahs)
        collision = UICollisionBehavior(items: cheetahs)
        collision.translatesReferenceBoundsIntoBoundary = true
        elasticity = UIDynamicItemBehavior(items: cheetahs)
        elasticity.elasticity = 1.08
        
        // Add to animator
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        animator.addBehavior(elasticity)
        
    }
    
    
    
    
    
    //MARK: View Lifecycle
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        moveCheetahs()
    }
    
}

