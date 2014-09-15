//
//  SettingsViewController.swift
//  Larrabetzu
//
//  Created by Gorka Ercilla on 15/9/14.
//  Copyright (c) 2014 gorka. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    let grisaColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    
    @IBOutlet weak var labelNumeroPost: UILabel!
    @IBAction func stepper(sender: UIStepper) {
        let post: Int = Int(sender.value)
        self.labelNumeroPost.text = "\(post)"
    }
    @IBAction func switchKultura(sender: UISwitch) {
        let position = sender.on
        if(position){
            println("\(position) switchKultura")
        }else{
            println("\(position) switchKultura")
        }
    }
    @IBAction func switchKirola(sender: UISwitch) {
        let position = sender.on
        if(position){
            println("\(position) switchKirola")
        }else{
            println("\(position) switchKirola")
        }
    }
    @IBAction func switchUdalGaiak(sender: UISwitch) {
        let position = sender.on
        if(position){
            println("\(position) switchUdalGaiak")
        }else{
            println("\(position) switchUdalGaiak")
        }
    }
    @IBAction func switchAlbisteak(sender: UISwitch) {
        let position = sender.on
        if(position){
            println("\(position) switchAlbisteak")
        }else{
            println("\(position) switchAlbisteak")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = grisaColor
        navigationItem.title = "Hobespenak"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
