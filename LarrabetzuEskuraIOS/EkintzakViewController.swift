import UIKit

class EkintzakViewController : UIViewController, UITableViewDelegate , UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var ekintzanArray: [NSDictionary] = []
    
    let grisaColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad")
        
        //NabigationBar
        navigationController?.navigationBar.barTintColor = grisaColor
        navigationItem.title = "Agenda"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict

        activityIndicator.hidden = false
        tableView.hidden = true
        
        if Internet.isConnectedToNetwork() {
            println("Interneta badago!")
            let ekintzakParseatu = Ekintzak()
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
                println("gcd")
                ekintzakParseatu.getEkintzak()
                self.ekintzanArray = ekintzakParseatu.ekintzanArray
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                    self.hiddenEmptyCell()
                    self.tableView.hidden = false
                    self.activityIndicator.hidden = true
                })
            })
        } else {
            println("Ez dago internetik")
            self.activityIndicator.hidden = true
        }
        
    }

    override func viewDidAppear(animated: Bool) {
        if ekintzanArray.count == 0 {
            let alertEzdagoEkintzarik = UIAlertController(title: "Ez dago Ekintzarik", message: "Orain ez dago ekintzarik agendan. Nahi badozu joku batera eramango zaitut.", preferredStyle: UIAlertControllerStyle.Alert)
            alertEzdagoEkintzarik.addAction(UIAlertAction(title: "Jolastu", style: UIAlertActionStyle.Default, handler: nil))
            alertEzdagoEkintzarik.addAction(UIAlertAction(title: "Ez eskerrik asko!!!", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alertEzdagoEkintzarik, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return ekintzanArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:EkintzakTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("EkintzakCustomTableViewCell") as EkintzakTableViewCell
        
        let ekintza = ekintzanArray[indexPath.row]
        if let fields: AnyObject = ekintza["fields"]{
            let tituloa = fields["tituloa"] as String
            let data = fields["egune"] as String
            let lekua = fields["lekua"] as String
            let ordua = data.substringFromIndex(advance(data.startIndex, 11)).substringToIndex(advance(data.startIndex, 5)) as String
            let eguna = data.substringFromIndex(advance(data.startIndex, 8)).substringToIndex(advance(data.startIndex, 2)) as String
            cell.loadItem(tituloa: (tituloa), ordua: ordua, eguna: eguna,lekua: lekua)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let ekintza = ekintzanArray[indexPath.row]
        println(ekintza)
        let ekintzaView : EkintzaViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EkintzaViewController") as EkintzaViewController
        ekintzaView
        ekintzaView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ekintzaView, animated: true)
        if let fields: AnyObject = ekintza["fields"]{
            let tituloa = fields["tituloa"] as String
            let data = fields["egune"] as String
            let lekua = fields["lekua"] as String
            let link = fields["link"] as String
            let kartela = fields["kartela"] as String
            let deskribapena = fields["deskribapena"] as String
            let eguna:String = data.substringFromIndex(advance(data.startIndex, 8)).substringToIndex(advance(data.startIndex, 2))
            let ordua:String = data.substringFromIndex(advance(data.startIndex, 11)).substringToIndex(advance(data.startIndex, 5))
            let hilea:String = data.substringFromIndex(advance(data.startIndex, 5)).substringToIndex(advance(data.startIndex, 2))
            
            ekintzaView.SetEkintza(tituloa: tituloa, hilea: hilea, eguna: eguna, ordua: ordua, lekua: lekua, deskribapena: deskribapena, kartela: kartela, link: link)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }
    
    func hiddenEmptyCell(){
        var tblView =  UIView(frame: CGRectZero)
        self.tableView.tableFooterView = tblView
        self.tableView.tableFooterView?.hidden = true
        self.tableView.backgroundColor = UIColor.clearColor()
    }
    
}

