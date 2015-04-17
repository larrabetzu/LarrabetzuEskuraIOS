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
    
    func getElkarteaNor(position: Int)-> String{
        var elkarteaNor = "Ez dago informaziorik"
        let ekintza = self.elkarteakArray[position]
        if let fields: NSDictionary = ekintza["fields"] as? NSDictionary{
            elkarteaNor = fields["nor"] as! String
        }
        return elkarteaNor
    }
    
    func getEkintzaCell(position: Int)->(nor: String, email: String, webgunea: String){
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