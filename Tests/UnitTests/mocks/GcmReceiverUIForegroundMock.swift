//
//  GcmReceiverUIForegroundMock.swift
//  RxGcm_swift
//
//  Created by Roberto Frontado on 4/6/16.
//  Copyright © 2016 Jaime Vidal. All rights reserved.
//

import RxSwift
@testable import RxGcm_swift

class GcmReceiverUIForegroundMock: GcmReceiverUIForeground {
    
    static var messages = [RxMessage]()
    static var onNotificationFinishTimeStamp: Double!
    
    static func reset() {
        messages = [RxMessage]()
        onNotificationFinishTimeStamp = nil
    }
    
    func onTargetNotification(oMessage: Observable<RxMessage>) {
        
    }
    
    func onMismatchTargetNotification(oMessage: Observable<RxMessage>) {
        oMessage.subscribeNext({ (message) -> Void in
            GcmReceiverUIForegroundMock.messages.append(message)
            GcmReceiverUIForegroundMock.onNotificationFinishTimeStamp = NSDate().timeIntervalSince1970
        })
    }
    
    func matchesTarget(key: String) -> Bool {
        return "GcmReceiverMockUI" == key
    }
}
