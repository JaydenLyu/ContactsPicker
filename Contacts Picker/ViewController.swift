//
//  ViewController.swift
//  EPContacts
//
//  Created by Jibin Lyu on 06/28/16.
//  Copyright © 2015 Prabaharan Elangovan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, EPPickerDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
    
  var finalSelectedNumbers = [String]()
    
  @IBAction func onTouchShowMeContactsButton(sender: AnyObject) {
    
    let contactPickerScene = EPContactsPicker(delegate: self, multiSelection:true, subtitleCellType: SubtitleCellValue.PhoneNumber)
    let navigationController = UINavigationController(rootViewController: contactPickerScene)
    self.presentViewController(navigationController, animated: true, completion: nil)
    
  }
    
// MARK: EPContactsPicker delegates
    func epContactPicker(_: EPContactsPicker, didContactFetchFailed error : NSError)
    {
        print("Failed with error \(error.description)")
    }
    
//    func epContactPicker(_: EPContactsPicker, didSelectContact contact : EPContact)
//    {
//        print("Contact \(contact.displayName()) has been selected")
//    }
    
    func epContactPicker(_: EPContactsPicker, didCancel error : NSError)
    {
        print("User canceled the selection");
    }
    
    func epContactPicker(_: EPContactsPicker, didSelectMultipleContacts contacts: [EPContact]) {
        
        finalSelectedNumbers = [String]()  // declared outside
        var needToSelectNames = [String]()
        var needToSelectNumbers = [[String]]()
        
        for contact in contacts {
            let contactName = contact.displayName()
            let multiNumbersCount = contact.phoneNumbers.count

            if (multiNumbersCount == 1) {
                finalSelectedNumbers.append(contact.phoneNumbers[0].0)
            }
            else if (multiNumbersCount > 1) {
                print ("\(contactName) has multiple phone numbers")
                var contactNumbers = [String]()
                for i in 0...multiNumbersCount - 1 {
                    contactNumbers.append(contact.phoneNumbers[i].0)
                }
                needToSelectNames.append(contactName)
                needToSelectNumbers.append(contactNumbers)
            }
        }
        
        // If there is multi numbers of one friend, show the alert to choose
        if (needToSelectNames.count > 0) {
            
            showAlertToChoose(needToSelectNames, needToSelectNumbers: needToSelectNumbers)
            
        }
        
    }
    
    func showAlertToChoose(var needToSelectNames:[String], var needToSelectNumbers:[[String]]) {

        if let name = needToSelectNames.first {
            let multiplePhoneNumbersAlert = UIAlertController(title: "Which one?", message: "\(name) has multiple phone numbers, which one do you want to use?", preferredStyle: UIAlertControllerStyle.Alert)
            // Loop through all the phone numbers that we got back
            for number in needToSelectNumbers[0] {
                let numberAction = UIAlertAction(title: number, style: UIAlertActionStyle.Default, handler: { (theAction) -> Void in
                    self.finalSelectedNumbers.append(number)
                    needToSelectNames.removeAtIndex(0)
                    needToSelectNumbers.removeAtIndex(0)
                    self.showAlertToChoose(needToSelectNames, needToSelectNumbers: needToSelectNumbers)
                    
                })
                //Add the action to the AlertController
                multiplePhoneNumbersAlert.addAction(numberAction)
            }
            
            //Add a cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (theAction) -> Void in
                //Cancel action completion
                needToSelectNames.removeAtIndex(0)
                needToSelectNumbers.removeAtIndex(0)
                self.showAlertToChoose(needToSelectNames, needToSelectNumbers: needToSelectNumbers)
            })
            //Add the cancel action to AlertController
            multiplePhoneNumbersAlert.addAction(cancelAction)
            //Present the Alert controller
            dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(multiplePhoneNumbersAlert, animated: true, completion: nil)
            })
        
        }
    }
    
    
    func presentAlertWithTitle(msg:String) {
        let alert:UIAlertController =  UIAlertController(title: msg, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let action: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (a: UIAlertAction) in
        })
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    let messageComposer = MessageComposer()
    
    func sendTextMessage(recipients:[String]) {
        
        // Make sure the device can send text messages
        if ((recipients.count > 0) && messageComposer.canSendText()) {
            // Obtain a configured MFMessageComposeViewController
            let messageComposeVC = messageComposer.configuredMessageComposeViewController(recipients)
            
            // Present the configured MFMessageComposeViewController instance
            // Note that the dismissal of the VC will be handled by the messageComposer instance,
            // since it implements the appropriate delegate call-back
            presentViewController(messageComposeVC, animated: true, completion: nil)
        } else {
            // Let the user know if his/her device isn't able to send text messages
            presentAlertWithTitle("Cannot Send Text Message")
        }
    }
    
    
    @IBAction func onTouchSendMessage(sender: AnyObject) {
        print(finalSelectedNumbers)
        sendTextMessage(finalSelectedNumbers)
        
    }
    
    

}