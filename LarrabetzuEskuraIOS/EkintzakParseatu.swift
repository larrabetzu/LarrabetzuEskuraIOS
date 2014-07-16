//
//  EkintzakParseatu.swift
//  LarrabetzuEskuraIOS
//
//  Created by Gorka Ercilla on 15/07/14.
//  Copyright (c) 2014 gorka. All rights reserved.
//

import Foundation

class Ekintzak{
    var ekintzanArray: [NSDictionary] = []
    let ekintzakAPI: String = "http://larrabetzu.net/wsEkintza/"
    
    func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest))
    }
    
    func parseJSON(inputData: NSData) -> Array<NSDictionary>{
        var error: NSError?
        var boardsDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as Array<NSDictionary>
        return boardsDictionary
    }
    
    func getEkintzak(){
        var parsedJSON = parseJSON(getJSON(ekintzakAPI))
        ekintzanArray = parsedJSON
        
    }
    
}
