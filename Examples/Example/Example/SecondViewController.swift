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
    
    let target = GcmNotificationType.Second.rawValue
    
    // MARK: - Actions
    @IBAction func sendNotification(_ sender: UIButton) {
        RxGcm.Notifications.onNotificationReceived([RxGcm.RX_GCM_KEY_TARGET:target])
    }
    
    @IBAction func sendMismatchNotification(_ sender: UIButton) {
        RxGcm.Notifications.onNotificationReceived([RxGcm.RX_GCM_KEY_TARGET:"1"])
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
