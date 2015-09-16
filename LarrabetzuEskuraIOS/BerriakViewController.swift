import UIKit

class BerriakViewController: GAITrackedViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Constants and Variables
    @IBOutlet var tableView: UITableView!
    private var refreshControl:UIRefreshControl!
    private let grisaColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    private let berriakParseatu : Berriak = Berriak()
    
    // MARK: lifeCycle
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
        
        if Internet.isConnectedToNetwork() {
            
            berriakParseatu.getPostak()
            self.tableView.reloadData()
            self.hiddenEmptyCell()
            
        } else {
            print("Ez dago internetik")
            let alertInterneta = UIAlertController(title: "Ez daukazu internet konexiorik", message: "Aplikaziok internet konexioa behar du. Begiratu ondo dagoela.", preferredStyle: .Alert)
            alertInterneta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default , handler: nil))
            self.presentViewController(alertInterneta, animated: true, completion: nil)
        }
        self.hiddenEmptyCell()
        
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        navigationItem.title = "Larrabetzu #eskura"
        self.screenName = "Berriak"
    }
    
    override func viewDidAppear(animated: Bool) {
        self.appPresentation()
    }
    
    // MARK: Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return berriakParseatu.getPostNumeroa()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cellBerria")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        let postBat = berriakParseatu.getPostBat(indexPath.row)
            
        cell.textLabel?.text = postBat.title
        cell.imageView?.image = postBat.image
        
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let webView : WebViewController = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        webView.hidesBottomBarWhenPushed = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Berriak", style:.Plain, target:nil, action:nil)
        self.navigationController?.pushViewController(webView, animated: true)
        webView.postLink = berriakParseatu.getLink(indexPath.row)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    // MARK: Functions
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
            print("Ez dago internetik")
            let alertInterneta = UIAlertController(title: "Ez daukazu internet konexiorik", message: "Aplikaziok internet konexioa behar du. Begiratu ondo dagoela.", preferredStyle: .Alert)
            alertInterneta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default , handler: nil))
            self.presentViewController(alertInterneta, animated: true, completion: nil)
        }
        self.hiddenEmptyCell()

    }
    
    private func hiddenEmptyCell(){
        let tblView =  UIView(frame: CGRectZero)
        self.tableView.tableFooterView = tblView
        self.tableView.tableFooterView?.hidden = true
        self.tableView.backgroundColor = UIColor.clearColor()
    }
    
    func refresh(sender:AnyObject){
        getData()
        self.refreshControl.endRefreshing()
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

