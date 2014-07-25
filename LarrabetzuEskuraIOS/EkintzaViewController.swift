//
//  EkintzaViewController.swift
//  LarrabetzuEskuraIOS
//
//  Created by Gorka Ercilla on 16/07/14.
//  Copyright (c) 2014 gorka. All rights reserved.
//

import UIKit

class EkintzaViewController: UIViewController {
    
    @IBOutlet var tituloaUI: UILabel!
    @IBOutlet var hileaUI: UILabel!
    @IBOutlet var egunaUI: UILabel!
    @IBOutlet var orduaUI: UILabel!
    @IBOutlet var lekuaUI: UILabel!
    @IBOutlet var deskribapenaUI: UITextView!
    @IBOutlet var kartelaUI: UIImageView!
    @IBOutlet var linkUI: UILabel!
    
    var tituloaString : String = ""
    var hileaString :String = ""
    var egunaString :String = ""
    var orduaString :String = ""
    var lekuaString :String = ""
    var deskribapena :String = ""
    var kartelaLink :String = ""
    var linkString :String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view!.backgroundColor = UIColor.whiteColor()
        self.tituloaUI.text = tituloaString
        self.hileaUI.text = hileaString
        self.egunaUI.text = egunaString
        self.orduaUI.text = orduaString
        self.lekuaUI.text = lekuaString
        self.deskribapenaUI.text = deskribapena
        self.linkUI.text = linkString
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }

    func SetEkintza(#tituloa:String, hilea:String, eguna:String, ordua:String, lekua:String, deskribapena:String, kartela:String, link:String ){
        self.tituloaString = tituloa
        self.hileaString = hilea
        self.egunaString = eguna
        self.orduaString = ordua
        self.lekuaString = lekua
        self.deskribapena = deskribapena
        self.kartelaLink = kartela
        self.linkString = link
    }
   
}