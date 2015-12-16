import Foundation
import Parse
import Magic

class Berriak{
    // MARK: Constants and Variables
    private var posts :[Dictionary<String,String>] = []
    
    // MARK: Methods
    func getPostak(){
        var blogak: [String] = []

        let blogLarrabetzutik: Bool = NSUserDefaults.standardUserDefaults().boolForKey("blogLarrabetzutik")
        let blogUdala: Bool = NSUserDefaults.standardUserDefaults().boolForKey("blogUdala")
        let blogEskola: Bool = NSUserDefaults.standardUserDefaults().boolForKey("blogEskola")
        let blogHoriBai: Bool = NSUserDefaults.standardUserDefaults().boolForKey("blogHoriBai")
        let blogLarrabetzuZeroZabor: Bool = NSUserDefaults.standardUserDefaults().boolForKey("blogLarrabetzuZeroZabor")
        
        blogak.append("eskura")
        
        if(blogLarrabetzutik){
            blogak.append("larrabetzutik")
        }
        if(blogUdala){
            blogak.append("larrabetzukoUdala")
        }
        if(blogEskola){
            blogak.append("larrabetzukoEskola")
        }
        if(blogHoriBai){
            blogak.append("horiBai")
        }
        if(blogLarrabetzuZeroZabor){
            blogak.append("larrabetzuZeroZabor")
        }
        
        if blogak.count <= 1{
            blogak = ["eskura", "larrabetzutik", "larrabetzukoUdala", "larrabetzukoEskola", "horiBai", "larrabetzuZeroZabor"]
        }
        magic(blogak)
        
        let query = PFQuery(className:"Blogak")
        query.orderByAscending("pubDate")
        query.whereKey("bloga", containedIn: blogak)
        
        do {
            let objects:[PFObject]? = try query.findObjects()
            if let postak = objects{
                magic("Successfully retrieved \(postak.count) objects.")
                var postsBerriak :[Dictionary<String,String>] = []
                for objeto in postak{
                    let dic : [String: String] = ["title" : objeto.objectForKey("title") as! String,
                        "link" : objeto.objectForKey("link") as! String]
                    postsBerriak.insert(dic, atIndex: 0)
                }
                self.posts = postsBerriak
            }
        } catch {
            magic("Error")
        }

        
        
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
