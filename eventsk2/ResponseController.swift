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
    var anim = CAKeyframeAnimation(keyPath: "position")
    var starCenter : CGPoint!
    
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
        if (trial.response == trial.distanceWin) {
            trial.distanceResp = 1
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
            starCenter = CGPoint(x:cheetahA.center.x - 70, y:cheetahA.center.y)
            wobbleButton(cheetahA)
        case cheetahB as UIButton:
            selectedButton = "B"
            cheetahA.enabled = false
            noResponse.enabled = false
            wobbleButton(cheetahB)
            starCenter = CGPoint(x: cheetahB.center.x + 70, y:cheetahB.center.y)
        case noResponse as UIBarButtonItem:
            selectedButton = "NA"
            cheetahA.enabled = false
            cheetahB.enabled = false
            starCenter = view.center
            noResponse.enabled = false
        default:
            selectedButton = "NA"
        }
        replayVideo.enabled = false
        starShimmer()
        
        let seconds = 4.5
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            
            self.performSegueWithIdentifier("tocontinuePlayVideo", sender: self)
            
        })
    }
    
    
    
    
    
    //MARK: Animations
    
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
        sender.enabled = false
        }

    func starShimmer() {
        for _ in 1...10 {
            
            star = UILabel()
            star.frame = CGRect(x:0, y:0, width: 100.0, height:100.0)
            star.text = "⭐️"
            star.font = star.font.fontWithSize(CGFloat(arc4random_uniform(35)+15))
            self.view.addSubview(star)
            
            //UIBezierPath: combines the geometry and attributes of the path and draws it
            let path = UIBezierPath()
            
            //1. set the geometry
            //pick path's current point without drawing a segment, then draw curve from there to endpt
            
            path.moveToPoint(starCenter)
            let randAngle = Double(arc4random_uniform(360))
            let radius = Double(150)
            let randX = Double(view.frame.width/2) + (radius)*cos(randAngle)
            let XOffset = Double(arc4random_uniform(40))
            let randY = Double(view.frame.height/2) + (radius)*sin(randAngle)
            let YOffset = Double(arc4random_uniform(40))
            let endpt = CGPoint(x: randX, y: randY)
            
            path.addCurveToPoint(endpt, controlPoint1: CGPoint(x: randX + XOffset, y: randY + YOffset), controlPoint2: CGPoint(x: randX + XOffset - 30, y: randY + 20 + YOffset))
            
            //2. create the animation & its attributes
            anim.path = path.CGPath
            anim.rotationMode = kCAAnimationRotateAuto
            anim.repeatCount = 2
            anim.duration = Double(arc4random_uniform(40)+30)/10 //2.0-6.0 seconds to complete
            anim.timeOffset = Double(arc4random_uniform(190))
            
            //don't reset to original position at the end, hold final position instead
            anim.fillMode = kCAFillModeForwards
            anim.removedOnCompletion = false
            
            star.layer.addAnimation(anim, forKey: "animate position along path")
        }
    }


    
    
    
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        //only one cheetah may be selected at a time
        cheetahA.exclusiveTouch = true
        cheetahB.exclusiveTouch = true
        
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