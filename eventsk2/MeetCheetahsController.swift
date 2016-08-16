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
    @IBOutlet var longPressRecognizer: UILongPressGestureRecognizer!
    
    //MARK: Variables
    
    var trial: Trial! //receives subject instance from WelcomeController

   
    

    
    //MARK: Actions
    
    @IBAction func beginGame(sender: UILongPressGestureRecognizer) {
        blueCheetah.hidden = false
        redCheetah.hidden = false
        gestureInstruction.hidden = false
        gestureInstruction.text = "two-finger tap anywhere to continue"
        longPressRecognizer.enabled = false
        tapGestureRecognizer.enabled = true
    }
 
    
    
    
    
    
    //MARK: View Lifecycle
    
    // holding screen that requires long press to enter experiment so that we can set up the game and subject info before the subject arrives and leave it in this state until they're ready to participate
    override func viewDidLoad() {
        super.viewDidLoad()
        blueCheetah.hidden = true
        redCheetah.hidden = true
        gestureInstruction.text = "press and hold to enter"
        gestureInstruction.hidden = false
        tapGestureRecognizer.enabled = false
        longPressRecognizer.enabled = true
        tapGestureRecognizer.numberOfTouchesRequired = 2
    }
    
    
    
    
    
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let navVC = segue.destinationViewController as! UINavigationController
        
        if let destination = navVC.viewControllers.first as? PlayVideoController {
            destination.trial = self.trial //pass subject instance to PlayVideoController
        }
    }
    
    
}


