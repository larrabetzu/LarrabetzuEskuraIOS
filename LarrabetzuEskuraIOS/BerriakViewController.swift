import UIKit
import SafariServices
import Parse
import Magic


class BerriakViewController: GAITrackedViewController, UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate{

    
    // MARK: Constants and Variables
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var argazkiaUIImageView: UIImageView!
    private var refreshControl:UIRefreshControl!
    private let grisaColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    private let berriakParseatu : Berriak = Berriak()
    private var linkConfig : String?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NabigationBar
        navigationController?.navigationBar.barTintColor = grisaColor
        navigationItem.title = "Larrabetzu #eskura"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        tabBarController?.tabBar.tintColor = UIColor.blackColor()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.whiteColor()
        self.refreshControl.backgroundColor = grisaColor
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(refreshControl, aboveSubview: tableView)

        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        gesture.addTarget(self, action: "imageTap")
        argazkiaUIImageView.addGestureRecognizer(gesture)
        argazkiaUIImageView.userInteractionEnabled = true
        
        
        if Internet.isConnectedToNetwork() {
            self.getData()
            self.getMenukoArgazkia()
            
        } else {
            magic("Ez dago internetik")
            let alertInterneta = UIAlertController(title: "Ez daukazu internet konexiorik", message: "Aplikaziok internet konexioa behar du. Begiratu ondo dagoela.", preferredStyle: .Alert)
            alertInterneta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default , handler: nil))
            self.presentViewController(alertInterneta, animated: true, completion: nil)
        }
        self.hiddenEmptyCell()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        magic("viewWillAppear")
        navigationItem.title = "Larrabetzu #eskura"
        self.screenName = "Berriak"
    }
    
    override func viewDidAppear(animated: Bool) {
        self.appPresentation()
    }
    
    // MARK: - Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return berriakParseatu.getPostNumeroa()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cellBerria")
        let postBat = berriakParseatu.getPostBat(indexPath.row)
            
        cell.textLabel?.text = postBat.title
        cell.imageView?.image = postBat.image
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.openWeb(berriakParseatu.getLink(indexPath.row))
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController){
        controller.dismissViewControllerAnimated(true, completion: nil)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    // MARK: - Functions
    private func getData(){
        if Internet.isConnectedToNetwork() {
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
                self.berriakParseatu.getPostak()
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.hiddenEmptyCell()
                })
            })
            
        } else {
            magic("Ez dago internetik")
            let alertInterneta = UIAlertController(title: "Ez daukazu internet konexiorik", message: "Aplikaziok internet konexioa behar du. Begiratu ondo dagoela.", preferredStyle: .Alert)
            alertInterneta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default , handler: nil))
            self.presentViewController(alertInterneta, animated: true, completion: nil)
        }
        self.hiddenEmptyCell()

    }
    
    func refresh(sender:AnyObject){
        getData()
        self.refreshControl.endRefreshing()
    }
    
    func imageTap() {
        if let link = self.linkConfig{
            self.openWeb(link)
        }
    }
    
    private func openWeb(link: String){
        let svc = SFSafariViewController(URL: NSURL(string: link)!)
        svc.view.tintColor = UIColor.darkGrayColor()
        svc.delegate = self
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.presentViewController(svc, animated: true, completion: nil)
    }
    
    private func getMenukoArgazkia(){
        PFConfig.getConfigInBackgroundWithBlock {
            (var config: PFConfig?, error: NSError?) -> Void in
            if error != nil {
                config = PFConfig.currentConfig()
            }
            let noizArte = config?["noizArte"] as? NSDate
            let oraingoData = NSDate()
            
            let compareResult = noizArte?.compare(oraingoData)
            if compareResult == NSComparisonResult.OrderedDescending {
                let link = config?["menukoLinka"] as? String
                self.linkConfig = link
                
                let argazkia = config?["menukoArgazkia"] as? PFFile
                argazkia?.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            self.argazkiaUIImageView.image = UIImage(data:imageData)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Design Functions
    private func hiddenEmptyCell(){
        let tblView =  UIView(frame: CGRectZero)
        self.tableView.tableFooterView = tblView
        self.tableView.tableFooterView?.hidden = true
        self.tableView.backgroundColor = UIColor.clearColor()
    }
    
    private func appPresentation(){
        let previousAppVersion: Int = NSUserDefaults.standardUserDefaults().integerForKey("instaledAppVersion")
        if (previousAppVersion == 0){
            let pageView  = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! PageViewController
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Berriak", style:.Plain, target:nil, action:nil)
            pageView.hidesBottomBarWhenPushed = true
            self.navigationController?.presentViewController(pageView, animated: true, completion: nil)
        }
    }
}

