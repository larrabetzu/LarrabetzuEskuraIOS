import UIKit
import Siren
import Parse
import Magic


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        application.statusBarStyle = .LightContent
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        
        //Parse.com config
        let parseApplicationId = valueForAPIKey(keyname: "PARSE_APPLICATION_ID")
        let parseClientKey     = valueForAPIKey(keyname: "PARSE_CLIENT_KEY")
        Parse.setApplicationId(parseApplicationId, clientKey: parseClientKey)
        
        if application.applicationState != UIApplicationState.Background {
            let preBackgroundPush = !application.respondsToSelector("backgroundRefreshStatus")
            let oldPushHandlerOnly = !self.respondsToSelector("application:didReceiveRemoteNotification:fetchCompletionHandler:")
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        
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
        let currentInstallation = PFInstallation.currentInstallation()
        if let tabBarController = window?.rootViewController as? UITabBarController {
            if(currentInstallation.badge != 0){
                (tabBarController.tabBar.items![3]).badgeValue = String(currentInstallation.badge)
            }else{
                (tabBarController.tabBar.items![3]).badgeValue = nil
            }
        }
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        magic("didRegisterForRemoteNotificationsWithDeviceToken")
        
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackground()
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            magic("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject]) {
        magic("didReceiveRemoteNotification")
        PFPush.handlePush(userInfo)
        if ( application.applicationState == UIApplicationState.Inactive || application.applicationState == UIApplicationState.Background ){
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo )
            
            magic("\(userInfo)")
            if let url: String = userInfo["url"] as? String{
                magic("\(url)")
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

