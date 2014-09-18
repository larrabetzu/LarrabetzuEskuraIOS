//
//  NortzukViewController.swift
//  Larrabetzu
//
//  Created by Gorka Ercilla on 17/9/14.
//  Copyright (c) 2014 gorka. All rights reserved.
//

import UIKit

class NortzukViewController: UIViewController {

    @IBOutlet weak var nortzukText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.nortzukText.scrollRangeToVisible(NSRange(location: 0,length: 0))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
