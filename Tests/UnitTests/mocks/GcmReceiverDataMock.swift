//
//  GcmReceiverDataMock.swift
//  RxGcm_swift
//
//  Created by Roberto Frontado on 4/6/16.
//  Copyright © 2016 Jaime Vidal. All rights reserved.
//

import RxSwift
@testable import RxGcm_swift

class GcmReceiverDataMock: NSObject, GcmReceiverData {

    static var messages = [RxMessage]()
    static var onNotificationStartTimeStamp: Double!
    
    static func reset() {
        messages = [RxMessage]()
        onNotificationStartTimeStamp = nil
    }
    
    func onNotification(_ oMessage: Observable<RxMessage>) -> Observable<RxMessage> {
        return oMessage.do(onNext: { (message) -> Void in
            GcmReceiverDataMock.messages.append(message)
            GcmReceiverDataMock.onNotificationStartTimeStamp = NSDate().timeIntervalSince1970
            sleep(1)
        })
    }
}
