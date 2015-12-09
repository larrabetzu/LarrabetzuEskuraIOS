import UIKit
import Parse

class LoginViewController: UIViewController {
    
    // MARK: - Constants and Variables
    @IBOutlet weak var erabiltzaileIzenaTextField: UITextField!
    @IBOutlet weak var pasahitzaTextField: UITextField!
    
    @IBAction func irtenButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func logeatuButton(sender: UIButton) {
        if let izena = self.erabiltzaileIzenaTextField.text, let pasahitza = self.pasahitzaTextField.text{
            if izena.isEmpty || pasahitza.isEmpty{
                self.showAlert("Erabiltzailean izena eta pasahitza jarrita egon behar dira")
            }else{
                self.loginParsen(izena, pasahitza: pasahitza)
            }
        }
    }
    @IBAction func pasahitzaReseatuButton(sender: UIButton) {
        self.pasahitzaReseatu()
    }
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    // MARK: - Functions
    func showAlert(testua: String){
        let alert = UIAlertController(
            title: "",
            message: testua,
            preferredStyle: .Alert)
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .Default,
            handler: nil))
        self.presentViewController(
            alert,
            animated: true,
            completion: nil)
    }
    
    func loginParsen(izena: String, pasahitza: String){
        PFUser.logInWithUsernameInBackground(izena, password:pasahitza) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.performSegueWithIdentifier("ShowPushSegue", sender: self)
            } else {
                self.showAlert("Erabiltzailea edo pasahitza ez da zuzena")
                self.erabiltzaileIzenaTextField.text = ""
                self.pasahitzaTextField.text = ""
            }
        }
    }
    
    func pasahitzaReseatu(){
        let alert = UIAlertController(title: "Pasahitza Reseteatzeko", message: "Email bat bidaliko dizugu pasahitz berria jartzeko", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = "Jarri emaila"
        })
        alert.addAction(UIAlertAction(title: "Bidali", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            if let emaila = textField.text{
                if !emaila.isEmpty && self.emailaBerifikatu(emaila){
                    PFUser.requestPasswordResetForEmailInBackground(emaila)
                }else{
                    self.showAlert("Emaila bidaltzeko email zuzena izan behar da")
                }
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func emailaBerifikatu(emaila:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(emaila)
    }
    
}
