//
//  ViewController.swift
//  Example
//
//  Created by Roberto Frontado on 4/4/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController, GcmReceiverUIForeground {

    let target = GcmNotificationType.First.rawValue
    
    // MARK: - Actions
    @IBAction func sendNotification(sender: UIButton) {
        RxGcm.Notifications.onNotificationReceived([RxGcm.RX_GCM_KEY_TARGET:target])
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
    
    func matchesTarget(key: String) -> Bool {
        return target == key
    }
}

