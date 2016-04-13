//
//  AppGcmReceiverData.swift
//  Example
//
//  Created by Roberto Frontado on 4/4/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift

class AppGcmReceiverData: NSObject, GcmReceiverData {

    func onNotification(oMessage: Observable<RxMessage>) -> Observable<RxMessage> {
        return oMessage
    }
}
