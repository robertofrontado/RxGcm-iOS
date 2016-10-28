//
//  GcmReceiverUIBackgroundMock.swift
//  RxGcm_swift
//
//  Created by Roberto Frontado on 4/6/16.
//  Copyright © 2016 Jaime Vidal. All rights reserved.
//

import RxSwift
@testable import RxGcm_swift

class GcmReceiverUIBackgroundMock: NSObject, GcmReceiverUIBackground {
    
    static var messages = [RxMessage]()
    static var onNotificationFinishTimeStamp: Double!
    
    static func reset() {
        messages = [RxMessage]()
        onNotificationFinishTimeStamp = nil
    }
    
    func onNotification(_ oMessage: Observable<RxMessage>) {
        oMessage.subscribe(onNext: ({ (message) -> Void in
            GcmReceiverUIBackgroundMock.messages.append(message)
            GcmReceiverUIBackgroundMock.onNotificationFinishTimeStamp = NSDate().timeIntervalSince1970
        }))
    }
}
