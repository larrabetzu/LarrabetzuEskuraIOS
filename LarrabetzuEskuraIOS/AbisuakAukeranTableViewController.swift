import UIKit
import Parse

class AbisuakAukeranTableViewController: UITableViewController {

    // MARK: - Constants and Variables
    let abisuKanalakIzenak = ["Agendan Eguneraketak", "Kultura", "Kirola", "Udalgaiak", "Albisteak"]
    let abisuKanalak = ["agendaAbisuak", "kultura", "kirola", "udalgaiak", "albisteak"]
    var checked:[Bool] = [false, false, false, false, false]
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let channels = PFInstallation.currentInstallation().channels as? [String]{
            print("\(channels)")
            
            for item in channels{
                switch(item){
                    case "agendaAbisuak":   self.checked[0] = true
                    case "kultura":         self.checked[1] = true
                    case "kirola":          self.checked[2] = true
                    case "udalgaiak":       self.checked[3] = true
                    case "albisteak":       self.checked[4] = true
                    default: break
                }
            }
        }
    }


    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abisuKanalakIzenak.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("AbisuakAukeranCell")!

        cell.textLabel?.text = abisuKanalakIzenak[indexPath.row]
        if checked[indexPath.row] == false {
            cell.accessoryType = .None
        }
        else if checked[indexPath.row] == true {
            cell.accessoryType = .Checkmark
        }
        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark{
                cell.accessoryType = .None
                checked[indexPath.row] = false
            }else{
                cell.accessoryType = .Checkmark
                checked[indexPath.row] = true
            }
        }
        setKanalak()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


    // MARK: - Functions
    func setKanalak(){
        for var index = 0; index < self.checked.count; ++index{
            if(self.checked[index] == true){
                PFPush.subscribeToChannelInBackground(abisuKanalak[index])
            }else{
                PFPush.unsubscribeFromChannelInBackground(abisuKanalak[index])
            }
        }
    }
}
