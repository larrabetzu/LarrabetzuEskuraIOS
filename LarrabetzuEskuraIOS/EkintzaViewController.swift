import UIKit
import Magic
import SafariServices

class EkintzaViewController: GAITrackedViewController, SFSafariViewControllerDelegate {
    
    // MARK: Constants and Variables
    
    var ekintzaObject: EkintzaObject?
    private let grisaColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    
    @IBOutlet var tituloaUI: UILabel!
    @IBOutlet var hileaUI: UILabel!
    @IBOutlet var egunaUI: UILabel!
    @IBOutlet var orduaUI: UILabel!
    @IBOutlet var lekuaUI: UILabel!
    @IBOutlet var deskribapenaUI: UITextView!
    @IBOutlet var kartelaUI: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var buttonLink: UIButton!
    
    @IBAction func tapLink() {
        if let link = self.ekintzaObject!.link {
            let svc = SFSafariViewController(URL: NSURL(string: link)!)
            svc.view.tintColor = UIColor.darkGrayColor()
            svc.delegate = self
            UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
            self.presentViewController(svc, animated: true, completion: nil)
        }
    }
    
    @IBAction func shareButton(sender: UIBarButtonItem) {
        let someText:String = self.ekintzaObject!.tituloa
        let url:NSURL = NSURL(string: self.ekintzaObject!.slug)!
        
        let activityViewController = UIActivityViewController(
            activityItems: [someText, url],
            applicationActivities: nil)
        self.presentViewController(activityViewController,
            animated: true,
            completion: nil)

    }
    
    // MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = grisaColor
        navigationItem.title = "Ekintza"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        tabBarController?.tabBar.tintColor = UIColor.blackColor()
        
        self.setView()
        
        if let rangeString = self.ekintzaObject?.link?.lowercaseString.rangeOfString("http://"){
            let subString = self.ekintzaObject?.link!.substringFromIndex(rangeString.endIndex)
            self.buttonLink.setTitle(subString, forState:UIControlState.Normal)
        }else{
            self.buttonLink.setTitle(self.ekintzaObject?.link, forState:UIControlState.Normal)
        }

        downloadImageBackground()
        
       
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "Ekintza"
    }

    // MARK: - Delegates
    func safariViewControllerDidFinish(controller: SFSafariViewController){
        controller.dismissViewControllerAnimated(true, completion: nil)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    
    // MARK: Functions
    func setView(){
        self.view.backgroundColor = UIColor(red: 232, green: 232, blue: 232, alpha: 1)
        self.tituloaUI.text = self.ekintzaObject?.tituloa
        self.hileaUI.text = self.ekintzaObject?.getHilea()
        self.egunaUI.text = self.ekintzaObject?.getEguna()
        self.orduaUI.text = self.ekintzaObject?.getOrdua()
        self.lekuaUI.text = self.ekintzaObject?.lekua
        self.deskribapenaUI.text = self.ekintzaObject?.deskribapena
    }
    
    
    private func downloadImageBackground(){
        self.activityIndicator.startAnimating()
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            magic("gcd")
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            if let urlString = self.ekintzaObject?.kartela{
                let imgURL: NSURL = NSURL(string: urlString)!
                let request: NSURLRequest = NSURLRequest(URL: imgURL)
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                    if !(error != nil) {
                        let image: UIImage? = UIImage(data: data!)
                        self.kartelaUI.image = image
                        
                    }else {
                        magic("Error: \(error!.localizedDescription)")
                    }
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                }
                task.resume()
            }else{
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.activityIndicator.stopAnimating()
            }
          })
    }
    
}