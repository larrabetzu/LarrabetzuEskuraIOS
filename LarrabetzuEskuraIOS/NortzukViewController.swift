import UIKit

class NortzukViewController: GAITrackedViewController,UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Constants and Variables
    @IBOutlet weak var tableView: UITableView!
    
    let galderak:[String] = ["Zer da:","Zertarako:", "Zelan erabiltzen da:", "Zelan parte hartu:", "Hurrengo geltokia:", "Garapena:"]
    let erantzunak: [String] = ["Larrabetzu eskura, telefono mugikorretarako aplikazio bat da. Herriko informazioa eta ekitaldien agenda modu automatikoan eskaintzen ditu eskura larrabetzu.net gunean.",
        "Aplikazio honek eskura jartzen du gure herrian sortzen den informazio guztia. Informazio dinamikoa. Parte hartzera gonbidatzen zaitu, modu aktiboan.",
        "Erraza da. Deskargatu ostean, zure mugikorreko pantailan Larrabetzu aplikazioaren irudia izango duzu, ostean klik egiten duzun bakoitzean herriko informazioa edo kultur ekitaldi guztien berri izango duzu.",
         "Garrantzitsua da elkarteetako lagunek ere informazioa gehitzea aplikazioan, antolatzen den guztiaren berri emanez. Irudiak, deialdiak, orduak, lekua adieraziz",
        "Aplikazioa garatzen eta hobetzen jarraitu nahi dugu. Horretarako app hau zenbat eta gehiago erabili, zenbat eta parte hartze handiagoa izan... hobeto jakingo dugu gure beharrizanen gainean, eta horren arabera berritu eta hobetu ahal izango dugu. Guztion eskura dago",
        "2013ko urrian aurkeztu genuen sarean Eskura aplikazioa. Gorka Ercilla eta Patxi Gaztelumendiren artean sortu genuen lehen bertsioa. Aurrerantzean bertsio hobetuak eta irekiak egiten jarraitzea da gure asmoa; gehiago ikusi, ikasi eta berrituz. 2014ko ekainean Sergio Peñak webApp bat garatu du eta sarean eskaini dugu plataforma guztietarako prestatuta: larrabetzu.net/app . 2014ko irailean Gorka Ercillak ios App-a garatu du eta App Storean eskaini dugu."]
    

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.screenName = "Nortzuk"
        
    }
    
    // MARK: - Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return galderak.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "NortzukTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NortzukTableViewCell
        
        cell.galdera.text = self.galderak[indexPath.row]
        cell.erantzuna.text = self.erantzunak[indexPath.row]
        
        return cell
    }
    
    
    
}
