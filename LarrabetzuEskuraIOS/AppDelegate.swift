import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    override class func initialize(){
        setupSARate()
    }
    
    class func setupSARate(){
        
        SARate.sharedInstance().previewMode = false
        //configure
        SARate.sharedInstance().daysUntilPrompt = 5
        SARate.sharedInstance().usesUntilPrompt = 5
        SARate.sharedInstance().remindPeriod = 30
        SARate.sharedInstance().promptForNewVersionIfUserRated = true
        //enable preview mode
        SARate.sharedInstance().email = "ercillagorka@gmail.com"
        // 4 and 5 stars
        SARate.sharedInstance().minAppStoreRaiting = 4
        let mainBundle = NSBundle.mainBundle()
        
        SARate.sharedInstance().emailText = "Desabantailak: "
        SARate.sharedInstance().headerLabelText = "Aplikazioa atsegin duzu?"
        SARate.sharedInstance().descriptionLabelText = "Ikutu izarrak baloratzeko."
        SARate.sharedInstance().rateButtonLabelText = "Puntuatu"
        SARate.sharedInstance().cancelButtonLabelText = "Orain ez"
        SARate.sharedInstance().setRaitingAlertTitle = "Baloratu"
        SARate.sharedInstance().setRaitingAlertMessage = "Ikutu izarrak baloratzeko."
        SARate.sharedInstance().appstoreRaitingAlertTitle = "AppStoren zure iritzia idatzi"
        SARate.sharedInstance().appstoreRaitingAlertMessage = "Aplikazioa AppStoren baloratzeko momentu bat daukazu? Ez dizu minutu bat baino gehiago eramango. Eskerrik asko zure laguntzagatik!"
        SARate.sharedInstance().appstoreRaitingCancel = "Ezeztatu"
        SARate.sharedInstance().appstoreRaitingButton = "Baloratu orain"
        SARate.sharedInstance().disadvantagesAlertTitle = "Desabantailak"
        SARate.sharedInstance().disadvantagesAlertMessage = "Mesedez, zehaztu aplikazioaren gabeziak. Konpontzen saiatuko gara!"
    }
    
    
    var window: UIWindow?


    var pushNotificationController:PushNotificationController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        application.statusBarStyle = .LightContent
        var navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        
        
        self.pushNotificationController = PushNotificationController()
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        //Google Analytics
        GAI.sharedInstance().trackerWithTrackingId(valueForAPIKey(keyname: "GOOGLE_ANALYTICS-ID"))
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().dispatchInterval = 20
        GAI.sharedInstance().defaultTracker.allowIDFACollection = true
        GAI.sharedInstance().defaultTracker.send(GAIDictionaryBuilder.createEventWithCategory("ui_action", action: "app_launched",label:"launch",value:nil).build() as [NSObject : AnyObject])
        
        //https://github.com/ArtSabintsev/Siren
        let siren = Siren.sharedInstance
        siren.appID = valueForAPIKey(keyname: "APP_ID")
        siren.presentingViewController = window?.rootViewController
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
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject]) {
        println("didReceiveRemoteNotification")
        PFPush.handlePush(userInfo)
        if ( application.applicationState == UIApplicationState.Inactive || application.applicationState == UIApplicationState.Background ){
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo )
            
            println("\(userInfo)")
            if var url: String = userInfo["url"] as? String{
                println("\(url)")
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

