import UIKit
import Parse
import Magic


class AbisuakViewController: GAITrackedViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Constants and Variables
    var abisuak: [PFObject] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getAbisuak()
        tableView.hidden = true
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "AbisuakView"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let currentInstallation = PFInstallation.currentInstallation()
        if(currentInstallation.badge != 0){
            currentInstallation.badge = 0
            (tabBarController!.tabBar.items![3]).badgeValue = nil
            currentInstallation.saveEventually()
        }
    }

    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.abisuak.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:AbisuakTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("AbisuakCustomTableViewCell") as! AbisuakTableViewCell
        if var tituloa = self.abisuak[indexPath.row].objectForKey("tituloa")as? String{
            if tituloa.hasPrefix("Ekitaldi Berria: "){
                tituloa.removeRange(Range<String.Index>(start: tituloa.startIndex, end:tituloa.startIndex.advancedBy(17)))
            }
            cell.setTituloaCell(tituloa)
        }
        if let data = self.abisuak[indexPath.row].createdAt{
            let dataFormatuan = NSDateFormatter.localizedStringFromDate(
                data,
                dateStyle: .ShortStyle,
                timeStyle: .ShortStyle)
            cell.setEgunaCell("\(dataFormatuan)")
        }
        if let deskribapena = self.abisuak[indexPath.row].objectForKey("deskribapena")as? String{
            cell.setDeskribapenaCell(deskribapena)
        }
        
        return cell
    }
    
    // MARK: - Functions
    private func getAbisuak(){
        let query = PFQuery(className:"Abisuak")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                magic("Successfully retrieved \(objects!.count) objects.")
                self.abisuak = objects!
                self.tableView.reloadData()
                self.tableView.hidden = false
                self.activityIndicator.removeFromSuperview()
                self.hiddenEmptyCell()
            } else {
                magic("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    private func hiddenEmptyCell(){
        let tblView =  UIView(frame: CGRectZero)
        self.tableView.tableFooterView = tblView
        self.tableView.tableFooterView?.hidden = true
        self.tableView.backgroundColor = UIColor.clearColor()
    }
}
