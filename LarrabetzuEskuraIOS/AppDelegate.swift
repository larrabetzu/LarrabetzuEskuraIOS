import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?


    var pushNotificationController:PushNotificationController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        self.pushNotificationController = PushNotificationController()
        
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        // Register for Push Notitications, if running iOS 8
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let types:UIUserNotificationType = (.Alert | .Badge | .Sound)
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
        } else {
            // Register for Push Notifications before iOS 8
            application.registerForRemoteNotificationTypes(.Alert | .Badge | .Sound)
        }
        
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
        let currentInstallation = PFInstallation.currentInstallation()
        if(currentInstallation.badge != 0){
            currentInstallation.badge = 0
            currentInstallation.saveEventually()
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        println("didRegisterForRemoteNotificationsWithDeviceToken")
        
        let currentInstallation = PFInstallation.currentInstallation()
        
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackgroundWithBlock { (succeeded, e) -> Void in
            //code
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("failed to register for remote notifications:  \(error)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println("didReceiveRemoteNotification")
        PFPush.handlePush(userInfo)
    }


}

