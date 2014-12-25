import Foundation

class Berriak{
    var blogenTituloa: [String] = []
    var blogenLink: [String] = []
    var blogenPubDate: [String] = []
    
    
    let googleApi: String = "http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&q="
    
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
            var parsedJSON = parseJSON(getJSON(googleApi+urlBlog[idex]))
            if let dictionaryResponseData : AnyObject = parsedJSON["responseData"]{
                if let dictionaryFeed : AnyObject = dictionaryResponseData["feed"]{
                    if let dictionaryEntries : AnyObject = dictionaryFeed["entries"]{
                        var postNumeroa: Int = NSUserDefaults.standardUserDefaults().integerForKey("postNumeroa")
                        if(postNumeroa == 0){
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
