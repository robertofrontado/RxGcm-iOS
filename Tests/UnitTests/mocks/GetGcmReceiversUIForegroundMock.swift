//
//  GetGcmReceiversUIForegroundMock.swift
//  RxGcm_swift
//
//  Created by Roberto Frontado on 4/6/16.
//  Copyright © 2016 Jaime Vidal. All rights reserved.
//

@testable import RxGcm_swift

class GetGcmReceiversUIForegroundMock: GetGcmReceiversUIForeground {

    override func retrieve(screenName: String) -> (gcmReceiverUIForeground: GcmReceiverUIForeground, targetScreen: Bool)? {
        return (GcmReceiverUIForegroundMock(), false)
    }
}
