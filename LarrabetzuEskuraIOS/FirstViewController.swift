//
//  FirstViewController.swift
//  LarrabetzuEskuraIOS
//
//  Created by Gorka Ercilla on 25/06/14.
//  Copyright (c) 2014 gorka. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(tableView: UITableView!, numberOfRowsInSection section:    Int) -> Int {
        return 10
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
        cell.text = "Row #\(indexPath.row)"
        cell.detailTextLabel.text = "Subtitle #\(indexPath.row)"
        
        return cell
    }
  

}

