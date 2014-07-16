//
//  SecondViewController.swift
//  LarrabetzuEskuraIOS
//
//  Created by Gorka Ercilla on 25/06/14.
//  Copyright (c) 2014 gorka. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView
    @IBOutlet var activityIndicator: UIActivityIndicatorView
    
    var ekintzanArray: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad")
        activityIndicator.hidden = false
        tableView.hidden = true
        let ekintzakParseatu = Ekintzak()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            println("gcd")
            ekintzakParseatu.getEkintzak()
            self.ekintzanArray = ekintzakParseatu.ekintzanArray
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.hiddenEmptyCell()
                self.tableView.hidden = false
                self.activityIndicator.hidden = true
                })
            })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(tableView: UITableView!, numberOfRowsInSection section:Int) -> Int {
        return ekintzanArray.count
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell:EkintzakTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("EkintzakCustomTableViewCell") as EkintzakTableViewCell
        
        let ekintza = ekintzanArray[indexPath.row]
        if let fields: AnyObject = ekintza["fields"]{
            let tituloa = fields["tituloa"] as String
            let ordua = fields["egune"] as String
            let egune = fields["egune"] as String
            cell.loadItem(tituloa: "\(tituloa)", ordua: "\(ordua.substringFromIndex(11))", eguna: "\(egune.substringFromIndex(8).substringToIndex(2))")
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
    }
    
    func hiddenEmptyCell(){
        var tblView =  UIView(frame: CGRectZero)
        self.tableView.tableFooterView = tblView
        self.tableView.tableFooterView.hidden = true
        self.tableView.backgroundColor = UIColor.clearColor()
    }
    
}

