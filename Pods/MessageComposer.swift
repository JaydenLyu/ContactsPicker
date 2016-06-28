//
//  MessageComposer.swift
//  Contacts Picker
//
//  Created by Jibin Lyu on 6/27/16.
//  Copyright © 2016 Prabaharan Elangovan. All rights reserved.
//

import Foundation
import MessageUI

// let textMessageRecipients = ["1-213-422-6873"] // for pre-populating the recipients list 

class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate {
    
    // A wrapper function to indicate whether or not a text message can be sent from the user's device
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController(recipients: [String]) -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        messageComposeVC.recipients = recipients
        messageComposeVC.body = "Hey, my friend! Strongly invite you to join our party on Banger (Link)."
        return messageComposeVC
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}