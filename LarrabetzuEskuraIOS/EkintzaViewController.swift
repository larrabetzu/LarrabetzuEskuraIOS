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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        self.view!.backgroundColor = UIColor(red: 232, green: 232, blue: 232, alpha: 1)
        self.tituloaUI.text = tituloaString
        self.hileaUI.text = hileaString
        self.egunaUI.text = egunaString
        self.orduaUI.text = orduaString
        self.lekuaUI.text = lekuaString
        self.deskribapenaUI.text = deskribapena
        self.linkUI.text = linkString
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        downloadImageBackground()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
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
        self.kartelaLink = "http://larrabetzu.net/media/"+kartela
        self.linkString = link
    }
    
    func downloadImageBackground(){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0), { ()->() in
            println("gcd")
            var urlString: NSString = self.kartelaLink
            var imgURL: NSURL = NSURL(string: urlString)
            var request: NSURLRequest = NSURLRequest(URL: imgURL)
            var urlConnection: NSURLConnection = NSURLConnection(request: request, delegate: self)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if !(error != nil) {
                    var image: UIImage? = UIImage(data: data)
                    self.kartelaUI.image = image
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    
                }else {
                    println("Error: \(error.localizedDescription)")
                }
            })
       })

    }
   
}