import UIKit

class PageViewController: UIViewController, UIPageViewControllerDataSource {
    
    // MARK: - Variables
    private var pageViewController: UIPageViewController?
    
    // Initialize it right away here
    private let contentArgazkia = ["BerriakPantaila.png", "AgendaPantaila.png", "ElkarteakPantaila.png", "HobespenakPantaila.png", "HobespenakPantaila.png", "HobespenakPantaila.png"]
    
    private let contentTituloa = ["Berriak", "Agenda", "Elkarteak", "Abisuak", "Hobespenak", ""]
    
    private let contentDeskribapena = ["Larrabetzun gertatzen diren berri",
        "Herrian datorren egunetan egongo diren ekintzak",
        "Elkarteen informazioa #eskura",
        "Ekitaldia bertan behera geratu badan, udaleko abisuk...",
        "Hobespenak",
        ""]
    
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
            pageController.setViewControllers(startingViewControllers as [AnyObject] , direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
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
        appearance.backgroundColor = UIColor.whiteColor()
    }
    
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
            for view in self.view.subviews {
                view.removeFromSuperview()
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> PageItemController? {
        
        if itemIndex < contentArgazkia.count {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("ItemController") as! PageItemController
            pageItemController.itemIndex = itemIndex
            pageItemController.argazkiaName = contentArgazkia[itemIndex]
            pageItemController.tituloaName = contentTituloa [itemIndex]
            pageItemController.deskribapenaName = contentDeskribapena[itemIndex]
            
            return pageItemController
        }
        
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return contentArgazkia.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func registerUserNotificationSettings(){
        let application = UIApplication.sharedApplication()
        if application.respondsToSelector("registerUserNotificationSettings:") {
            let types:UIUserNotificationType = (.Alert | .Badge | .Sound)
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
        } else {
            // Register for Push Notifications before iOS 8
            application.registerForRemoteNotificationTypes(.Alert | .Badge | .Sound)
        }
    }
    
}

