import UIKit
import Magic

class ElkarteakViewController: GAITrackedViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Constants and Variables
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private let grisaColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    private let ElkarteakParser : Elkarteak = Elkarteak()
    private var imageCache = [String:UIImage]()
    
    // MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NabigationBar
        navigationController?.navigationBar.barTintColor = grisaColor
        navigationItem.title = "Elkarteak"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        activityIndicator.startAnimating()
        tableView.hidden = true
        
        if Internet.isConnectedToNetwork() {
            magic("Interneta badago!")
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
                self.ElkarteakParser.getElkarteak()
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.hiddenEmptyCell()
                    self.tableView.hidden = false
                    self.activityIndicator.stopAnimating()
                })
            })
        } else {
            magic("Ez dago internetik")
            self.activityIndicator.stopAnimating()
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Elkarteak"
        self.screenName = "Elkarteak"
    }

    // MARK: Delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return ElkarteakParser.getElkarteNumeroa()
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cellElkarteak")
        cell.accessoryType = UITableViewCellAccessoryType.DetailButton
        let elkartea = ElkarteakParser.getElkarteaCell(indexPath.row)
        cell.textLabel?.text = "\(elkartea.nor)"
        var image = UIImage(named: "eskura.png")
        cell.imageView?.image = image
        let urlString = elkartea.ikonoa
        let imgUrl = NSURL(string: urlString)!
        
        if let img = imageCache[urlString] {
            cell.imageView?.image = img
        }else{
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
                let imageData = NSData(contentsOfURL: imgUrl)
                if imageData != nil{
                    image = self.reciseImage(UIImage(data: imageData!)!)
                    self.imageCache[urlString] = image
                }
                dispatch_async(dispatch_get_main_queue(), {
                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                        cellToUpdate.imageView?.image = image
                    }
                })
            })
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let ekintza  = ElkarteakParser.getElkarteaInfo(indexPath.row)
        
        let alertController = alertElkarteInfo(email: ekintza.email, webgunea: ekintza.webgunea)
        self.presentViewController(alertController, animated: true, completion: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: Functions
    private func hiddenEmptyCell(){
        let tblView =  UIView(frame: CGRectZero)
        self.tableView.tableFooterView = tblView
        self.tableView.tableFooterView?.hidden = true
        self.tableView.backgroundColor = UIColor.clearColor()
    }
    
    private func alertElkarteInfo(email email: String, webgunea: String)->UIAlertController{
        
        var alertController = UIAlertController(title: "Elkartean informazioa",
            message: "",
            preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad){
            alertController = UIAlertController(title: "Elkartean informazioa",
                message: "",
                preferredStyle: UIAlertControllerStyle.Alert)
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
        
        return alertController
    }
    
    private func reciseImage(image: UIImage)->UIImage{
        let newSize:CGSize = CGSize(width: 30, height: 30)
        let rect = CGRectMake(0,0, newSize.width, newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
