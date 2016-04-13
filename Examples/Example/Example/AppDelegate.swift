//
//  AppDelegate.swift
//  Example
//
//  Created by Roberto Frontado on 4/4/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    override internal class func initialize() {
        appDelegate = self
    }
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        RxGcm.Notifications.register(AppGcmReceiverData.self, gcmReceiverUIBackgroundClass: AppGcmReceiverUIBackground.self)
            .subscribe(
                onNext: { token in print(token) },
                onError: { error in print((error as NSError).domain) }
        )
        
        RxGcm.Notifications.onRefreshToken(AppGcmRefreshTokenReceiver.self)
        return true
    }
    

}
