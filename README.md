
# RxGcm
RxSwift extension for Gcm which acts as an architectural approach to easily satisfy the requirements of an iOS app when dealing with push notifications.

## Features:
* Remove iOS boilerplate code (not need to do the dirty configuration in the AppDelegate).
* Decouple presentation responsibilities from data responsibilities when receiving notifications.
* Deploy a targeting strategy to aim for the desired ViewController when receiving notifications.

## Setup
Due to a limitation with Google/CloudMessaging it is not in cocoapods yet, 

So to use this you need to add the Sources folder to your project, add this dependencies to your podfile

```swift
pod 'Google/CloudMessaging'
pod 'RxSwift', '~> 3.0'
```

There is, thought, one step behind which RxGcm can't do for you. You need to create a [google-services.json](https://developers.google.com/cloud-messaging/ios/client) configuration file and place it in your iOS application. (You can create and download it from [here](https://developers.google.com/mobile/add?platform=android&cntapi=gcm&cnturl=https:%2F%2Fdevelopers.google.com%2Fcloud-messaging%2Fandroid%2Fclient&cntlbl=Continue%20Adding%20GCM%20Support&%3Fconfigured%3Dtrue))

## Usage

### GcmReceiverData
[GcmReceiverData](https://github.com/FuckBoilerplate/RxGcm-iOS/blob/master/Sources/GcmReceiverData.swift) implementation should be responsible for **updating the data models**. The `onNotification` method requires to return an instance of the `observable` supplied as argument, after applying `doOn` operator to perform the update action: 

```swift
class AppGcmReceiverData: NSObject, GcmReceiverData {

    func onNotification(_ oMessage: Observable<RxMessage>) -> Observable<RxMessage> {
        return oMessage.doOn(onNext: { message in print(message)})
    }
}
```

The `observable` type is an instance of [RxMessage](https://github.com/FuckBoilerplate/RxGcm-iOS/blob/master/Sources/RxMessage.swift), which holds a Rreference to the notification (payload) and a method called `getTarget()`, which returns the key associated with this notification.

```swift
class AppGcmReceiverData: NSObject, GcmReceiverData {

    func onNotification(_ oMessage: Observable<RxMessage>) -> Observable<RxMessage> {
        return oMessage.do(onNext: { (message) -> Void in
            
            let payload = message.getPayload()
            
            let title = payload["title"]
            let body = payload["body"]
            
            if message.getTarget() == "issues" {
                SimpleCache.addIssue(Notification(title, body: body))
            } else if message.getTarget() == "supplies" {
                SimpleCache.addSupply(Notification(title, body: body))
            }
        }
}

```

To RxGcm be able to return a not `nil` value when calling `getTarget()` method, you need to add the key **rx_gcm_key_target** to the payload of the push notification:
 
```json            
{ 
  "data": {
    "title":"A title 4",
    "body":"A body 4",
    "rx_gcm_key_target":"supplies"
  },
  "to":"token_device"
  }
}
```

If **rx_gcm_key_target** is not added to the json payload, you will get a `nil` value when calling `getTargeth()` method. So, you can ignore this, but you would be missing the benefits of the targeting strategy.

### GcmReceiverUIBackground and GcmReceiverUIForeground
Both of them will be called only after `GcmReceiverData` `observable` has reached `onCompleted()` state. This way it’s safe to assume that any operation related to updating the data model has been successfully achieved, and now it’s time to reflect these updates in the presentation layer. 

#### GcmReceiverUIBackground
`GcmReceiverUIBackground` implementation will be called when a notification is received and the application is in the background. Probably the implementation class will be responsable for building and showing system notifications. 

```swift
class AppGcmReceiverUIBackground: NSObject, GcmReceiverUIBackground {

    func onNotification(_ oMessage: Observable<RxMessage>) {
        oMessage.subscribe(onNext: { message in buildAndShowNotification(message) })
    }
}

```

#### GcmReceiverUIForeground
`GcmReceiverUIForeground` implementation will be called when a notification is received and the application is in the foreground. The implementation class must inherits from an `UIViewController` . `GcmReceiverUIForeground` exposes a method called `target()`, which forces to the implementation class to return a string. 

RxGcm internally compares this string to the value of the **rx_gcm_key_target** node payload notification. If the current `UIViewController` `target()` method value matches with the one of **rx_gcm_key_target** node, `onTargetNotification()` method will be called, otherwise `onMismatchTargetNotification()` method will be called. 

```swift
class IssuesViewController: UIViewController, GcmReceiverUIForeground {

    func onTargetNotification(_ oRxMessage: Observable<RxMessage>) {
        oMessage.subscribe(onNext: { (message) -> Void in
            // Update views
        })
    }
    
    func onMismatchTargetNotification(_ oRxMessage: Observable<RxMessage>) {
        oMessage.subscribe(onNext: { (message) -> Void in
            self.showAlert(message)
        })
    }
    
    func matchesTarget(_ key: String) -> Bool {
            return "issues" == key
    }
}
```

```swift
class SuppliesViewController: UIViewController, GcmReceiverUIForeground {

    func onTargetNotification(_ oRxMessage: Observable<RxMessage>) {
        oMessage.subscribe(onNext: { (message) -> Void in
            // Update views
        })
    }
    
    func onMismatchTargetNotification(_ oRxMessage: Observable<RxMessage>) {
        oMessage.subscribe(onNext: { (message) -> Void in
            self.showAlert(message)
        })
    }
    
    
    func matchesTarget(_ key: String) -> Bool {
            return "suplies" == key
    }
}
```

### RefreshTokenReceiver
[GcmRefreshTokenReceiver](https://github.com/FuckBoilerplate/RxGcm-iOS/blob/master/Sources/GcmRefreshTokenReceiver.swift) implementation will be called when the token has been updated. As the [documentation](https://developers.google.com/cloud-messaging/ios/start) points out, the token device may need to be refreshed for some particular reason. 

```java
class AppGcmRefreshTokenReceiver: NSObject, GcmRefreshTokenReceiver {

    func onTokenReceive(_ oTokenUpdate: Observable<TokenUpdate>) {
        oTokenUpdate.subscribe(onNext: { tokenUpdate in }
            , onError: { error in })
    }
}
```
 
### Retrieving current token 
If at some point you need to retrieve the gcm token device -e.g for updating the value on your server, you could do it easily calling [RxGcm.Notifications.currentToken](https://github.com/FuckBoilerplate/RxGcm-iOS/blob/master/Sources/RxGcm.swift#L83):

```swift
    RxGcm.Notifications.currentToken().subscribe(
                onNext: { tokenUpdate in }
                , onError: { error in }
            )
```

### Register RxGcm classes
Once you have implemented `GcmReceiverData` and `GcmReceiverUIBackground` interfaces is time to register them in your iOS `AppDelegate` class calling [RxGcm.Notifications.register](https://github.com/FuckBoilerplate/RxGcm-iOS/blob/master/Sources/RxGcm.swift#L55). Plus, register `RefreshTokenReceiver` implementation too at this point. 
   
```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:[UIApplicationLaunchOptionsKey:Any]?) -> Bool {
        // Override point for customization after application launch.
        RxGcm.Notifications.register(AppGcmReceiverData.self, gcmReceiverUIBackgroundClass: AppGcmReceiverUIBackground.self)
            .subscribe(
                onNext: { token in print(token) },
                onError: { error in print((error as NSError).domain) }
        )
        
        RxGcm.Notifications.onRefreshToken(AppGcmRefreshTokenReceiver.self)
        return true
    }
}
```

**Note:** If your `UIApplicationDelegate` is not called **AppDelegate** you should implement the initialize method and set the `appDelegate` as self
```swift
@UIApplicationMain
class CustomAppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    override internal class func initialize() {
        appDelegate = self
    }
    
    ...
```    

**Important:** The `observable` returned by `RxGcm.Notifications.register()`method will not emit the token twice. It means that it will be emit the token only the first time 
RxGgm asks to Google for a token. But if the token is already cached, the observable will complete without emitting the item. 

### Threading
RxGcm uses internally [RxSwift](https://github.com/ReactiveX/RxSwift). Thanks to this, each observable created by RxGcm observes on the Main Thread and subscribe on an Serial thread. 
This means you do not need to worry about threading and sync. But if you need to change this behaviour, you can do it easily setting in which scheduler the observable needs to observe and subscribe.

## Examples
There is a complete example of RxGcm in the [app module](https://github.com/FuckBoilerplate/RxGcm-iOS/tree/master/Examples/Example). Plus, it has an integration test

## Testing notification
You can easily [send http post request](https://developers.google.com/cloud-messaging/downstream) to Google Cloud Messaging server using Postman or Advanced Rest Client.
Or you can send directly push notifications using [this page](http://1-dot-sigma-freedom-752.appspot.com/gcmpusher.jsp). 

## Author
**Roberto Frontado**
* <https://linkedin.com/in/robertofrontado>
* <https://github.com/robertofrontado>
* <https://twitter.com/robertofrontado>

# Another author's libraries using RxSwift:

 - [BaseApp-iOS](https://github.com/FuckBoilerplate/base_app_ios): Base skeleton structure to start every new iOS project
 - [OkDataSources](https://github.com/FuckBoilerplate/OkDataSources): Wrappers for iOS TableView and CollectionView DataSources to simplify its api at a minimum. Also it has a cool PagerView and SlidingTabs!
 - [RxSocialConnect-iOS](https://github.com/FuckBoilerplate/RxSocialConnect-iOS): OAuth RxSwift extension for iOS.
