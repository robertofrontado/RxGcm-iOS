//
//  GetGcmReceiversUIForegroundMockWithReceivers.swift
//  RxGcm_swift
//
//  Created by Roberto Frontado on 4/7/16.
//  Copyright © 2016 Jaime Vidal. All rights reserved.
//

import RxSwift
@testable import RxGcm_swift

class GetGcmReceiversUIForegroundMockWithReceivers: GetGcmReceiversUIForeground {

    var testWithReceivers = true
    
    // Same implementation with little changes
    override func retrieve(screenName: String) -> (gcmReceiverUIForeground: GcmReceiverUIForeground, targetScreen: Bool)? {
        
        var receiverCandidate: (gcmReceiverUIForeground: GcmReceiverUIForeground, targetScreen: Bool)? = nil
        
        let viewControllers: [UIViewController]
        
        if testWithReceivers {
            viewControllers = getViewControllersReceivers()
        } else {
            viewControllers = getViewControllers()
        }
        
        for viewController in viewControllers {
            if let gcmReceiverUIForeground = viewController as? GcmReceiverUIForeground {
                
                let targetScreen = gcmReceiverUIForeground.target() == screenName
                receiverCandidate = (gcmReceiverUIForeground: gcmReceiverUIForeground, targetScreen: targetScreen)
                
                if targetScreen {
                    return receiverCandidate
                }
            }
        }
        
        return receiverCandidate
    }
    
    // MARK: - Private methods
    private func getViewControllersReceivers() -> [UIViewController] {
        let viewControllersReceivers = [
            ViewControllerMockReceiver1(nibName: nil, bundle: nil),
            ViewControllerMockReceiver2(nibName: nil, bundle: nil)
        ]
        return viewControllersReceivers
    }
    
    private func getViewControllers() -> [UIViewController] {
        let viewControllers = [
            ViewControllerMock(nibName: nil, bundle: nil),
            ViewControllerMock(nibName: nil, bundle: nil)
        ]
        return viewControllers
    }
    
    // MARK: - Internal classes
    
    class ViewControllerMockReceiver1: UIViewController, GcmReceiverUIForeground {
        
        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func onTargetNotification(oMessage: Observable<RxMessage>) {
            
        }
        
        func onMismatchTargetNotification(oMessage: Observable<RxMessage>) {
            
        }
        
        func target() -> String {
            return String(ViewControllerMockReceiver1.self)
        }
    }
    
    class ViewControllerMockReceiver2: UIViewController, GcmReceiverUIForeground {
        
        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func onTargetNotification(oMessage: Observable<RxMessage>) {
            
        }
        
        func onMismatchTargetNotification(oMessage: Observable<RxMessage>) {
            
        }
        
        func target() -> String {
            return String(ViewControllerMockReceiver2.self)
        }
    }
    
    class ViewControllerMock: UIViewController {
        
        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    

}
