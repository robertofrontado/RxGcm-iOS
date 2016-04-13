//
//  RxGcm_swiftTests.swift
//  RxGcm_swiftTests
//
//  Created by Jaime Vidal on 4/4/16.
//  Copyright © 2016 Jaime Vidal. All rights reserved.
//

import XCTest
import Nimble
import RxSwift
@testable import RxGcm_swift

class RxGcm_swiftTests: XCTestCase {
    
    let tokenMock = "Token Mock"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testWhenNoSavedTokenCallGcmServerAndSaveIt() {

        RxGcm.Notifications.initForTesting(false, registrationToken: tokenMock, persistence: PersistenceMock(tokenMock: nil), getGcmReceiversUIForeground: GetGcmReceiversUIForegroundMock())
        
        var success = false
        RxGcm.Notifications.register(GcmReceiverDataMock.self, gcmReceiverUIBackgroundClass: GcmReceiverUIBackgroundMock.self)
            .subscribeNext { (token) -> Void in
                success = true
                expect(token).to(equal(self.tokenMock))
        }
        expect(success).toEventually(equal(true))
    }
    
    // When_No_Saved_Token_And_Call_GcmServer_Error_Emit_Error_But_Try_3_Times
    
    func testWhenSavedTokenNoCallGcmServerAndNotEmitItems() {

        RxGcm.Notifications.initForTesting(false, registrationToken: nil, persistence: PersistenceMock(tokenMock: tokenMock), getGcmReceiversUIForeground: GetGcmReceiversUIForegroundMock())
        
        var success = false
        RxGcm.Notifications.register(GcmReceiverDataMock.self, gcmReceiverUIBackgroundClass: GcmReceiverUIBackgroundMock.self)
            .subscribe(onNext: { (token) -> Void in
                assertionFailure()
                }, onCompleted: { () -> Void in
                    success = true
            })
        expect(success).toEventually(equal(true))
    }

    func testWhenCallCurrentTokenAndThereIsATokenEmitIt() {

        RxGcm.Notifications.initForTesting(false, registrationToken: tokenMock, persistence: PersistenceMock(tokenMock: tokenMock), getGcmReceiversUIForeground: GetGcmReceiversUIForegroundMock())
        
        var success = false
        RxGcm.Notifications.currentToken()
            .subscribeNext { (token) -> Void in
                success = true
        }
        
        expect(success).toEventually(equal(true))
    }
    
    // When_Call_Current_Token_And_There_Is_No_Token_Emit_Error_But_Try_3_Times

    func testWhenCallOnTokenRefreshEmitProperlyItem() {
        
        RxGcm.Notifications.onRefreshToken(GcmRefreshTokenReceiverMock.self)

        GcmRefreshTokenReceiverMock.reset()
        RxGcm.Notifications.initForTesting(false, registrationToken: tokenMock, persistence: PersistenceMock(tokenMock: tokenMock), getGcmReceiversUIForeground: GetGcmReceiversUIForegroundMock())
        RxGcm.Notifications.onTokenRefreshed()
        expect(GcmRefreshTokenReceiverMock.tokenUpdate).toEventually(beTruthy())
        expect(GcmRefreshTokenReceiverMock.tokenUpdate.getToken()).to(equal(tokenMock))
    
        GcmRefreshTokenReceiverMock.reset()
        RxGcm.Notifications.initForTesting(false, registrationToken: nil, persistence: PersistenceMock(tokenMock: nil), getGcmReceiversUIForeground: GetGcmReceiversUIForegroundMock())
        RxGcm.Notifications.onTokenRefreshed()
        expect(GcmRefreshTokenReceiverMock.feedbackMessage).toEventually(equal(Constants.ERROR_GCM_NOT_AVAILABLE))
        expect(GcmRefreshTokenReceiverMock.tokenUpdate).to(beNil())
    }
    
    func testWhenCallOnGcmReceiverUIBackgroundNotificationEmitProperlyItem() {
        
        GcmReceiverDataMock.reset()
        GcmReceiverUIBackgroundMock.reset()
        
        RxGcm.Notifications.initForTesting(true, registrationToken: tokenMock, persistence: PersistenceMock(tokenMock: tokenMock), getGcmReceiversUIForeground: GetGcmReceiversUIForegroundMock())
        
        RxGcm.Notifications.register(GcmReceiverDataMock.self, gcmReceiverUIBackgroundClass: GcmReceiverUIBackgroundMock.self).subscribe()
        
        let from1 = "MockServer1"
        RxGcm.Notifications.onNotificationReceived([RxGcm.RX_GCM_KEY_FROM: from1])

        let from2 = "MockServer2"
        RxGcm.Notifications.onNotificationReceived([RxGcm.RX_GCM_KEY_FROM: from2])
        
        //Check GcmReceiver
        expect(GcmReceiverDataMock.messages.count).toEventually(equal(2))
        expect(GcmReceiverDataMock.messages[0].getFrom()).to(equal(from1))
        expect(GcmReceiverDataMock.messages[1].getFrom()).to(equal(from2))
        
        //Check GcmReceiverBackgroundUI
        expect(GcmReceiverUIBackgroundMock.messages.count).toEventually(equal(2))
        expect(GcmReceiverUIBackgroundMock.messages[0].getFrom()).to(equal(from1))
        expect(GcmReceiverUIBackgroundMock.messages[1].getFrom()).to(equal(from2))
        
        //Check uireceiversbackground has been called only after receiver task has completed
        expect(GcmReceiverDataMock.onNotificationStartTimeStamp).to(beLessThan(GcmReceiverUIBackgroundMock.onNotificationFinishTimeStamp))
    }
    
    func testWhenCallOnGcmReceiverUIForegroundNotificationEmitProperlyItem() {
        
        GcmReceiverDataMock.reset()
        GcmReceiverUIForegroundMock.reset()
        
        RxGcm.Notifications.initForTesting(false, registrationToken: tokenMock, persistence: PersistenceMock(tokenMock: tokenMock), getGcmReceiversUIForeground: GetGcmReceiversUIForegroundMock())
        
        RxGcm.Notifications.register(GcmReceiverDataMock.self, gcmReceiverUIBackgroundClass: GcmReceiverUIBackgroundMock.self).subscribe()
        
        let from1 = "MockServer1"
        RxGcm.Notifications.onNotificationReceived([RxGcm.RX_GCM_KEY_FROM: from1])
        
        let from2 = "MockServer2"
        RxGcm.Notifications.onNotificationReceived([RxGcm.RX_GCM_KEY_FROM: from2])
        
        //Check GcmReceiver
        expect(GcmReceiverDataMock.messages.count).toEventually(equal(2))
        expect(GcmReceiverDataMock.messages[0].getFrom()).to(equal(from1))
        expect(GcmReceiverDataMock.messages[1].getFrom()).to(equal(from2))
        
        //Check GcmReceiverForegroundUI
        expect(GcmReceiverUIForegroundMock.messages.count).toEventually(equal(2))
        expect(GcmReceiverUIForegroundMock.messages[0].getFrom()).to(equal(from1))
        expect(GcmReceiverUIForegroundMock.messages[1].getFrom()).to(equal(from2))
        
        //Check uireceiversforeground has been called only after receiver task has completed
        expect(GcmReceiverDataMock.onNotificationStartTimeStamp).to(beLessThan(GcmReceiverUIForegroundMock.onNotificationFinishTimeStamp))
    }
    
}
