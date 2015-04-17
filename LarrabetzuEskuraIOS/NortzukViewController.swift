import UIKit

class NortzukViewController: GAITrackedViewController {
    
    // MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "Nortzuk"
    }
}
