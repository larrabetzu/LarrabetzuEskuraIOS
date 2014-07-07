//
//  FirstViewController.swift
//  LarrabetzuEskuraIOS
//
//  Created by Gorka Ercilla on 25/06/14.
//  Copyright (c) 2014 gorka. All rights reserved.
//


import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var blogenTituloa: String[] = []
    var blogenLink: String[] = []
    var blogenPubDate: String[] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad")
        var berriakParseatu = Berriak()
        berriakParseatu.getLarrabetzutik()
        blogenTituloa = berriakParseatu.blogenTituloa
        blogenLink = berriakParseatu.blogenLink
        blogenPubDate = berriakParseatu.blogenPubDate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func tableView(tableView: UITableView!, numberOfRowsInSection section:Int) -> Int {
        return blogenTituloa.count
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        cell.text = "\(blogenTituloa[indexPath.row])"
        cell.detailTextLabel.text = "\(blogenPubDate[indexPath.row])"
        println("\(blogenLink[indexPath.row])")
        
        return cell
    }

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var webView = WebViewController()
        self.navigationController.pushViewController(webView, animated: true)
        webView.loadAddressURL(blogenLink[indexPath.row])
    }


}

