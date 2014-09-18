//
//  Berriak.swift
//  LarrabetzuEskuraIOS
//
//  Created by Gorka Ercilla on 01/07/14.
//  Copyright (c) 2014 gorka. All rights reserved.
//

import Foundation

class Berriak{
    var blogenTituloa: [String] = []
    var blogenLink: [String] = []
    var blogenPubDate: [String] = []
    let urlBlog: [String] = ["http://www.larrabetzutik.org/feed/","http://www.horibai.org/feed/", "http://www.larrabetzukoeskola.org/feed/"]
    
    let googleApi: String = "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q="
    
    func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest))
    }
    
    func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        return boardsDictionary
    }
    
    func getLarrabetzutik(){
        let countUrleBlog = urlBlog.count
        for var idex = 0; idex < countUrleBlog; ++idex{
            var parsedJSON = parseJSON(getJSON(googleApi+urlBlog[idex]))
            if let dictionaryResponseData : AnyObject = parsedJSON["responseData"]{
                if let dictionaryFeed : AnyObject = dictionaryResponseData["feed"]{
                    if let dictionaryEntries : AnyObject = dictionaryFeed["entries"]{
                        var postNumeroa: Int = NSUserDefaults.standardUserDefaults().integerForKey("postNumeroa")
                        if(postNumeroa != 0){
                            postNumeroa = dictionaryEntries.count
                        }
                        for var idex = 0; idex<postNumeroa; ++idex{
                            if let una : AnyObject = dictionaryEntries[idex]{
                                let title : String = una["title"] as String
                                let link : String = una["link"] as String
                                let publishedDate : String = una["publishedDate"] as String
                                
                                self.blogenTituloa.append(title)
                                self.blogenLink.append(link)
                                self.blogenPubDate.append(publishedDate)
                                
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
}
