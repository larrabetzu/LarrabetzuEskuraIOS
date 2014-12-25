import UIKit

class EkintzaViewController: UIViewController {
    
    @IBOutlet var tituloaUI: UILabel!
    @IBOutlet var hileaUI: UILabel!
    @IBOutlet var egunaUI: UILabel!
    @IBOutlet var orduaUI: UILabel!
    @IBOutlet var lekuaUI: UILabel!
    @IBOutlet var deskribapenaUI: UITextView!
    @IBOutlet var kartelaUI: UIImageView!
    @IBOutlet var linkUI: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var tituloaString : String = ""
    var hileaString :String = ""
    var egunaString :String = ""
    var orduaString :String = ""
    var lekuaString :String = ""
    var deskribapena :String = ""
    var kartelaLink :String = ""
    var linkString :String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 232, green: 232, blue: 232, alpha: 1)
        self.tituloaUI.text = tituloaString
        self.hileaUI.text = hilea(hileaString)
        self.egunaUI.text = egunaString
        self.orduaUI.text = orduaString
        self.lekuaUI.text = lekuaString
        self.deskribapenaUI.text = deskribapena
        self.linkUI.text = linkString
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        downloadImageBackground()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }

    func SetEkintza(#tituloa:String, hilea:String, eguna:String, ordua:String, lekua:String, deskribapena:String, kartela:String, link:String ){
        self.tituloaString = tituloa
        self.hileaString = hilea
        self.egunaString = eguna
        self.orduaString = ordua
        self.lekuaString = lekua
        self.deskribapena = deskribapena
        self.kartelaLink = "http://larrabetzu.net/media/"+kartela
        self.linkString = link
    }
    
    func downloadImageBackground(){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            println("gcd")
            var urlString: NSString = self.kartelaLink
            var imgURL: NSURL = NSURL(string: urlString)!
            var request: NSURLRequest = NSURLRequest(URL: imgURL)
            var urlConnection: NSURLConnection = NSURLConnection(request: request, delegate: self)!
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if !(error != nil) {
                    var image: UIImage? = UIImage(data: data)
                    self.kartelaUI.image = image
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    
                }else {
                    println("Error: \(error.localizedDescription)")
                }
            })
       })
    }
    
    func hilea(numeroa:String)-> String{
        var hileanizena:String = "Urtarrilak";
        let hilea : Int = numeroa.toInt()!

        switch (hilea){
            case 1: hileanizena="Urtarrilak"; break;
            case 2: hileanizena="Otsailak"; break;
            case 3: hileanizena="Martxoak"; break;
            case 4: hileanizena="Apirilak"; break;
            case 5: hileanizena="Maiatzak"; break;
            case 6: hileanizena="Ekainak"; break;
            case 7: hileanizena="Uztailak"; break;
            case 8: hileanizena="Abuztuak"; break;
            case 9: hileanizena="Irailak"; break;
            case 10: hileanizena="Urriak"; break;
            case 11: hileanizena="Azaroak"; break;
            case 12: hileanizena="Abenduak"; break;
            default: hileanizena="Abenduak"
        }
        return hileanizena;
    }
   
}