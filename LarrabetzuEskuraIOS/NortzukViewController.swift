import UIKit

class NortzukViewController: UIViewController {

    @IBOutlet weak var nortzukText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.nortzukText.scrollRangeToVisible(NSRange(location: 0,length: 0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
