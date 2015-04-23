import Foundation

class Elkarteak{
    
    // MARK: Constants and Variables
    private var elkarteakArray: [NSDictionary] = []
    private let elkarteakAPI: String = "http://larrabetzu.net/wsElkarteak/"

    // MARK: Methods
    func getElkarteak(){
        elkarteakArray = parseJSON(getJSON(elkarteakAPI))
    }
    
    func getElkarteNumeroa()-> Int {
        return elkarteakArray.count
    }
    
    func getElkarteaCell(position: Int)->(nor: String, ikonoa : String){
        let ekintza = self.elkarteakArray[position]
        if let fields: NSDictionary = ekintza["fields"] as? NSDictionary{
            let elkarteaNor = fields["nor"] as! String
            let larrabetzuMedia = "http://larrabetzu.net/media/"
            var ikonoa : String = fields["ikonoa"] as! String
            ikonoa = ikonoa.substringToIndex(advance(ikonoa.endIndex, -3))
            ikonoa = larrabetzuMedia + ikonoa + "thumbnail.jpg"
            return (elkarteaNor, ikonoa)
        }
        return ("Ez dago informaziorik", "")
    }
    
    func getElkarteaInfo(position: Int)->(nor: String, email: String, webgunea: String){
        let ekintza = self.elkarteakArray[position]
        if let fields: NSDictionary = ekintza["fields"] as? NSDictionary{
            let nor = fields["nor"] as! String
            let email = fields["email"] as! String
            let webgunea = fields["webgunea"] as! String
            return (nor, email, webgunea)
        }
        return ("Ez dago informaziorik", "", "")
    }
    
    // MARK: Functions
    private func parseJSON(inputData: NSData) -> Array<NSDictionary>{
        var error: NSError?
        var boardsDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as! Array<NSDictionary>
        return boardsDictionary
    }
    
    private func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
    }
    
    
}