import UIKit
import Alamofire
import FSCalendar

class ViewController: UIViewController {
    
    private weak var calendar: FSCalendar!
    
    @IBOutlet private var tbldViewData: UITableView!
    
    private var info = [FishingInfo]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        #warning("вместо Cell - String(describing: UITableViewCell.self) - ячейки так регаются")
        tbldViewData.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tbldViewData.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        tbldViewData.reloadData()
        
        #warning("Неправильный код, подумай пчему почитай что такое raceConditions")
        guard   let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext,
                let result = try? context.fetch(FishingInfo.fetchRequest()) as? [FishingInfo] else { return }
            
        info = result
        tbldViewData.reloadData()
    }
    
}

#warning("Разнеси разные делегаты(для календаря и таблицы по разным екстеншенам, сделай им прагма марки")
extension ViewController: FSCalendarDataSource, FSCalendarDelegate, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if editingStyle == .delete {
                self.tbldViewData.setEditing(true, animated: true)
                context.delete(info [indexPath.row])
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                #warning("избався от do catch, вынеси удаление в отедльный метод, который в себя просто идекс принимает")
                do {
                    try context.fetch(FishingInfo.fetchRequest())
                } catch _ as NSError { }
                tbldViewData.reloadData()
                
            }
        }
        if editingStyle == .delete {
            info.remove(at: indexPath.row)
            tbldViewData.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fishingInfo = info [indexPath.row]
        #warning("Здесь аналогично тому что я писал выше")
        if let cell = tbldViewData.dequeueReusableCell(withIdentifier: "Cell") {
            cell.textLabel?.text = [fishingInfo.title, fishingInfo.timeData].compactMap({$0}).joined(separator: " ")
        return cell
        }
        return UITableViewCell()
    }

    // MARK: - transition to another class by cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fishingInfo = info [indexPath.row]
        
        #warning("Сделай доступ к сторибордам и контролерам через R.string, удали закоменченый код")
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FishingDetailViewController") as? FishingDetailViewController else {return}
        controller.fish = fishingInfo
        controller.onDataAdded = { [weak self] fishingInfo in
            self?.tbldViewData.reloadData()
        }
        //tableView.cellForRow(at: indexPath)?.textLabel?.text
        navigationController?.pushViewController(controller, animated: true)
    }
   
}
