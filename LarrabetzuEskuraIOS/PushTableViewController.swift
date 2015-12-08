import UIKit
import Parse

class PushTableViewController: UITableViewController, UITextFieldDelegate {

    private let grisaColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    let pushObject = PushObject()
    
    @IBOutlet weak var tituloaTextField: UITextField!
    @IBOutlet weak var deskribapenaTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var orduLimiteaLabel: UILabel!
    @IBOutlet weak var kanalaLabel: UILabel!

    @IBAction func irtenButton(sender: UIBarButtonItem) {
        self.dismissModalViewController()
    }
    
    @IBAction func abisuaBidali(sender: UIBarButtonItem) {
        if self.pushAbisuaBidali(){
            self.dismissModalViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //NabigationBar
        navigationController?.navigationBar.barTintColor = grisaColor
        navigationItem.title = "Abisuen Panela"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        tabBarController?.tabBar.tintColor = UIColor.blackColor()
        
        self.tituloaTextField.delegate = self
        self.tituloaTextField.tag = 1
        self.deskribapenaTextField.delegate = self
        self.deskribapenaTextField.tag = 2
        self.linkTextField.delegate = self
        self.linkTextField.tag = 3
        
        
        
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 3 && indexPath.row == 0 {
            self.orduLimitea()
        }else if indexPath.section == 4 && indexPath.row == 0 {
            self.kanala()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(textField: UITextField) {
        let testua = textField.text
        switch (textField.tag){
            case 1: self.pushObject.tituloa = testua
            case 2: self.pushObject.deskribapena = testua
            case 3:
                if self.urlBerifikatu(testua){
                    print("\(self.urlBerifikatu(testua))")
                    self.pushObject.link = testua
                }
            default: ()
        }
    }
    
    func dismissModalViewController(){
        let presentingViewController = self.presentingViewController
        self.dismissViewControllerAnimated(true, completion: {
            presentingViewController!.dismissViewControllerAnimated(true, completion: {})
        })
    }

    func orduLimitea(){
        let alert = UIAlertController(title: "Ordu Limitea", message: "Zenbat ordu jarri nahi dozuz limite moduan", preferredStyle: .ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Ordu 1", style: .Default, handler: { Void in
            self.orduLimiteaLabel.text = "Ordu 1"
            self.pushObject.orduLimitea = 1
        }))
        alert.addAction(UIAlertAction(title: "2 Ordu", style: .Default, handler: { Void in
            self.orduLimiteaLabel.text = "2 Ordu"
            self.pushObject.orduLimitea = 2
        }))
        alert.addAction(UIAlertAction(title: "4 Ordu", style: .Default, handler: { Void in
            self.orduLimiteaLabel.text = "4 Ordu"
            self.pushObject.orduLimitea = 4
        }))
        alert.addAction(UIAlertAction(title: "12 Ordu", style: .Default, handler: { Void in
            self.orduLimiteaLabel.text = "12 Ordu"
            self.pushObject.orduLimitea = 12
        }))
        alert.addAction(UIAlertAction(title: "24 Ordu", style: .Default, handler: { Void in
            self.orduLimiteaLabel.text = "24 Ordu"
            self.pushObject.orduLimitea = 24
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func kanala(){
        
        let user = PFUser.currentUser()
        let kanalak = user?.objectForKey("kanalak") as! [String]
        
        let alert = UIAlertController(title: "Abisu kanala", message: "Aukeratu kanala abisua bidaltzeko", preferredStyle: .ActionSheet)
        for kanala in kanalak{
            alert.addAction(UIAlertAction(title: kanala, style: .Default, handler: { Void in
                self.kanalaLabel.text = kanala
                self.pushObject.kanala = kanala
            }))
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func pushAbisuaBidali() -> Bool{
        if let tituloa = self.pushObject.tituloa, let deskribapena = self.pushObject.deskribapena, let kanala = self.pushObject.kanala{
            var data = [
                "alert" : "",
                "badge" : "Increment",
                "sound": "default",
                "url": ""
            ]
            var timeInterval:Double = 60*60*1;
            if let orduak = self.pushObject.orduLimitea{
                timeInterval = Double(60*60*orduak)
            }
            let push = PFPush()
            push.setChannel(kanala)
            data.updateValue("", forKey: "url")
            data.updateValue(tituloa, forKey: "alert")
            push.expireAfterTimeInterval(timeInterval)
            push.setData(data)
            push.sendPushInBackgroundWithBlock{
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    let abisuak = PFObject(className:"Abisuak")
                    abisuak["kanala"] = kanala
                    abisuak["tituloa"] = tituloa
                    abisuak["deskribapena"] = deskribapena
                    if let link = self.pushObject.link{
                        abisuak["link"] = link
                    }else{
                        abisuak["link"] = ""
                    }
                    abisuak.saveInBackground()
                } else {
                    let alert = UIAlertController(title: "", message: "Ezin izen da abisurik bidali", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            return true
        }else{
            let alert = UIAlertController(title: "", message: "Ez dago informazio guztia jarrita", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        return false
    }
    
    
    func urlBerifikatu (urlString: String?) -> Bool {
        if let urlString = urlString{
            if let url = NSURL(string: urlString) {
                return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
        return false
    }
}
