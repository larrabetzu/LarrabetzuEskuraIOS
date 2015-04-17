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
    
    func getEkintzaInfo(position: Int)-> [String: String]{
        var ekintzaDic = [String: String] ()
        let ekintza = self.ekintzanArray[position]
        if let fields: NSDictionary = ekintza["fields"] as? NSDictionary{
            let data = fields["egune"] as! String
            ekintzaDic["tituloa"] = fields["tituloa"] as? String
            ekintzaDic["lekua"] = fields["lekua"] as? String
            ekintzaDic["link"] = fields["link"] as? String
            let kartela : String = fields["kartela"] as! String
            let urlKartela = "http://larrabetzu.net/media/"
            ekintzaDic["kartela"] = urlKartela + kartela
            ekintzaDic["deskribapena"] = fields["deskribapena"] as? String
            ekintzaDic["eguna"] = data.substringFromIndex(advance(data.startIndex, 8)).substringToIndex(advance(data.startIndex, 2))
            ekintzaDic["ordua"] = data.substringFromIndex(advance(data.startIndex, 11)).substringToIndex(advance(data.startIndex, 5))
            let hileaNumeroa = data.substringFromIndex(advance(data.startIndex, 5)).substringToIndex(advance(data.startIndex, 2))
            ekintzaDic["hilea"] = self.hilea(hileaNumeroa)
        }
        return ekintzaDic
    }
    
    func getEkintzaCell(position: Int)->(tituloa: String, lekua: String, eguna: String, ordua: String){
        let ekintza = self.ekintzanArray[position]
        if let fields: NSDictionary = ekintza["fields"] as? NSDictionary{
            let data: String = fields["egune"] as! String!
            let ordua = data.substringFromIndex(advance(data.startIndex, 11)).substringToIndex(advance(data.startIndex, 5)) as String
            let eguna = data.substringFromIndex(advance(data.startIndex, 8)).substringToIndex(advance(data.startIndex, 2)) as String
            return ((fields["tituloa"] as? String)!, (fields["lekua"] as? String)!, eguna, ordua)
        }
        return ("Ez dago informazioa", "", "", "")
    }
    
    // MARK: Functions
    private func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
    }
    
    private func parseJSON(inputData: NSData) -> Array<NSDictionary>{
        var error: NSError?
        var boardsDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as! Array<NSDictionary>
        return boardsDictionary
    }
    
    private func hilea(numeroa:String)-> String{
        var hileanizena:String = "Urtarrilak";
        let hilea : Int = numeroa.toInt()!
        
        switch (hilea){
            case 1: hileanizena="Urtarrilak"; break;
            case 2: hileanizena="Otsailak"; break;
            case 3: hileanizena="Martxoak"; break;
            case 4: hileanizena="Apirilak"; break;
            case 5: hileanizena="Maiatzak"; break;
            case 6: hileanizena="Ekainak"; break;
            case 7: hileanizena="Uztailak"; break;
            case 8: hileanizena="Abuztuak"; break;
            case 9: hileanizena="Irailak"; break;
            case 10: hileanizena="Urriak"; break;
            case 11: hileanizena="Azaroak"; break;
            case 12: hileanizena="Abenduak"; break;
            default: hileanizena="Urtarrilak"; break;
        }
        return hileanizena;
    }

    
    
}
