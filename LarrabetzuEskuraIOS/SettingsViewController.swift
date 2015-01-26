import UIKit

class SettingsViewController: UIViewController {

    let grisaColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    var blogLarrabetzutik  = true
    var blogEskola  = true
    var blogHoribai  = true
    var blogLarrabetzuZeroZabor  = true
    
    @IBOutlet weak var labelNumeroPost: UILabel!
    
    @IBAction func nortzuk(sender: UIButton, forEvent event: UIEvent) {
        let nortzukView : NortzukViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NortzukViewController") as NortzukViewController
        nortzukView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nortzukView, animated: true)
    }
    
    /**Berriak */
    @IBAction func stepper(sender: UIStepper) {
        let postNumeroa: Int = Int(sender.value)
        self.labelNumeroPost.text = "\(postNumeroa)"
        var postNumeroaNS = NSUserDefaults.standardUserDefaults()
        postNumeroaNS.setObject(postNumeroa, forKey:"postNumeroa")
        postNumeroaNS.synchronize()
    }
    @IBOutlet weak var stepperUI: UIStepper!
    
    @IBOutlet weak var switchLarrabetzutik: UISwitch!
    @IBAction func switchLarrabetzutik(sender: UISwitch) {
        let position = sender.on
        self.blogLarrabetzutik = position
        var postNumeroaNS = NSUserDefaults.standardUserDefaults()
        postNumeroaNS.setBool(position, forKey:"blogLarrabetzutik")
        postNumeroaNS.synchronize()
        self.blogGuztiakKendutaDauz()
    }
    @IBOutlet weak var switchEskola: UISwitch!
    @IBAction func switchEskola(sender: UISwitch) {
        let position = sender.on
        self.blogEskola = position
        var postNumeroaNS = NSUserDefaults.standardUserDefaults()
        postNumeroaNS.setBool(position, forKey:"blogEskola")
        postNumeroaNS.synchronize()
        self.blogGuztiakKendutaDauz()
    }
    @IBOutlet weak var switchHoriBai: UISwitch!
    @IBAction func switchHoriBai(sender: UISwitch) {
        let position = sender.on
        self.blogHoribai = position
        var postNumeroaNS = NSUserDefaults.standardUserDefaults()
        postNumeroaNS.setBool(position, forKey:"blogHoriBai")
        postNumeroaNS.synchronize()
        self.blogGuztiakKendutaDauz()
    }
    @IBOutlet weak var switchLarrabetzuZeroZabor: UISwitch!
    @IBAction func switchLarrabetzuZeroZabor(sender: UISwitch) {
        let position = sender.on
        self.blogLarrabetzuZeroZabor = position
        var postNumeroaNS = NSUserDefaults.standardUserDefaults()
        postNumeroaNS.setBool(position, forKey:"blogLarrabetzuZeroZabor")
        postNumeroaNS.synchronize()
        self.blogGuztiakKendutaDauz()
    }
    
    /**Abisuak*/
    @IBOutlet weak var switchKultura: UISwitch!
    @IBAction func switchKultura(sender: UISwitch) {
        let position = sender.on
        if(position){
            PFPush.subscribeToChannelInBackground("kultura")
        }else{
            PFPush.unsubscribeFromChannelInBackground("kultura")
        }
    }
    @IBOutlet weak var switchKirola: UISwitch!
    @IBAction func switchKirola(sender: UISwitch) {
        let position = sender.on
        if(position){
            PFPush.subscribeToChannelInBackground("kirola")
        }else{
            PFPush.unsubscribeFromChannelInBackground("kirola")
        }
    }
    @IBOutlet weak var switchUdalgaiak: UISwitch!
    @IBAction func switchUdalGaiak(sender: UISwitch) {
        let position = sender.on
        if(position){
            PFPush.subscribeToChannelInBackground("udalgaiak")
        }else{
            PFPush.unsubscribeFromChannelInBackground("udalgaiak")
        }
    }
    @IBOutlet weak var switchAlbisteak: UISwitch!
    @IBAction func switchAlbisteak(sender: UISwitch) {
        let position = sender.on
        if(position){
            PFPush.subscribeToChannelInBackground("albisteak")
        }else{
            PFPush.unsubscribeFromChannelInBackground("albisteak")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NabigationBar
        navigationController?.navigationBar.barTintColor = grisaColor
        navigationItem.title = "Hobespenak"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict
        
        let postNumeroa: Int = NSUserDefaults.standardUserDefaults().integerForKey("postNumeroa")
        let blogLarrabetzutik: Bool = NSUserDefaults.standardUserDefaults().boolForKey("blogLarrabetzutik")
        let blogEskola: Bool = NSUserDefaults.standardUserDefaults().boolForKey("blogEskola")
        let blogHoriBai: Bool = NSUserDefaults.standardUserDefaults().boolForKey("blogHoriBai")
        let blogLarrabetzuZeroZabor: Bool = NSUserDefaults.standardUserDefaults().boolForKey("blogLarrabetzuZeroZabor")
        println("\(postNumeroa)")
        if(postNumeroa != 0){
            self.labelNumeroPost.text = "\(postNumeroa)"
            self.stepperUI?.value = Double (postNumeroa)
            self.switchLarrabetzutik.setOn(blogLarrabetzutik, animated: true)
            self.switchEskola.setOn(blogEskola, animated: true)
            self.switchHoriBai.setOn(blogHoriBai, animated: true)
            self.switchLarrabetzuZeroZabor.setOn(blogLarrabetzuZeroZabor, animated: true)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let channels = PFInstallation.currentInstallation().channels as? [String]{
            println("\(channels)")
            
            for item in channels{
                switch(item){
                case "kultura":     self.switchKultura.setOn(true, animated: true)
                case "kirola":      self.switchKirola.setOn(true, animated: true)
                case "udalgaiak":   self.switchUdalgaiak.setOn(true, animated: true)
                case "albisteak":   self.switchAlbisteak.setOn(true, animated: true)
                default:            abisuakOff()
                }
            }
        }
    }
    
    func abisuakOff(){
        self.switchKultura.setOn(false, animated: true)
        self.switchKirola.setOn(false, animated: true)
        self.switchUdalgaiak.setOn(false, animated: true)
        self.switchAlbisteak.setOn(false, animated: true)
    }
    
    func blogGuztiakKendutaDauz(){
        if(!self.blogLarrabetzutik & !self.blogEskola & !self.blogHoribai & !self.blogLarrabetzuZeroZabor){
            let alertBlogAukerak = UIAlertController(
                title: "Blog Aukerak",
                message: "Denak kentzen badozuz ez da blogarik agertuko.",
                preferredStyle: .Alert)
            alertBlogAukerak.addAction(UIAlertAction(title: "Bale", style: .Default, handler: nil))
            self.presentViewController(alertBlogAukerak, animated: true, completion: nil)
        }
        
        
    }

}
