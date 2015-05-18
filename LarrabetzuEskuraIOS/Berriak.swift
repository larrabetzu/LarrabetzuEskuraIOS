import Foundation

class Berriak{
    // MARK: Constants and Variables
    private var posts :[Dictionary<String,String>] = []
    
    // MARK: Functions
    private func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
    }
    
    private func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
        return boardsDictionary
    }
    
    private func lehenengoDataHandiagoaDa(lehenengoData : String, bigarrenData : String)->Bool{
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss xx" //Thu, 22 May 2014 11:36:45 -0700
        var data1 = dateFormatter.dateFromString(lehenengoData)
        var data2 = dateFormatter.dateFromString(bigarrenData)
        if data1?.compare(data2!) == NSComparisonResult.OrderedDescending{
            return true
        }
        return false
    }
    
    // MARK: Methods
    func getPostak(){
        var postsBerriak :[Dictionary<String,String>] = []
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
        
        urlBlog.append("http://medium.com/feed/@larrabetzu")
        
        if(blogLarrabetzutik){
            urlBlog.append("http://larrabetzutik.org/feed/")
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
            if let dictionaryResponseData = parsedJSON["responseData"] as? NSDictionary, dictionaryFeed = dictionaryResponseData["feed"] as? NSDictionary , dictionaryEntries = dictionaryFeed["entries"] as? NSArray{
                for var idex = 0; idex < dictionaryEntries.count; ++idex{
                    if let una = dictionaryEntries[idex] as? NSDictionary{
                        let title : String = una["title"] as! String
                        let link : String = una["link"] as! String
                        let publishedDateString : String = una["publishedDate"] as! String
                        
                        let arrayNumeroa = postsBerriak.count
                        
                        if(arrayNumeroa != 0){
                            for var x = 0; x <= arrayNumeroa; ++x{
                                
                                let postArray = postsBerriak[x]
                                let publishedDateStringArray : String = postArray["publishedDate"] as String!
                                if(lehenengoDataHandiagoaDa(publishedDateString, bigarrenData: publishedDateStringArray)){
                                    let dic : [String: String] = ["title" : title , "link" : link, "publishedDate" : publishedDateString]
                                    postsBerriak.insert(dic, atIndex: x)
                                    x = arrayNumeroa
                                }else if(x+1 == arrayNumeroa){
                                    let dic : [String: String] = ["title" : title , "link" : link, "publishedDate" : publishedDateString]
                                    postsBerriak.insert(dic, atIndex: arrayNumeroa)
                                    
                                    x = arrayNumeroa
                                }
                                
                            }
                        }else{
                            let dic : [String: String] = ["title" : title , "link" : link, "publishedDate" : publishedDateString]
                            postsBerriak.insert(dic, atIndex: arrayNumeroa)
                        }
                    }
                }
            }
        }
        self.posts = postsBerriak
    }
    
    func getPostNumeroa()->Int{
        return self.posts.count
    }
    
    func getPostBat(position: Int)->(title: String, image: UIImage){

        let dicPost = self.posts[position]
        var image = UIImage(named: "eskura.png")
        let bloganlinke : String = dicPost["link"] as String!
        let title : String = dicPost["title"] as String!
        
        if(bloganlinke.hasPrefix("http://larrabetzutik.org/")){
            image = UIImage(named: "larrabetzutik")!
            
        }else if(bloganlinke.hasPrefix("http://horibai.org/")){
            image = UIImage(named: "horibai")!
            
        }else if(bloganlinke.hasPrefix("http://www.larrabetzukoeskola.org/")){
            image = UIImage(named: "eskola")!
            
        }else if(bloganlinke.hasPrefix("http://gaztelumendi.tumblr.com/")){
            image = UIImage(named: "iptx")!
            
        }else if(bloganlinke.hasPrefix("http://www.larrabetzuko-udala.com/")){
            image = UIImage(named: "udala")!
            
        }else if(bloganlinke.hasPrefix("http://www.literaturaeskola.org/")){
            image = UIImage(named: "literatura")!
            
        }else if(bloganlinke.hasPrefix("http://larrabetzuzerozabor.org/")){
            image = UIImage(named: "larrabetzuzerozabor")!
        }
        
        return (title, image!)
    }
    
    func getLink(position: Int)->String{
        
        let dicPost = self.posts[position]
        let bloganlinke : String = dicPost["link"] as String!

        return bloganlinke
    }
    
}
