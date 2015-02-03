import UIKit

class BerriakViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var blogenTituloa: [String] = []
    var blogenLink: [String] = []
    var blogenPubDate: [String] = []
    
    let grisaColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NabigationBar
        navigationController?.navigationBar.barTintColor = grisaColor
        navigationItem.title = "Larrabetzu #eskura"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict
        
        println("viewDidLoad")
        
        if Internet.isConnectedToNetwork() {
            println("Interneta badago!")
            let berriakParseatu = Berriak()
            berriakParseatu.getLarrabetzutik()
            blogenTituloa = berriakParseatu.blogenTituloa
            blogenLink = berriakParseatu.blogenLink
            blogenPubDate = berriakParseatu.blogenPubDate

        } else {
            println("Ez dago internetik")
            var alertInterneta = UIAlertController(title: "Ez daukazu internet konexiorik", message: "Aplikaziok internet konexioa behar du. Begiratu ondo dagoela.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                UIAlertAction in
            }
            alertInterneta.addAction(okAction)
            self.presentViewController(alertInterneta, animated: true, completion: nil)
        }
        
        self.hiddenEmptyCell()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("viewWillAppear")
        navigationItem.title = "Larrabetzu #eskura"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section:Int) -> Int {
        return blogenTituloa.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cellBerria")
        cell.textLabel?.text = "\(blogenTituloa[indexPath.row])"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        var image = UIImage(named: "Berrriak.png")
        let bloganlinke : String = blogenLink[indexPath.row]
        
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

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let webView : WebViewController = self.storyboard?.instantiateViewControllerWithIdentifier("WebViewController") as WebViewController
        webView.hidesBottomBarWhenPushed = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Berriak", style:.Plain, target:nil, action:nil)
        self.navigationController?.pushViewController(webView, animated: true)
        webView.postLink = blogenLink[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func hiddenEmptyCell(){
        var tblView =  UIView(frame: CGRectZero)
        self.tableView.tableFooterView = tblView
        self.tableView.tableFooterView?.hidden = true
        self.tableView.backgroundColor = UIColor.clearColor()
    }
    
}

