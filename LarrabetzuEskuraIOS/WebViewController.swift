import UIKit

class WebViewController: GAITrackedViewController, UIWebViewDelegate{
    
    
    @IBOutlet var webView: UIWebView!
    var postLink: String = String()
    
    @IBAction func share(sender: UIBarButtonItem) {
        let someText:String = "#eskura"
        let url:NSURL = NSURL(string: postLink)!
        
        let activityViewController = UIActivityViewController(
            activityItems: [someText, url],
            applicationActivities: nil)
        self.navigationController?.presentViewController(activityViewController,
            animated: true, 
            completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        let requestURL: NSURL = NSURL(string: postLink)!
        let request :NSURLRequest = NSURLRequest(URL: requestURL)
        self.webView.loadRequest(request)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "WebView"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if UIApplication.sharedApplication().networkActivityIndicatorVisible {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    
    func webViewDidStartLoad(_: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}

