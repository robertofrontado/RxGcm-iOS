//
//  SecondViewController.swift
//  Example
//
//  Created by Roberto Frontado on 4/5/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import RxSwift

class SecondViewController: UIViewController, GcmReceiverUIForeground {
    
    // MARK: - Actions
    @IBAction func sendNotification(sender: UIButton) {
        RxGcm.Notifications.onNotificationReceived([RxGcm.RX_GCM_KEY_TARGET:target()])
    }
    
    @IBAction func sendMismatchNotification(sender: UIButton) {
        RxGcm.Notifications.onNotificationReceived([RxGcm.RX_GCM_KEY_TARGET:"1"])
    }
    
    @IBAction func backButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - GcmReceiverUIForeground
    func onTargetNotification(oMessage: Observable<RxMessage>) {
        oMessage.subscribeNext { (message) -> Void in
            print("Target \(message)")
        }
    }
    
    func onMismatchTargetNotification(oMessage: Observable<RxMessage>) {
        oMessage.subscribeNext { (message) -> Void in
            print("Mismatch \(message)")
        }
    }
    
    func target() -> String {
        return "2"
    }

}
