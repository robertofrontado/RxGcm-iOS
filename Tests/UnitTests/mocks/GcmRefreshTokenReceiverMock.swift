//
//  GcmRefreshTokenReceiverMock.swift
//  RxGcm_swift
//
//  Created by Roberto Frontado on 4/6/16.
//  Copyright © 2016 Jaime Vidal. All rights reserved.
//

import RxSwift
@testable import RxGcm_swift

class GcmRefreshTokenReceiverMock: NSObject, GcmRefreshTokenReceiver {
    
    static var tokenUpdate: TokenUpdate!
    static var feedbackMessage: String!
    
    static func reset() {
        tokenUpdate = nil
        feedbackMessage = nil
    }
    
    func onTokenReceive(oTokenUpdate: Observable<TokenUpdate>) {
        oTokenUpdate.subscribe(onNext: { (tokenUpdate) -> Void in
            GcmRefreshTokenReceiverMock.tokenUpdate = tokenUpdate
            }, onError: { (error) -> Void in
                GcmRefreshTokenReceiverMock.feedbackMessage = (error as NSError).domain
                GcmRefreshTokenReceiverMock.tokenUpdate = nil
        })
    }
}
