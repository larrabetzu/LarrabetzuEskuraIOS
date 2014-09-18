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
    
    @IBAction func nortzuk(sender: UIButton, forEvent event: UIEvent) {
        let nortzukView : NortzukViewController = self.storyboard?.instantiateViewControllerWithIdentifier("NortzukViewController") as NortzukViewController
        nortzukView.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nortzukView, animated: true)
    }
    @IBAction func stepper(sender: UIStepper) {
        let postNumeroa: Int = Int(sender.value)
        self.labelNumeroPost.text = "\(postNumeroa)"
        var postNumeroaNS = NSUserDefaults.standardUserDefaults()
        postNumeroaNS.setObject(postNumeroa, forKey:"postNumeroa")
        postNumeroaNS.synchronize()
    }
    @IBOutlet weak var stepperUI: UIStepper!
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
        
        //NabigationBar
        navigationController?.navigationBar.barTintColor = grisaColor
        navigationItem.title = "Hobespenak"
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict
        
        let postNumeroa: Int = NSUserDefaults.standardUserDefaults().integerForKey("postNumeroa")
        println("\(postNumeroa)")
        if(postNumeroa != 0){
            self.labelNumeroPost.text = "\(postNumeroa)"
            self.stepperUI?.value = Double (postNumeroa)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
