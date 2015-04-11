import UIKit

class EkintzakViewController : GAITrackedViewController, UITableViewDelegate , UITableViewDataSource {
    
    // MARK: Constants and Variables
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    private var refreshControl:UIRefreshControl!
    private let grisaColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    private var ekintzakParseatu : Ekintzak = Ekintzak()
    
    // MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad")
        
        //NabigationBar
        navigationController?.navigationBar.barTintColor = grisaColor
        navigationItem.title = "Agenda"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        activityIndicator.startAnimating()
        tableView.hidden = true
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = UIColor.whiteColor()
        self.refreshControl.backgroundColor = grisaColor
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(refreshControl, aboveSubview: tableView)
        
        getData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "Agenda"
    }

    // MARK: Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return ekintzakParseatu.getEkintzaNumeroa()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:EkintzakTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("EkintzakCustomTableViewCell") as! EkintzakTableViewCell
        let ekintza = ekintzakParseatu.getEkintzaCell(indexPath.row)
        cell.loadItem(tituloa: ekintza.tituloa, ordua: ekintza.ordua, eguna: ekintza.eguna, lekua: ekintza.lekua)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let ekintzaView : EkintzaViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EkintzaViewController") as! EkintzaViewController
        ekintzaView
        ekintzaView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ekintzaView, animated: true)
        ekintzaView.SetEkintza(ekintzakParseatu.getEkintzaInfo(indexPath.row))
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }
    
    // MARK: Functions
    func getData(){
        if Internet.isConnectedToNetwork() {
            println("Interneta badago!")
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
                println("gcd")
                self.ekintzakParseatu.getEkintzak()
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.hiddenEmptyCell()
                    self.tableView.hidden = false
                    self.activityIndicator.stopAnimating()
                })
            })
        } else {
            println("Ez dago internetik")
            self.activityIndicator.stopAnimating()
        }
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

