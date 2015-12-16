import Foundation


class EkintzaObject {
    
    // MARK: - Variables
    var tituloa: String
    var deskribapena: String
    var data: NSDate
    var lekua: String
    var slug: String{
        willSet{
            let slugUrl = "http://larrabetzu.net/ekintza/"
            self.slug = slugUrl + newValue
        }
    }
    var link: String?
    var kartela: String?

    // MARK: - Init()
    init(tituloa: String, deskribapena: String, data: NSDate, lekua:String, slug: String, link:String?, kartela: String?){
        
        self.tituloa = tituloa
        self.deskribapena = deskribapena
        self.data = data
        self.lekua = lekua
        self.slug = "http://larrabetzu.net/ekintza/" + slug
        
        if let link = link where !link.isEmpty{
            self.link = link
        }
        
        if let kartelanIzena = kartela where !kartelanIzena.isEmpty{
            self.kartela = self.kartelaFormateatu(kartelanIzena)
        }
        
    }
    
    // MARK: Meto
    func getOrdua()-> String{
        let formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        formatter.locale = NSLocale(localeIdentifier: "eu")
        let ordua = formatter.stringFromDate(self.data)
        return ordua
    }
    
    func getEguna()-> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd"
        formatter.locale = NSLocale(localeIdentifier: "eu")
        let eguna = formatter.stringFromDate(self.data)
        return eguna
    }
    
    func getHilea()-> String{
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMMM"
        formatter.locale = NSLocale(localeIdentifier: "eu")
        let hilea = formatter.stringFromDate(self.data).capitalizedString
        return hilea
    }
    
    // MARK: Fuctions
    func kartelaFormateatu(kartelanIzena: String)-> String{

        let urlKartela = "http://larrabetzu.net/media/kartelak/"
        
        if kartelanIzena.hasSuffix("peg"){//jpeg
            let argazkiarenIzena = kartelanIzena.substringWithRange(Range(start: kartelanIzena.startIndex.advancedBy(9), end: kartelanIzena.endIndex.advancedBy(-5)))
            let argazkiarenFormatua = kartelanIzena.substringFromIndex(kartelanIzena.endIndex.advancedBy(-4))
            return urlKartela + argazkiarenIzena + ".medium." + argazkiarenFormatua
        }else{//jpg png
            let argazkiarenIzena = kartelanIzena.substringWithRange(Range(start: kartelanIzena.startIndex.advancedBy(9), end: kartelanIzena.endIndex.advancedBy(-4)))
            let argazkiarenFormatua = kartelanIzena.substringFromIndex(kartelanIzena.endIndex.advancedBy(-3))
            return urlKartela + argazkiarenIzena + ".medium." + argazkiarenFormatua
        }
    }
}