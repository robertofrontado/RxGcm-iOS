//
//  AppGcmRefreshTokenReceiver.swift
//  Example
//
//  Created by Roberto Frontado on 4/5/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import RxSwift

class AppGcmRefreshTokenReceiver: NSObject, GcmRefreshTokenReceiver {

    func onTokenReceive(_ oTokenUpdate: Observable<TokenUpdate>) {
        oTokenUpdate.subscribe(onNext: { (tokenUpdate) -> Void in
            print("Token updated: \(tokenUpdate.getToken())")
        })
    }
}
