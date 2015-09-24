import UIKit

class NortzukViewController: GAITrackedViewController {
    
    // MARK: - Constants and Variables
    @IBOutlet weak var nortzukTextView: UITextView!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "Nortzuk"
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        nortzukTextView.scrollRangeToVisible(NSRange(location:0, length:0))
    }
}
