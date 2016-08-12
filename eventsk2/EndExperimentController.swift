//
//  EndExperimentController.swift
//  eventsk2
//
//  Created by Casey Colby on 5/7/16.
//  Copyright © 2016 Casey Colby. All rights reserved.
//

import Foundation
import UIKit

class EndExperimentController : UIViewController{
    
    @IBOutlet weak var blueCheetah: UIImageView!
    @IBOutlet weak var redCheetah: UIImageView!

    //MARK: Variables
    
    
    
    
    //MARK: Background Animations
    
    func moveRight() {
        UIView.animateWithDuration(2.2, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.blueCheetah.center = CGPoint(x: self.view.frame.width/2 + 250, y: self.blueCheetah.center.y)
            self.redCheetah.center = CGPoint(x: self.view.frame.width/2 + 250, y: self.redCheetah.center.y)
            }, completion: {(complete: Bool) in self.moveLeft()})
        }
    
    func moveLeft() {
        UIView.animateWithDuration(2.2, delay: 0, options: .CurveEaseInOut, animations: {
            self.blueCheetah.center = CGPoint(x: self.view.frame.width/2 - 250, y: self.blueCheetah.center.y)
            self.redCheetah.center = CGPoint(x: self.view.frame.width/2 - 250, y: self.redCheetah.center.y)
            }, completion: {(complete: Bool) in self.moveRight()})

    }
    

    
    
    
    //MARK: View Lifecycle
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        moveRight()
       }

}