import Foundation
import UIKit

class AbisuakTableViewCell : UITableViewCell {
    
    // MARK: - Constants and Variables
    @IBOutlet var tituloa: UILabel!
    @IBOutlet var eguna: UILabel!
    @IBOutlet var deskribapena: UILabel!
    
    
    // MARK: - Setters
    func setTituloaCell(tituloa: String){
        self.tituloa.text = tituloa
    }
    
    func setEgunaCell(eguna: String){
        self.eguna.text = eguna
    }
    
    func setDeskribapenaCell(deskribapena: String){
        self.deskribapena.text = deskribapena
    }
    
}