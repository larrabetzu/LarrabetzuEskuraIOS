import UIKit

class ElkarteakViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
        navigationController?.navigationBar.titleTextAttributes = titleDict
        
        activityIndicator.hidden = false
        tableView.hidden = true
        let elkarteakParseatu = Elkarteak()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            elkarteakParseatu.getElkarteak()
            self.elkarteakArray = elkarteakParseatu.elkarteakArray
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.hiddenEmptyCell()
                self.tableView.hidden = false
                self.activityIndicator.hidden = true
            })
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return elkarteakArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cellElkarteak")
        cell.textLabel?.text = "Elkartea"
        cell.accessoryType = UITableViewCellAccessoryType.DetailButton
        
        let ekintza = elkarteakArray[indexPath.row]
        if let fields: AnyObject = ekintza["fields"]{
            let nor = fields["nor"] as String
            let email = fields["email"] as String
            let webgunea = fields["webgunea"] as String
            cell.textLabel?.text = "\(nor)"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
        let ekintza = elkarteakArray[indexPath.row]
        if let fields: AnyObject = ekintza["fields"]{
            let nor = fields["nor"] as String
            let email = fields["email"] as String
            let webgunea = fields["webgunea"] as String
            
            var alertController = UIAlertController(title: "Elkartean informazioa", message: "", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Email", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                let url = NSURL(string: "mailto:\(email)")
                UIApplication.sharedApplication().openURL(url!)
            }
            let cancelAction = UIAlertAction(title: "web", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                let webView : WebViewController = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as WebViewController
                webView.hidesBottomBarWhenPushed = true
                
                self.navigationController?.pushViewController(webView, animated: true)
                webView.postLink = webgunea
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    func hiddenEmptyCell(){
        var tblView =  UIView(frame: CGRectZero)
        self.tableView.tableFooterView = tblView
        self.tableView.tableFooterView?.hidden = true
        self.tableView.backgroundColor = UIColor.clearColor()
    }
    
}
