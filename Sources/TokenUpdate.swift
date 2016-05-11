//
//  TokenUpdate.swift
//  RxGcm
//
//  Created by Roberto Frontado on 4/4/16.
//  Copyright © 2016 Roberto Frontado. All rights reserved.
//

import Foundation

public class TokenUpdate {
    
    private let token: String!
    
    init(token: String){
        self.token = token
    }
    
    public func getToken() -> String {
        return token
    }
}