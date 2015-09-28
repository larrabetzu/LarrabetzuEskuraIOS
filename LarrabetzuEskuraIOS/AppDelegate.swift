import UIKit
import Siren
import Parse


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    var pushNotificationController:PushNotificationController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        application.statusBarStyle = .LightContent
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        
        
        self.pushNotificationController = PushNotificationController()
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        //Google Analytics
        GAI.sharedInstance().trackerWithTrackingId(valueForAPIKey(keyname: "GOOGLE_ANALYTICS-ID"))
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().dispatchInterval = 20
        GAI.sharedInstance().defaultTracker.allowIDFACollection = true
        GAI.sharedInstance().defaultTracker.send(GAIDictionaryBuilder.createEventWithCategory("ui_action", action: "app_launched",label:"launch",value:nil).build() as [NSObject : AnyObject])
        
        let siren = Siren.sharedInstance
        siren.appID = valueForAPIKey(keyname: "APP_ID")
        siren.alertType = .Option
        siren.forceLanguageLocalization = .Basque
        siren.checkVersion(.Weekly)
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("didRegisterForRemoteNotificationsWithDeviceToken")
        
        let currentInstallation = PFInstallation.currentInstallation()
        
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackgroundWithBlock { (succeeded, e) -> Void in
            //code
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("failed to register for remote notifications:  \(error)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject]) {
        print("didReceiveRemoteNotification")
        PFPush.handlePush(userInfo)
        if ( application.applicationState == UIApplicationState.Inactive || application.applicationState == UIApplicationState.Background ){
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo )
            
            print("\(userInfo)")
            if let url: String = userInfo["url"] as? String{
                print("\(url)")
                let urlNSURL = NSURL(string: url)!
                dispatch_async(dispatch_get_main_queue(), {
                    if (UIApplication.sharedApplication().canOpenURL(urlNSURL)){
                        UIApplication.sharedApplication().openURL(urlNSURL)
                    }
                })
            } 
        }
    }

}

