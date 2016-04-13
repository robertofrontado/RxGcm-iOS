//
//  Persistence.swift
//  Example
//
//  Created by Roberto Frontado on 4/4/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift

class Persistence {
    
    func saveClassNameGcmReceiverAndGcmReceiverUIBackground(gcmReceiverClassName: String, gcmReceiverUIBackgroundClassName: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(gcmReceiverClassName, forKey: Constants.KEY_USER_DEFAULTS_CLASS_NAME_GCM_RECEIVER)
        userDefaults.setValue(gcmReceiverUIBackgroundClassName, forKey: Constants.KEY_USER_DEFAULTS_CLASS_NAME_GCM_RECEIVER_UI_BACKGROUND)
        userDefaults.synchronize()
    }
    
    func getClassNameGcmReceiver() -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        return userDefaults.stringForKey(Constants.KEY_USER_DEFAULTS_CLASS_NAME_GCM_RECEIVER)
    }
    
    func getClassNameGcmReceiverUIBackground() -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        return userDefaults.stringForKey(Constants.KEY_USER_DEFAULTS_CLASS_NAME_GCM_RECEIVER_UI_BACKGROUND)
    }
    
    func saveClassNameGcmRefreshTokenReceiver(name: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(name, forKey: Constants.KEY_USER_DEFAULTS_CLASS_NAME_GCM_REFRESH_TOKEN)
        userDefaults.synchronize()
    }
    
    func getClassNameGcmRefreshTokenReceiver() -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        return userDefaults.stringForKey(Constants.KEY_USER_DEFAULTS_CLASS_NAME_GCM_REFRESH_TOKEN)
    }
    
    func saveToken(token: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(token, forKey: Constants.KEY_USER_DEFAULTS_TOKEN)
    }
    
    func getToken() -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        return userDefaults.stringForKey(Constants.KEY_USER_DEFAULTS_TOKEN)
    }
    
}
