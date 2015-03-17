import UIKit

class ElkarteakViewController: GAITrackedViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let grisaColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    var elkarteakArray: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NabigationBar
        navigationController?.navigationBar.barTintColor = grisaColor
        navigationItem.title = "Elkarteak"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict as [NSObject : AnyObject]
        
        activityIndicator.startAnimating()
        tableView.hidden = true
        
        if Internet.isConnectedToNetwork() {
            println("Interneta badago!")
            let elkarteakParseatu = Elkarteak()
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
                elkarteakParseatu.getElkarteak()
                self.elkarteakArray = elkarteakParseatu.elkarteakArray
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("viewWillAppear")
        navigationItem.title = "Elkarteak"
        self.screenName = "Elkarteak"
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return elkarteakArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellElkarteak")
        cell.textLabel?.text = "Elkartea"
        cell.accessoryType = UITableViewCellAccessoryType.DetailButton
        
        let ekintza : NSDictionary = elkarteakArray[indexPath.row] as NSDictionary
        if let fields: NSDictionary = ekintza["fields"] as? NSDictionary{
            let nor = fields["nor"] as! String
            let email = fields["email"] as! String
            let webgunea = fields["webgunea"] as! String
            cell.textLabel?.text = "\(nor)"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let ekintza : NSDictionary = elkarteakArray[indexPath.row] as NSDictionary
        if let fields: NSDictionary = ekintza["fields"]as? NSDictionary{
            let nor = fields["nor"] as! String
            let email = fields["email"] as! String
            let webgunea = fields["webgunea"] as! String
            
            
            var alertController = UIAlertController(title: "Elkartean informazioa", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad){
                alertController = UIAlertController(title: "Elkartean informazioa", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            }
            let emailAction = UIAlertAction(title: "Email", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                let url = NSURL(string: "mailto:\(email)")
                UIApplication.sharedApplication().openURL(url!)
            }
            let webAction = UIAlertAction(title: "web", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                let webView : WebViewController = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as! WebViewController
                webView.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(webView, animated: true)
                webView.postLink = webgunea
            }
            let cancelAction = UIAlertAction(title: "Ezebez", style: .Cancel, handler: nil)

            alertController.addAction(emailAction)
            alertController.addAction(webAction)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
    }
    
    func hiddenEmptyCell(){
        var tblView =  UIView(frame: CGRectZero)
        self.tableView.tableFooterView = tblView
        self.tableView.tableFooterView?.hidden = true
        self.tableView.backgroundColor = UIColor.clearColor()
    }
    
}
