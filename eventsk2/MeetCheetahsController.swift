//
//  MeetCheetahsController.swift
//  eventsk2
//
//  Created by Casey Colby on 7/20/16.
//  Copyright © 2016 Casey Colby. All rights reserved.
//

import UIKit

class MeetCheetahsController: UIViewController {
    
    @IBOutlet weak var blueCheetah: UIImageView!
    @IBOutlet weak var redCheetah: UIImageView!
    @IBOutlet weak var gestureInstruction: UILabel!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    //MARK: Variables
    
    var trial: Trial! //receives subject instance from WelcomeController
//    var i: Int = 0

    
    
    
    //MARK: Actions
    
//    func jumpToTrial() {
//        self.performSegueWithIdentifier("toPlayVideo", sender: self)
//        //set i to whichever trial is selected!
//    }
    
    
    
    //MARK: View Lifecycle
    
    // holding screen that requires long press to enter experiment so that we can set up the game and subject info before the subject arrives and leave it in this state until they're ready to participate
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureInstruction.text = "two-finger double-tap to enter"
        gestureInstruction.hidden = false
        tapGestureRecognizer.enabled = true
        tapGestureRecognizer.numberOfTouchesRequired = 2
        tapGestureRecognizer.numberOfTapsRequired = 2
    }
    
    
    
    
    
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let navVC = segue.destinationViewController as! UINavigationController
        
        if let destination = navVC.viewControllers.first as? PlayVideoController {
            destination.trial = self.trial //pass subject instance to PlayVideoController
//            destination.i = self.i
        }
        
    }
    
    
}


