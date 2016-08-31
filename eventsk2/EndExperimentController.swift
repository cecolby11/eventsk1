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
    
    var star: UILabel! = nil
    var anim = CAKeyframeAnimation(keyPath: "position")
    
    
    
    
    
    //MARK: Animation
    
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
    
    func starSwoosh() {
        for _ in 1...8 {
            
            star = UILabel()
            star.frame = CGRect(x:0, y:0, width: 100.0, height:100.0)
            star.text = "⭐️"
            star.font = star.font.fontWithSize(CGFloat(arc4random_uniform(35)+10))
            self.view.addSubview(star)
            
            //UIBezierPath: combines the geometry and attributes of the path and draws it
            let path = UIBezierPath()
            
            //1. set the geometry
            //pick path's current point without drawing a segment, then draw curve from there to endpt
            let randomYOffset = CGFloat(arc4random_uniform(200)) - 50
            path.moveToPoint(CGPoint(x: 116,y:view.frame.height/2 + randomYOffset))
            let endpt = CGPoint(x: view.frame.width-116, y:view.frame.height/2+50 + randomYOffset)
            path.addCurveToPoint(endpt, controlPoint1: CGPoint(x: 226, y:view.frame.height/2+164 + randomYOffset), controlPoint2: CGPoint(x: view.frame.width-200, y: view.frame.height/2 - 149 + randomYOffset))
            
            //2. create the animation & its attributes
            anim.path = path.CGPath
            anim.rotationMode = kCAAnimationRotateAuto
            anim.repeatCount = Float.infinity
            anim.duration = Double(arc4random_uniform(50)+30)/10 //2.0-6.0 seconds to complete
            anim.timeOffset = Double(arc4random_uniform(220))
            
            star.layer.addAnimation(anim, forKey: "animate position along path")
        }
    }
    
    

    
    
    
    //MARK: View Lifecycle
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        moveRight()
        starSwoosh()
       }

}