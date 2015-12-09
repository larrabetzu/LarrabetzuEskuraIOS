import UIKit
import Magic
import SafariServices

class EkintzaViewController: GAITrackedViewController, SFSafariViewControllerDelegate {
    
    // MARK: Constants and Variables
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
        if(!self.linkString.isEmpty){
            let svc = SFSafariViewController(URL: NSURL(string: self.linkString)!)
            svc.view.tintColor = UIColor.darkGrayColor()
            svc.delegate = self
            UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
            self.presentViewController(svc, animated: true, completion: nil)
        }
    }
    
    @IBAction func shareButton(sender: UIBarButtonItem) {
        let someText:String = self.tituloaString
        let url:NSURL = NSURL(string: self.slug)!
        
        let activityViewController = UIActivityViewController(
            activityItems: [someText, url],
            applicationActivities: nil)
        self.presentViewController(activityViewController,
            animated: true,
            completion: nil)

    }
    
    var tituloaString : String = ""
    var hileaString :String = ""
    var egunaString :String = ""
    var orduaString :String = ""
    var lekuaString :String = ""
    var deskribapena :String = ""
    var kartelaLink :String = ""
    var linkString :String = ""
    var slug :String = ""
    
    // MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 232, green: 232, blue: 232, alpha: 1)
        self.tituloaUI.text = tituloaString
        self.hileaUI.text = hileaString
        self.egunaUI.text = egunaString
        self.orduaUI.text = orduaString
        self.lekuaUI.text = lekuaString
        self.deskribapenaUI.text = deskribapena
        
        if let rangeString = linkString.lowercaseString.rangeOfString("http://"){
            let subString = linkString.substringFromIndex(rangeString.endIndex)
            self.buttonLink.setTitle(subString, forState:UIControlState.Normal)
        }else{
            self.buttonLink.setTitle(linkString, forState:UIControlState.Normal)
        }
        
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        downloadImageBackground()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
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
    func SetEkintza(ekintzaDic:[String : String]){
        self.tituloaString = ekintzaDic["tituloa"]!
        self.hileaString = ekintzaDic["hilea"]!
        self.egunaString = ekintzaDic["eguna"]!
        self.orduaString = ekintzaDic["ordua"]!
        self.lekuaString = ekintzaDic["lekua"]!
        self.deskribapena = ekintzaDic["deskribapena"]!
        self.kartelaLink = ekintzaDic["kartela"]!
        self.linkString = ekintzaDic["link"]!
        self.slug = ekintzaDic["slug"]!
    }
    
    private func downloadImageBackground(){
        self.activityIndicator.startAnimating()
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            magic("gcd")
            var urlString: NSString = self.kartelaLink
            
            if("peg" == urlString.substringFromIndex(urlString.length-3)){
                let urlStringPath = urlString.substringToIndex(urlString.length-5) //http://larrabetzu.net/media/kartelanIzena
                let urlStringFile = urlString.substringFromIndex(urlString.length-4) //jpeg
                urlString =  urlStringPath + ".medium." + urlStringFile
            }else{
                let urlStringPath = urlString.substringToIndex(urlString.length-4) //http://larrabetzu.net/media/kartelanIzena
                let urlStringFile = urlString.substringFromIndex(urlString.length-3) //jpg png
                urlString =  urlStringPath + ".medium." + urlStringFile
            }
            let imgURL: NSURL = NSURL(string: urlString as String)!
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                if !(error != nil) {
                    let image: UIImage? = UIImage(data: data!)
                    self.kartelaUI.image = image
                    self.activityIndicator.stopAnimating()
                    
                }else {
                    magic("Error: \(error!.localizedDescription)")
                }
            })
       })
    }
    
}