import UIKit

class BerriakViewController: GAITrackedViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var refreshControl:UIRefreshControl! 
    
    var posts :[Dictionary<String,String>] = []
    
    let grisaColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NabigationBar
        navigationController?.navigationBar.barTintColor = grisaColor
        navigationItem.title = "Larrabetzu #eskura"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        tabBarController?.tabBar.tintColor = UIColor.blackColor()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.whiteColor()
        self.refreshControl.backgroundColor = grisaColor
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(refreshControl, aboveSubview: tableView)
        
        if Internet.isConnectedToNetwork() {
            println("Interneta badago!")
            
            let berriakParseatu = Berriak()
            berriakParseatu.getPostak()
            self.posts = berriakParseatu.posts
            
            self.tableView.reloadData()
            self.hiddenEmptyCell()
            
            
            
        } else {
            println("Ez dago internetik")
            var alertInterneta = UIAlertController(title: "Ez daukazu internet konexiorik", message: "Aplikaziok internet konexioa behar du. Begiratu ondo dagoela.", preferredStyle: .Alert)
            alertInterneta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default , handler: nil))
            self.presentViewController(alertInterneta, animated: true, completion: nil)
        }
        self.hiddenEmptyCell()
        
        let previousAppVersion: Int = NSUserDefaults.standardUserDefaults().integerForKey("instaledAppVersion")
        if let text = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String {
            
            var actualVersionInt: Int! = text.toInt()
            if(actualVersionInt != previousAppVersion   ){
                let pageView  = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! PageViewController
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Berriak", style:.Plain, target:nil, action:nil)
                pageView.hidesBottomBarWhenPushed = true
                self.navigationController?.presentViewController(pageView, animated: true, completion: nil)
            }
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("viewWillAppear")
        navigationItem.title = "Larrabetzu #eskura"
        self.screenName = "Berriak"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return self.posts.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cellBerria")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        var image = UIImage(named: "Berrriak.png")
        let arrayPost = self.posts[indexPath.row]
            let bloganlinke : String = arrayPost["link"] as String!
            let title : String = arrayPost["title"] as String!
            let publishedDateString : String = arrayPost["publishedDate"] as String!
            
            cell.textLabel?.text = "\(title)"
            
            if(bloganlinke.hasPrefix("http://larrabetzutik.org/")){
                image = UIImage(named: "larrabetzutik")!
                
            }else if(bloganlinke.hasPrefix("http://horibai.org/")){
                image = UIImage(named: "horibai")!
                
            }else if(bloganlinke.hasPrefix("http://www.larrabetzukoeskola.org/")){
                image = UIImage(named: "eskola")!
                
            }else if(bloganlinke.hasPrefix("http://gaztelumendi.tumblr.com/")){
                image = UIImage(named: "iptx")!
                
            }else if(bloganlinke.hasPrefix("http://www.larrabetzuko-udala.com/")){
                image = UIImage(named: "udala")!
                
            }else if(bloganlinke.hasPrefix("http://www.literaturaeskola.org/")){
                image = UIImage(named: "literatura")!
                
            }else if(bloganlinke.hasPrefix("http://larrabetzuzerozabor.org/")){
                image = UIImage(named: "larrabetzuzerozabor")!
            }
        
        
        cell.imageView?.image = image
        
        return cell
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let webView : WebViewController = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
        webView.hidesBottomBarWhenPushed = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Berriak", style:.Plain, target:nil, action:nil)
        self.navigationController?.pushViewController(webView, animated: true)
        let arrayPost = self.posts[indexPath.row]
        let bloganlinke : String = arrayPost["link"] as String!
        webView.postLink = bloganlinke
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func getData(){
        if Internet.isConnectedToNetwork() {
            println("Interneta badago!")
            
            let berriakParseatu = Berriak()
            
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
                berriakParseatu.getPostak()
                self.posts = berriakParseatu.posts
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.hiddenEmptyCell()
                })
            })
            
        } else {
            println("Ez dago internetik")
            var alertInterneta = UIAlertController(title: "Ez daukazu internet konexiorik", message: "Aplikaziok internet konexioa behar du. Begiratu ondo dagoela.", preferredStyle: .Alert)
            alertInterneta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default , handler: nil))
            self.presentViewController(alertInterneta, animated: true, completion: nil)
        }
        self.hiddenEmptyCell()

    }
    
    
    func hiddenEmptyCell(){
        var tblView =  UIView(frame: CGRectZero)
        self.tableView.tableFooterView = tblView
        self.tableView.tableFooterView?.hidden = true
        self.tableView.backgroundColor = UIColor.clearColor()
    }
    
    func refresh(sender:AnyObject){
        getData()
        self.refreshControl.endRefreshing()
    }
    
}

