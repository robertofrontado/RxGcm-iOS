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
    @IBAction func sendNotification(_ sender: UIButton) {
        RxGcm.Notifications.onNotificationReceived([RxGcm.RX_GCM_KEY_TARGET:target])
    }

    // MARK: - GcmReceiverUIForeground
    func onTargetNotification(_ oMessage: Observable<RxMessage>) {
        oMessage.subscribe(onNext: { (message) -> Void in
            print("Target \(message)")
        })
    }
    
    func onMismatchTargetNotification(_ oMessage: Observable<RxMessage>) {
        oMessage.subscribe(onNext: { (message) -> Void in
            print("Mismatch \(message)")
        })
    }
    
    func matchesTarget(_ key: String) -> Bool {
        return target == key
    }
}

