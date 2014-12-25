import Foundation
import UIKit

class EkintzakTableViewCell : UITableViewCell {
  
    @IBOutlet var tituloa: UILabel!
    @IBOutlet var ordua: UILabel!
    @IBOutlet var eguna: UILabel!
    @IBOutlet var lekua: UILabel!
    
    func loadItem(#tituloa: String, ordua: String, eguna: String, lekua: String) {
        self.tituloa.text = tituloa
        self.ordua.text = ordua
        self.eguna.text = eguna
        self.lekua.text = lekua
    }
}