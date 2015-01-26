import Foundation

class Berriak{
    var blogenTituloa: [String] = []
    var blogenLink: [String] = []
    var blogenPubDate: [String] = []
    
    
    func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
    }
    
    func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        return boardsDictionary
    }
    
    func getLarrabetzutik(){
        var urlBlog: [String] = []
        let googleApi: String = "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0"
        
        var postNumeroa: Int = NSUserDefaults.standardUserDefaults().integerForKey("postNumeroa")
        if(postNumeroa == 0){
            postNumeroa = 4
        }
        let call = googleApi + "&num=\(postNumeroa)&q="
        
        var blogLarrabetzutik: Bool = NSUserDefaults.standardUserDefaults().boolForKey("blogLarrabetzutik")
        var blogEskola: Bool = NSUserDefaults.standardUserDefaults().boolForKey("blogEskola")
        var blogHoriBai: Bool = NSUserDefaults.standardUserDefaults().boolForKey("blogHoriBai")
        var blogLarrabetzuZeroZabor: Bool = NSUserDefaults.standardUserDefaults().boolForKey("blogLarrabetzuZeroZabor")
        
        if(!blogLarrabetzutik & !blogEskola & !blogHoriBai & !blogLarrabetzuZeroZabor){
            blogLarrabetzutik = true
            blogEskola = true
            blogHoriBai = true
            blogLarrabetzuZeroZabor = true
        }
        
        if(blogLarrabetzutik){
            urlBlog.append("http://www.larrabetzutik.org/feed/")
        }
        if(blogEskola){
            urlBlog.append("http://www.horibai.org/feed/")
        }
        if(blogHoriBai){
            urlBlog.append("http://www.larrabetzukoeskola.org/feed/")
        }
        if(blogLarrabetzuZeroZabor){
            urlBlog.append("http://larrabetzuzerozabor.org/index.php/eu/bloga?format=feed&type=rss")
        }
        
        let countUrleBlog = urlBlog.count
        for var idex = 0; idex < countUrleBlog; ++idex{
            var parsedJSON = parseJSON(getJSON(call+urlBlog[idex]))
            if let dictionaryResponseData : AnyObject = parsedJSON["responseData"]{
                if let dictionaryFeed : AnyObject = dictionaryResponseData["feed"]{
                    if let dictionaryEntries : AnyObject = dictionaryFeed["entries"]{
                        for var idex = 0; idex < dictionaryEntries.count; ++idex{
                            if let una : AnyObject = dictionaryEntries[idex]{
                                let title : String = una["title"] as String
                                let link : String = una["link"] as String
                                let publishedDateString : String = una["publishedDate"] as String
                                
                                let arrayNumeroa = self.blogenPubDate.count
                                
                                if(arrayNumeroa != 0){
                                    for var x = 0; x <= arrayNumeroa; ++x{
                                        if(lehenengoDataHandiagoaDa(publishedDateString, bigarrenData: self.blogenPubDate[x])){
                                            self.blogenTituloa.insert(title, atIndex: x)
                                            self.blogenLink.insert(link, atIndex: x)
                                            self.blogenPubDate.insert(publishedDateString, atIndex: x)
                                            x = arrayNumeroa
                                        }else if(x+1 == arrayNumeroa){
                                            self.blogenTituloa.insert(title, atIndex: arrayNumeroa)
                                            self.blogenLink.insert(link, atIndex: arrayNumeroa)
                                            self.blogenPubDate.insert(publishedDateString, atIndex: arrayNumeroa)
                                            x = arrayNumeroa
                                        }
                                    }
                                }else{
                                    self.blogenTituloa.insert(title, atIndex: arrayNumeroa)
                                    self.blogenLink.insert(link, atIndex: arrayNumeroa)
                                    self.blogenPubDate.insert(publishedDateString, atIndex: arrayNumeroa)
                                }
                                
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
    
    func lehenengoDataHandiagoaDa(lehenengoData : String, bigarrenData : String)->Bool{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss xx" //Thu, 22 May 2014 11:36:45 -0700
        let data1 = dateFormatter.dateFromString(lehenengoData)
        let data2 = dateFormatter.dateFromString(bigarrenData)
        if data1?.compare(data2!) == NSComparisonResult.OrderedDescending{
            return true
        }
        return false
    }
}
