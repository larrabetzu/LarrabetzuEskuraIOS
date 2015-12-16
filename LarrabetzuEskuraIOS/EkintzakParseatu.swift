import Foundation

class Ekintzak{
    
    // MARK: Constants and Variables
    private let ekintzakAPI: String = "http://larrabetzu.net/wsEkintza/"
    var ekintzanArray: [NSDictionary] = []
    
    // MARK: Methods
    func getEkintzak(){
        ekintzanArray = parseJSON(getJSON(ekintzakAPI))
    }
    
    func getEkintzaNumeroa()-> Int {
        return ekintzanArray.count
    }
    
    func getEkintzaInfo(position: Int)-> EkintzaObject?{

        let ekintza = self.ekintzanArray[position]
        guard let fields: NSDictionary = ekintza["fields"] as? NSDictionary else{
            return nil
        }
        
        let tituloa = fields["tituloa"] as! String
        let deskribapena = fields["deskribapena"] as! String
        let dataFormateatuGabe = fields["egune"] as! String
        let lekua = fields["lekua"] as! String
        let slug = fields["slug"] as! String
        
        let link = fields["link"] as? String
        let kartela = fields["kartela"] as? String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let data = dateFormatter.dateFromString(dataFormateatuGabe)
        
        let ekintzaObject = EkintzaObject(tituloa: tituloa, deskribapena: deskribapena, data: data!, lekua: lekua, slug: slug, link: link, kartela: kartela)

        return ekintzaObject
    }
    
    func getEkintzaCell(position: Int)->(tituloa: String, lekua: String, eguna: String, ordua: String){
        let ekintza = self.ekintzanArray[position]
        if let fields: NSDictionary = ekintza["fields"] as? NSDictionary{
            let data: String = fields["egune"] as! String!
            let ordua = data.substringFromIndex(data.startIndex.advancedBy(11)).substringToIndex(data.startIndex.advancedBy(5)) as String
            let eguna = data.substringFromIndex(data.startIndex.advancedBy(8)).substringToIndex(data.startIndex.advancedBy(2)) as String
            return ((fields["tituloa"] as? String)!, (fields["lekua"] as? String)!, eguna, ordua)
        }
        return ("Ez dago informazioa", "", "", "")
    }
    
    // MARK: Functions
    private func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
    }
    
    private func parseJSON(inputData: NSData) -> Array<NSDictionary>{
        let boardsDictionary = (try! NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers)) as! Array<NSDictionary>
        return boardsDictionary
    }
    
}
