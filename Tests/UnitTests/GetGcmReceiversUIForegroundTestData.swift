//
//  GetGcmReceiversUIForegroundTestData.swift
//  RxGcm_swift
//
//  Created by Roberto Frontado on 4/6/16.
//  Copyright © 2016 Jaime Vidal. All rights reserved.
//

import XCTest
import Nimble
import RxSwift
@testable import RxGcm_swift

class GetGcmReceiversUIForegroundTestData: XCTestCase {
    
    fileprivate var getGcmReceiversUIForegroundMockWithReceivers: GetGcmReceiversUIForegroundMockWithReceivers!
    
    override func setUp() {
        super.setUp()
        getGcmReceiversUIForegroundMockWithReceivers = GetGcmReceiversUIForegroundMockWithReceivers()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testWhenSeveralGcmReceiverUIForegroundReturnOneWhichIsTargetScreen() {
        
        getGcmReceiversUIForegroundMockWithReceivers.testWithReceivers = true
        
        var targetScreen = String(describing: GetGcmReceiversUIForegroundMockWithReceivers.ViewControllerMockReceiver1.self)
        var wrapper = getGcmReceiversUIForegroundMockWithReceivers.retrieve(targetScreen)!
        expect(wrapper.targetScreen).to(beTrue())
//        expect(wrapper.gcmReceiverUIForeground)
//            .to(beAKindOf(GetGcmReceiversUIForegroundMockWithReceivers.ViewControllerMockReceiver1.self))
        assert(wrapper.gcmReceiverUIForeground is GetGcmReceiversUIForegroundMockWithReceivers.ViewControllerMockReceiver1)
        
        targetScreen = String(describing: GetGcmReceiversUIForegroundMockWithReceivers.ViewControllerMockReceiver2.self)
        wrapper = getGcmReceiversUIForegroundMockWithReceivers.retrieve(targetScreen)!
        expect(wrapper.targetScreen).to(beTrue())
//        expect(wrapper.gcmReceiverUIForeground)
//            .to(beAKindOf(GetGcmReceiversUIForegroundMockWithReceivers.ViewControllerMockReceiver2.self))
        assert(wrapper.gcmReceiverUIForeground is GetGcmReceiversUIForegroundMockWithReceivers.ViewControllerMockReceiver2)
    }
    
    func testWhenSeveralGcmReceiverUIForegroundReturnButNoOneIsTargetScreenReturnSomeOne() {
        
        getGcmReceiversUIForegroundMockWithReceivers.testWithReceivers = true
        
        let wrapper = getGcmReceiversUIForegroundMockWithReceivers.retrieve("no one")!
        expect(wrapper.targetScreen).to(beFalse())
//        expect(wrapper.gcmReceiverUIForeground)
//            .to(beAKindOf(GetGcmReceiversUIForegroundMockWithReceivers.ViewControllerMockReceiver2.self))
        assert(wrapper.gcmReceiverUIForeground is GetGcmReceiversUIForegroundMockWithReceivers.ViewControllerMockReceiver2)
    }
    
    func testWhenNoOneGcmReceiverUIForegroundReturnNullWrapper() {
        
        getGcmReceiversUIForegroundMockWithReceivers.testWithReceivers = false
        let wrapper = getGcmReceiversUIForegroundMockWithReceivers.retrieve("no one")
        expect(wrapper).to(beNil())
        
    }
}
