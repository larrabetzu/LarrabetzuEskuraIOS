import UIKit

class PageViewController: UIViewController, UIPageViewControllerDataSource {
    
    // MARK: - Variables
    private var pageViewController: UIPageViewController?
    
    // Initialize it right away here
    private let contentArgazkia = ["BerriakPantaila.png", "AgendaPantaila.png", "ElkarteakPantaila.png", "AbisuakPantaila.png", "HobespenakPantaila.png"]
    
    private let contentTituloa = ["Berriak", "Agenda", "Elkarteak", "Abisuak", "Hobespenak"]
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let app = UIApplication.sharedApplication()
        app.setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        createPageViewController()
        setupPageControl()
    }
    
    override func viewWillDisappear(animated: Bool) {
        let app = UIApplication.sharedApplication()
        app.setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
    }
    
    
    private func createPageViewController() {
        
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        pageController.dataSource = self
        
        if contentArgazkia.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers: NSArray = [firstController]
            pageController.setViewControllers(startingViewControllers as? [UIViewController] , direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.darkGrayColor()
        appearance.backgroundColor = UIColor(red: 215/255, green: 219/255, blue: 215/255, alpha: 1)
    }
    
    // MARK: Delegates
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        
        if itemController.itemIndex+1 < contentArgazkia.count {
            if(itemController.itemIndex == 3){
                registerUserNotificationSettings()
            }
            return getItemController(itemController.itemIndex+1)
        }else{
            NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: Selector("dismissViews"), userInfo: nil, repeats: false)
        }
        
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return contentArgazkia.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // MARK: Functions
    private func getItemController(itemIndex: Int) -> PageItemController? {
        
        if itemIndex < contentArgazkia.count {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("ItemController") as! PageItemController
            pageItemController.itemIndex = itemIndex
            pageItemController.argazkiaName = contentArgazkia[itemIndex]
            pageItemController.tituloaName = contentTituloa [itemIndex]
            
            return pageItemController
        }
        
        return nil
    }
    
    func registerUserNotificationSettings(){
        let application = UIApplication.sharedApplication()
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let types:UIUserNotificationType = ([.Alert, .Badge, .Sound])
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
        }
    }
    
    func dismissViews(){
        if let text = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String {
            
            let appVersionInt: Int! = Int(text)
            let instaledAppVersion = NSUserDefaults.standardUserDefaults()
                instaledAppVersion.setInteger(appVersionInt, forKey: "instaledAppVersion")
                instaledAppVersion.synchronize()
        }
        
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

