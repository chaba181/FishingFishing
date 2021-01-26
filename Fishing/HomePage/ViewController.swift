import UIKit
import Alamofire
import FSCalendar

class ViewController: UIViewController {
    
    var presenter: Presenter?
    
    @IBOutlet private var tbldViewData: UITableView!
    private weak var calendar: FSCalendar!
    
    var fish: [FishingInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = Presenter()
        presenter?.controller = self
        
        tbldViewData.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tbldViewData.delegate = self
        tbldViewData.estimatedRowHeight = 38
        tbldViewData.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        presenter?.loadData()
    }
    
    func onDataLoaded() {
        tbldViewData.reloadData()
    }
    
}

    // MARK: - UITableViewDataSource, UITableViewDelegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.info.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let fishingInfo = presenter?.info[indexPath.row] else { return UITableViewCell() }
        #warning("Здесь аналогично тому что я писал выше")
//        let celIdentifire = "Cell"
//        if let cell = tableView.dequeueReusableCell(withIdentifier: celIdentifire) as? FishingTableViewCell {
//        cell.fishingName.text = fishingInfo.title
        if let cell = tbldViewData.dequeueReusableCell(withIdentifier: "Cell") as? FishingTableViewCell {
          //  cell.textLabel?.text = [fishingInfo.title, fishingInfo.timeData].compactMap({$0}).joined(separator: " ")
            cell.fishingName.text = fishingInfo.title
            cell.fishingLocation.text = fishingInfo.address
            cell.fishingDate.text = fishingInfo.timeData
            if let data = fishingInfo.photo,
               let loadedImage = try?  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Data] {
                let images = loadedImage.compactMap({ UIImage(data: $0) })
                cell.fishingImage.image = images.first
            }
           
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - transition to another class by cell
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fishingInfo = presenter?.info[indexPath.row]

        #warning("Сделай доступ к сторибордам и контролерам через R.string, удали закоменченый код")
        guard let controller =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FishingDetailViewController") as? FishingDetailViewController else {return}
        controller.fish = fishingInfo
        controller.onDataAdded = { [weak self] fishingInfo in
            self?.tbldViewData.reloadData()
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
//        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//                if editingStyle == .delete {
//                    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
//                        self.tbldViewData.setEditing(true, animated: true)
//                        context.delete(((presenter?.info [indexPath.row]))!)
//                    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
//                        deleteData(indexPath: indexPath)
//                }
//                }
//        }
//
    func deleteData(indexPath:IndexPath) {
        self.presenter?.info.remove(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let fishingInfo = presenter?.info[indexPath.row] else { return UISwipeActionsConfiguration() }
        let share = UIContextualAction(style: .normal, title: "Поделиться") { (_, _, _)  in
            //let defaultText = [fishingInfo.title, fishingInfo.timeData].compactMap({$0}).joined(separator: " ")
            var image: UIImage?
            let defaultText = [fishingInfo.title, fishingInfo.timeData].compactMap({$0}).joined(separator: " ")
            if let data = fishingInfo.photo,
               let loadedImage = try?  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Data] {
                let images = loadedImage.compactMap({ UIImage(data: $0) })
                 image = images.first
                
            }

            let activityConteoller = UIActivityViewController(activityItems: [defaultText , image as Any], applicationActivities: nil)
            self.present(activityConteoller, animated: true, completion: nil)
        }
        let delete = UIContextualAction(style: .normal, title: "Удалить") { (_, _, _)  in
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                self.tbldViewData.setEditing(true, animated: true)
                context.delete(((self.presenter?.info [indexPath.row]))!)
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                self.deleteData(indexPath: indexPath)
            }
        }
        let action = UISwipeActionsConfiguration(actions: [delete, share])
        delete.backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        delete.image = UIImage(named: "delete")
        
        share.backgroundColor = UIColor(red: 254.0/255.0, green: 149.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        share.image = UIImage(named: "share")
       
        return action
    }
}
