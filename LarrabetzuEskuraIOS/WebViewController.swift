//
//  WebViewController.swift
//  LarrabetzuEskuraIOS
//
//  Created by Gorka Ercilla on 07/07/14.
//  Copyright (c) 2014 gorka. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate{
    
    
    @IBOutlet var webView: UIWebView!
    var postLink: String = String()
    
    @IBAction func backButton(sender: UIBarButtonItem) {
        self.navigationController.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        let requestURL: NSURL = NSURL(string: postLink)
        let request :NSURLRequest = NSURLRequest(URL: requestURL)
        self.webView.loadRequest(request)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if UIApplication.sharedApplication().networkActivityIndicatorVisible {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    
    func webViewDidStartLoad(_: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        
        let localizedErrorMessage = NSLocalizedString("An error occured:", comment: "")
        let errorHTML = "<!doctype html><html><body><div style=\"width: 100%%; text-align: center; font-size: 36pt;\">\(localizedErrorMessage) \(error.localizedDescription)</div></body></html>"
        webView.loadHTMLString(errorHTML, baseURL: nil)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
}

