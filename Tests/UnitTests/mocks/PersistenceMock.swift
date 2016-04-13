//
//  PersistenceMock.swift
//  RxGcm_swift
//
//  Created by Roberto Frontado on 4/6/16.
//  Copyright © 2016 Jaime Vidal. All rights reserved.
//

@testable import RxGcm_swift

class PersistenceMock: Persistence {

    var tokenMock: String?
    
    init(tokenMock: String?) {
        self.tokenMock = tokenMock
    }
    
    override func getToken() -> String? {
        return tokenMock
    }
}
