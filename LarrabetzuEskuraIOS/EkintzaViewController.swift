//
//  EkintzaViewController.swift
//  LarrabetzuEskuraIOS
//
//  Created by Gorka Ercilla on 16/07/14.
//  Copyright (c) 2014 gorka. All rights reserved.
//

import UIKit

class EkintzaViewController: UIViewController {
    
    @IBOutlet var tituloaUI: UILabel
    @IBOutlet var hileaUI: UILabel
    @IBOutlet var eguneUI: UILabel
    @IBOutlet var orduaUI: UILabel
    @IBOutlet var lekuaUI: UILabel
    @IBOutlet var deskribapenaUI: UITextView
    @IBOutlet var kartelaUI: UIImageView
    @IBOutlet var linkUI: UILabel
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view!.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
}