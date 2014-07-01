//
//  Berriak.swift
//  LarrabetzuEskuraIOS
//
//  Created by Gorka Ercilla on 01/07/14.
//  Copyright (c) 2014 gorka. All rights reserved.
//

import Foundation

class Berriak{
    
    let urlPath: String = "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q=http://larrabetzutik.org/feed/"
    
    func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest))
    }
    
    func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        return boardsDictionary
    }
    
    func getLarrabetzutik(){
        var parsedJSON = parseJSON(getJSON(urlPath))
        if let dictionaryResponseData : AnyObject = parsedJSON["responseData"]{
            if let dictionaryFeed : AnyObject = dictionaryResponseData["feed"]{
                if let dictionaryEntries : AnyObject = dictionaryFeed["entries"]{
                    for var idex = 0; idex<dictionaryEntries.count; ++idex{
                        if let una : AnyObject = dictionaryEntries[idex]{
                            var title = una["title"]
                            var link = una["link"]
                            var Date = una["publishedDate"]
                            println("index is ->\(idex) title ->\(title)  link->\(link)  Date->\(Date)")
                        }else{
                            println("Ez deu 'dictionaryEntries' idex betegaz topetan")
                        }
                    }
                } else {
                    println("Ez deu 'entries' topatu")
                }
                
            } else {
                println("Ez deu 'feed' topatu")
            }
        } else {
            println("Ez deu 'responseData' topatu")
        }
        
        
    }
    
}
