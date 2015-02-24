import UIKit

class PageItemController: UIViewController {
    
    // MARK: - Variables
    var itemIndex: Int = 0
    var argazkiaName: String = "" {
        didSet {
            if let argazkiaView = contentArgazkiaView {
                argazkiaView.image = UIImage(named: argazkiaName)
            }
        }
    }
    
    var tituloaName: String = "" {
        didSet {
            if let tituloaView = contentTituloaView {
                tituloaView.text = tituloaName
            }
        }
    }
    
    var deskribapenaName: String = "" {
        didSet {
            if let deskribapenaView = contentDeskribapenaView {
                deskribapenaView.text = deskribapenaName
            }
        }
    }
    
    @IBOutlet var contentArgazkiaView: UIImageView?
    @IBOutlet var contentTituloaView: UILabel?
    @IBOutlet var contentDeskribapenaView: UITextView?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentArgazkiaView!.image = UIImage(named: argazkiaName)
        contentTituloaView!.text = tituloaName
        contentDeskribapenaView!.text = deskribapenaName
    }
    
    
    
}