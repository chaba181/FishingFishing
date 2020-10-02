
import UIKit
import Alamofire
import FSCalendar

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    fileprivate weak var calendar: FSCalendar!
    
    @IBOutlet weak var tbldViewData: UITableView!
    
    var info = [FishingInfo]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tbldViewData.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tbldViewData.delegate = self
        //  tblView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        //     let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
        //        calendar.dataSource = self
        //        calendar.delegate = self
        //        calendar.translatesAutoresizingMaskIntoConstraints = false
        //        view.addSubview(calendar)
        //        calendar.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150).isActive = true
        //        calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //        calendar.heightAnchor.constraint(equalToConstant: 275).isActive = true
        //        calendar.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        //        self.calendar = calendar
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if editingStyle == .delete {
                self.tbldViewData.setEditing(true, animated: true)
                context.delete(info [indexPath.row])
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                do {
                    try context.fetch(FishingInfo.fetchRequest())
                } catch let error as NSError {
                    print("Could not save \(error) , \(error.userInfo)")
                }
                tbldViewData.reloadData()
                
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbldViewData.dequeueReusableCell(withIdentifier: "Cell")
        let fishingInfo = info [indexPath.row]
        cell?.textLabel?.text = [fishingInfo.title, fishingInfo.timeData].compactMap({$0}).joined(separator: " ")
        return cell!
    }
    
    // MARK: ПЕРЕХОД
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fishingInfo = info [indexPath.row]
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FishingDetailViewController") as! FishingDetailViewController
        controller.fish = fishingInfo
        controller.onDataAdded = { [weak self] fishingInfo in
            self?.tbldViewData.reloadData()
        }
        //tableView.cellForRow(at: indexPath)?.textLabel?.text
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //       let selected = info [indexPath.row]
    //       let newView: FishingDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! FishingDetailViewController
    //       newView.infoName = [ selected.title].compactMap({$0}).joined(separator: " ")
    //       self.present(newView, animated: true, completion: nil)
    //
    //       }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        tbldViewData.reloadData()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let result  = try context.fetch(FishingInfo.fetchRequest())
            info = result as! [FishingInfo]
        } catch let error as NSError {
            print("Could not save \(error) , \(error.userInfo)")
        }
        tbldViewData.reloadData()
    }
    
}
extension ViewController: FSCalendarDataSource, FSCalendarDelegate {
}
