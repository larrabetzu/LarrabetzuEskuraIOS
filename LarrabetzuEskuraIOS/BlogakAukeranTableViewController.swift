import UIKit

class BlogakAukeranTableViewController: UITableViewController {

    // MARK: - Constants and Variables
    let blogakIzena = ["Larrabetzutik", "Larrabetzuko Udala", "Larrabetzuko Eskola", "Hori bai", "Larrabetzu Zer Zabor"]
    let blogak = ["blogLarrabetzutik", "blogUdala", "blogEskola", "blogHoriBai", "blogLarrabetzuZeroZabor"]
    var checked:[Bool] = [false, false, false ,false, false]
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false
        setChecked()

    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogakIzena.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("BlogakAukeranCell")!
        
        cell.textLabel?.text = blogakIzena[indexPath.row]
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
        setBlogak()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Functions
    func setChecked(){
        let blogLarrabetzutik: Bool = NSUserDefaults.standardUserDefaults().boolForKey("blogLarrabetzutik")
        let blogUdala: Bool = NSUserDefaults.standardUserDefaults().boolForKey("blogUdala")
        let blogEskola: Bool = NSUserDefaults.standardUserDefaults().boolForKey("blogEskola")
        let blogHoriBai: Bool = NSUserDefaults.standardUserDefaults().boolForKey("blogHoriBai")
        let blogLarrabetzuZeroZabor: Bool = NSUserDefaults.standardUserDefaults().boolForKey("blogLarrabetzuZeroZabor")
        
        self.checked = [blogLarrabetzutik, blogUdala, blogEskola, blogHoriBai, blogLarrabetzuZeroZabor]
    }
    
    func setBlogak(){
        for var index = 0; index < self.checked.count; ++index{
            let key = blogak[index]
            let postNumeroaNS = NSUserDefaults.standardUserDefaults()
            postNumeroaNS.setBool(self.checked[index], forKey: key)
            postNumeroaNS.synchronize()
        }
        
    }

}
