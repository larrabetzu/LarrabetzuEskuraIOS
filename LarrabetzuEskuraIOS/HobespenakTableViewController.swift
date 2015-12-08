import UIKit
import Parse
import MessageUI

class HobespenakTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    // MARK: - Constants and Variables
    let grisaColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    
    @IBOutlet weak var bertsioaLabel: UILabel!
    @IBOutlet weak var abisuakIrakurriBarik: UILabel!
    @IBOutlet weak var bertsioaCell: UITableViewCell!
  
    
    // MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NabigationBar
        navigationController?.navigationBar.barTintColor = grisaColor
        navigationItem.title = "Hobespenak"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        if let appVersion = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            bertsioaLabel.text = appVersion
        }
        
        let gesture = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        gesture.minimumPressDuration = 2
        self.bertsioaCell.addGestureRecognizer(gesture)
        self.bertsioaCell.userInteractionEnabled = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentInstallation = PFInstallation.currentInstallation()
        self.abisuakIrakurriBarik.text = "\(currentInstallation.badge)"
        if(currentInstallation.badge != 0){
            self.abisuakIrakurriBarik.textColor = UIColor.redColor()
        }else{
            self.abisuakIrakurriBarik.textColor = UIColor.lightGrayColor()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.hidesBottomBarWhenPushed = false
    }
    
    // MARK: - Delegates
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(indexPath.section == 2 && indexPath.row == 1){
            emailaBidali()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Functions
    private func emailaBidali(){
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    private func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.navigationBar.tintColor = UIColor.whiteColor()
        mailComposerVC.navigationBar.barTintColor = grisaColor
        mailComposerVC.navigationItem.title = "Iritzi emaila"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        mailComposerVC.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        mailComposerVC.setToRecipients(["ercillagorka@gmail.com"])
        mailComposerVC.setSubject("Larrabetzu #eskura")
        
        return mailComposerVC
    }
    
    private func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(
            title: "Ezin da emailik bidali" ,
            message: "Mesedez egiaztatu email konfigurazio ondo dagoela eta saiatu berriro.",
            preferredStyle: UIAlertControllerStyle.Alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func longPressed(longPress: UIGestureRecognizer) {
         if (longPress.state == UIGestureRecognizerState.Began) {
            self.pushLogin()
        }
    }
    
    func pushLogin(){
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            self.performSegueWithIdentifier("ShowPushSegue", sender: self)
        } else {
            self.performSegueWithIdentifier("ShowLoginSegue", sender: self)
        }
        
    }
    
}
