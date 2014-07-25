//
//  EkintzakTableViewCell.swift
//  LarrabetzuEskuraIOS
//
//  Created by Gorka Ercilla on 14/07/14.
//  Copyright (c) 2014 gorka. All rights reserved.
//

import Foundation
import UIKit

class EkintzakTableViewCell : UITableViewCell {
  
    @IBOutlet var tituloa: UILabel!
    @IBOutlet var ordua: UILabel!
    @IBOutlet var eguna: UILabel!
    
    func loadItem(#tituloa: String, ordua: String, eguna: String) {
        self.tituloa.text = tituloa
        self.ordua.text = ordua
        self.eguna.text = eguna
        
    }
}