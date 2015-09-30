import UIKit

class EkintzakViewController : GAITrackedViewController, UITableViewDelegate , UITableViewDataSource {
    
    // MARK: Constants and Variables
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    private var refreshControl:UIRefreshControl!
    private let grisaColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    private let ekintzakParseatu : Ekintzak = Ekintzak()
    
    // MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
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
        
        let cell:EkintzakTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("EkintzakCustomTableViewCell") as! EkintzakTableViewCell
        let ekintza = ekintzakParseatu.getEkintzaCell(indexPath.row)
        cell.loadItem(tituloa: ekintza.tituloa, ordua: ekintza.ordua, eguna: ekintza.eguna, lekua: ekintza.lekua)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let ekintzaView : EkintzaViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EkintzaViewController") as! EkintzaViewController
        ekintzaView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ekintzaView, animated: true)
        ekintzaView.SetEkintza(ekintzakParseatu.getEkintzaInfo(indexPath.row))
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }
    
    // MARK: - Functions
    func getData(){
        if Internet.isConnectedToNetwork() {
            print("Interneta badago!")
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
                self.ekintzakParseatu.getEkintzak()
                for view in self.tableView.subviews{
                    if view.tag == 99{
                        view.removeFromSuperview()
                    }
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.hiddenEmptyCell()
                    self.tableView.hidden = false
                    self.activityIndicator.stopAnimating()
                    let rows = self.tableView.numberOfRowsInSection(0)
                    if(rows == 0){
                        self.addEmptyView()
                    }
                })
            })
        } else {
            print("Ez dago internetik")
            self.activityIndicator.stopAnimating()
        }
    }
    
    func hiddenEmptyCell(){
        let tblView =  UIView(frame: CGRectZero)
        self.tableView.tableFooterView = tblView
        self.tableView.tableFooterView?.hidden = true
        self.tableView.backgroundColor = UIColor.clearColor()
    }
    
    func refresh(sender:AnyObject){
        getData()
        self.refreshControl.endRefreshing()
    }
    
    
    private func addEmptyView(){
        
        let emptyView = UIView()
        emptyView.frame = view.bounds
        emptyView.tag = 99
        self.tableView.addSubview(emptyView)
        
        let image = UIImage(named: "Agenda")
        let agendaImageView = UIImageView(image: image)
        agendaImageView.frame = CGRectMake(
            (view.frame.size.width/2) - (image!.size.width),
            (view.frame.size.height / 3) - (image!.size.height),
            image!.size.width * 2,
            image!.size.height * 2)
        emptyView.addSubview(agendaImageView)
        
        let agendaLabel = UILabel(frame: CGRectMake(0, 0, view.frame.width-20, view.frame.height-20))
        agendaLabel.text = "Ez dago ezer agendan"
        agendaLabel.numberOfLines = 2
        agendaLabel.textAlignment = NSTextAlignment.Center
        agendaLabel.sizeToFit()
        agendaLabel.center = view.center
        
        emptyView.addSubview(agendaLabel)
        
    }
    
}

