//
//  ResponseController.swift
//  events.child.2
//
//  Created by Casey Colby on 4/22/16.
//  Copyright © 2016 Casey Colby. All rights reserved.
//

import UIKit
import RealmSwift
import AVKit
import AVFoundation

class ResponseController : UIViewController {
    
    @IBOutlet weak var cheetahA: UIButton!
    @IBOutlet weak var cheetahB: UIButton!
    @IBOutlet weak var noResponse: UIBarButtonItem!
    @IBOutlet weak var replayVideo: UIBarButtonItem!
    
    
    
    
    
    //MARK: Variables
    
    var star: UILabel! = nil
    
    //animation completion vars
    var t : Int = 1
    var timer: NSTimer!
    var posn : [CGFloat] = [CGFloat(0)]
    
    var stim = Stimuli()
    
    //db vars
    var trial: Trial! //passed from PVController
    var selectedButton: String!
    var i: Int = 0 //trial# / stimuli index; passed from PVController
    var totalTrials = 8 //CHANGE DEPENDING ON NUMBER OF TRIALS
    var p: Int = 0 //practice trial index, passed from PVController

    

    
    
    
    //MARK: Realm
    
    func preProcessResponse() {
        if (trial.response == trial.heightWin) {
            trial.heightResp = 1
        }
        if (trial.response == trial.numberWin) {
            trial.numberResp = 1
        }
        if (trial.response == trial.durationWin) {
            trial.durationResp = 1
        }
    }
    
    func updateTrialInDatabase()
    {
        let realm = try! Realm()
        try! realm.write {
            self.trial.response = self.selectedButton!
            preProcessResponse()
        }
    }
    
    
    
    
    
    //MARK: Actions
    @IBAction func replayVideo(sender: AnyObject) {
        if (p < stim.practice.count) {
            playVideo(p, array: stim.practice)
        }
        
        if trial.trialNumber != 0 {
            if (trial.order == 1) {
                playVideo(i, array: stim.order1)
            }
            else if (trial.order == 2) {
                playVideo(i, array: stim.order2)
            }
        }
    }
    
    func playVideo(index: Int, array: [NSObject]){
        //setup
        let path = array[index]
        let url = NSURL.fileURLWithPath(path as! String)
        print("playing \(url.lastPathComponent!)")
        let item = AVPlayerItem(URL: url)
        let player = AVPlayer(playerItem: item)
        
        //display the player content
        let playerController = AVPlayerViewController()
        playerController.player = player
        playerController.showsPlaybackControls = false
    
        
        self.presentViewController(playerController, animated: true, completion: nil)
        
        //setup notification when video finished
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlayVideoController.videoDidFinish), name: AVPlayerItemDidPlayToEndTimeNotification, object: item)
        
        //play after delay
        let wait = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
        dispatch_after(wait, dispatch_get_main_queue()) {
            player.play()
        }
    }
    
    func videoDidFinish(){
        let wait = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC)) //slight delay needed
        dispatch_after(wait, dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //when response button pressed:
    @IBAction func response(sender:AnyObject) {
        switch sender{
        case cheetahA as UIButton:
            selectedButton = "A"
            cheetahB.enabled = false
            noResponse.enabled = false
            wobbleButton(cheetahA)
        case cheetahB as UIButton:
            selectedButton = "B"
            cheetahA.enabled = false
            noResponse.enabled = false
            wobbleButton(cheetahB)
        case noResponse as UIBarButtonItem:
            selectedButton = "NA"
            cheetahA.enabled = false
            cheetahB.enabled = false
        default:
            selectedButton = "NA"
        }
        starSwoosh()
        
        let seconds = 4.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            self.performSegueWithIdentifier("tocontinuePlayVideo", sender: self)
            
        })
    }
    
    func wobbleButton(sender:UIButton) {
        //shrink
        sender.transform = CGAffineTransformMakeScale(0.1, 0.1)
        //bounce back to normal size
        UIView.animateWithDuration(2.0,
                                   delay: 0,
                                   usingSpringWithDamping: 0.2,
                                   initialSpringVelocity: 6.0,
                                   options: UIViewAnimationOptions.AllowUserInteraction,
                                   animations: {
                                    sender.transform =
                                    CGAffineTransformIdentity}
            , completion: nil)
        }

    
    
    
    
    //MARK: Animations
    func starSwoosh() {
        for _ in 0...i {
            
            // create a square
            star = UILabel()
            star.frame = CGRect(x:0, y:0, width: 100.0, height:100.0)
            star.text = "⭐️"
            star.font = star.font.fontWithSize(60)
            
            self.view.addSubview(star)
            
            // randomly create a value between 0.0 and 150.0, ADD TO EVERYTHING so the diff objects appear at different levels along bezier curve
            let randomYOffset = CGFloat( arc4random_uniform(150))
            
            //a UIBezierPath combines the geometry and attributes describing the path and draws it
            let path = UIBezierPath()
            
            //part 1: set the geometry
            //pick path's current point without drawing a segment
            path.moveToPoint(CGPoint(x: 16,y: 239 + randomYOffset))
            //draw curve to endpt
            let endpt = CGPoint(x: view.frame.width+50, y: 289+randomYOffset)
            path.addCurveToPoint(endpt, controlPoint1: CGPoint(x: 116, y: 403 + randomYOffset), controlPoint2: CGPoint(x: view.frame.width-200, y: 90 + randomYOffset))
            
            
            //part 2: create the animation attributes
            // create the animation
            let anim = CAKeyframeAnimation(keyPath: "position")
            anim.path = path.CGPath
            anim.rotationMode = kCAAnimationRotateAuto
            anim.repeatCount = 1
            
            // each square will take between 4.0 and 8.0 seconds
            // to complete one animation loop
            anim.duration = Double(arc4random_uniform(30)+20)/10
            
            
            //don't reset to original position at the end, hold final position instead
            anim.fillMode = kCAFillModeForwards
            anim.removedOnCompletion = false
            
            // add the animation
            star.layer.addAnimation(anim, forKey: "animate position along path")
        }
    }
    

    
    
  
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //don't update database with practice trials
        if (p<2) {
            p+=1
            if let destination = segue.destinationViewController as? PlayVideoController{
                destination.p = self.p
            }
        } else {
        //update database for test trials
            if segue.identifier == "tocontinuePlayVideo"  {
                i+=1
                updateTrialInDatabase()
            }
        
            //pass variables to destinationVC
            if let destination = segue.destinationViewController as? PlayVideoController {
                destination.trial = self.trial
                destination.i = self.i
            }
        }
    }
    
}