import Foundation
import Magic

class PushObject{
    
    var tituloa: String?{
        willSet (tituloBerria){
            if let tituloBerria = tituloBerria where !hutsikDago(tituloBerria){
                self.tituloa = tituloBerria
            }
        }
    }
    
    var deskribapena: String?{
        willSet (deskribapenBerria){
            if let deskribapenBerria = deskribapenBerria where !hutsikDago(deskribapenBerria){
                self.deskribapena = deskribapenBerria
            }
        }
    }
    var link: String?
    var orduLimitea: Int?
    var kanala: String?
    
    
    private func hutsikDago(text: String) -> Bool {
        let trimmed = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return trimmed.isEmpty
    }
}