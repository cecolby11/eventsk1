//
//  WelcomeController.swift
//  eventsk2
//
//  Created by Casey Colby on 4/20/16.
//  Copyright © 2016 Casey Colby. All rights reserved.
//

import UIKit
import RealmSwift

class WelcomeController: UIViewController, UIAlertViewDelegate {

     @IBOutlet weak var enterSubjectInfo: UIBarButtonItem!
    
    //MARK: Variables
    
    //subject info vars
    var trial: Trial = Trial() //create new instance of Trial object
    
    //alert vars
    var saveAction: UIAlertAction!
    var cancelAction: UIAlertAction!
    
    //animation vars
    @IBOutlet weak var blueCheetah: UIImageView!
    @IBOutlet weak var redCheetah: UIImageView!

    
    
    
    
    
    //MARK: Actions
    
    //Check that all fields are populated
    func validateFields() -> Bool {
        if trial.subjectNumber.isEmpty || trial.condition.isEmpty {
            let alertController = UIAlertController(title: "Validation Error", message: "All fields must be filled", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Destructive) { alert in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            }
            alertController.addAction(alertAction)
            presentViewController(alertController, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }

    //Show subject info alert when '+' button pressed
    @IBAction func showAlert(sender:AnyObject) {
        
        //initialize controller
        let alertController = UIAlertController(title: "New Subject", message: "Enter New Subject Info", preferredStyle: .Alert)
        
        //add text fields
        let aquablue = UIColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 1)
        
        alertController.addTextFieldWithConfigurationHandler{ (textField:UITextField!) in
            textField.placeholder = "Subject Number"
            textField.textColor = aquablue //input text
        }
        alertController.addTextFieldWithConfigurationHandler { (textField:UITextField!) in
            textField.placeholder = "Condition"
            textField.textColor = aquablue //input text
        }
        
        //initialize actions
        cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
        })
        //handler means the block is executed when user selects that action
        // parameters -> return type (void)
        //in indicates the start of the closure body
        saveAction = UIAlertAction(title: "Save", style: .Default, handler: {action in
            self.trial.subjectNumber = "\((alertController.textFields![0] as UITextField).text!)" //unwrap array UITextFields (array of type AnyObject), cast to UITextField, and get the text variable from the entry
            self.trial.condition = "\((alertController.textFields![1] as UITextField).text!)"
            
            if self.validateFields() { //require that all fields are filled before segue is called
                self.performSegueWithIdentifier("toMeetCheetahs", sender: self) //manually segue when save button pressed
            }
        })
        
        //add actions
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        //present alert controller
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
    //MARK: Animation 
    
    //MARK: Background Animations
    
    func moveRight() {
        UIView.animateWithDuration(2.2, delay: 0, options: .CurveEaseInOut, animations: {
            self.blueCheetah.center = CGPointMake(self.view.frame.width/2 + 250, self.blueCheetah.center.y)
            self.redCheetah.center = CGPointMake(self.view.frame.width/2 + 250, self.redCheetah.center.y)
            }, completion:
            {(complete: Bool) in self.moveLeft()})
    }
    
    func moveLeft() {
        UIView.animateWithDuration(2.2, delay: 0, options: .CurveEaseInOut, animations: {
            self.blueCheetah.center = CGPointMake(self.view.frame.width/2 - 250, self.blueCheetah.center.y)
            self.redCheetah.center = CGPointMake(self.view.frame.width/2 - 250, self.redCheetah.center.y)
            }, completion: {(complete: Bool) in self.moveRight()})
        
    }
    
    
    
    
    
    
    //MARK: Realm Configuration
    
     //To set filename of default Realm to studyname_subjectnumber, stored at default location
    func setDefaultRealmForUser() {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.URLByDeletingLastPathComponent?.URLByAppendingPathComponent("eventsk1_\(trial.subjectNumber).realm")
        
        //set this as the configuration used at the default location
        Realm.Configuration.defaultConfiguration = config
        
        print(Realm.Configuration.defaultConfiguration.fileURL!) //prints database filepath to the console (simulator)
        NSLog("\n\nSubject Number: \(trial.subjectNumber)") //to aux file
        
    }

    
    
    
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        redirectLogToDocuments() //from this point forward
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        moveLeft()
    }
    
    func redirectLogToDocuments() {
        
        let allPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = allPaths.first!
        let pathForLog = documentsDirectory.stringByAppendingString("/logFile.txt")
        
        freopen(pathForLog.cStringUsingEncoding(NSASCIIStringEncoding)!, "a+", stderr)
    }

    
    
    
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMeetCheetahs" {
            setDefaultRealmForUser()
        }
    
        
        if let destination = segue.destinationViewController as? MeetCheetahsController {
            destination.trial = self.trial //pass subject instance to PVC
        }
        
    }

    
}



