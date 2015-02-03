import Foundation

class Elkarteak{
    var elkarteakArray: [NSDictionary] = []
    let elkarteakAPI: String = "http://larrabetzu.net/wsElkarteak/"
    
    func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
    }
    
    func parseJSON(inputData: NSData) -> Array<NSDictionary>{
        var error: NSError?
        var boardsDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as Array<NSDictionary>
        return boardsDictionary
    }
    
    func getElkarteak(){
        var parsedJSON = parseJSON(getJSON(elkarteakAPI))
        elkarteakArray = parsedJSON
    }
    
}