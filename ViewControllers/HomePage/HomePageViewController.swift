import UIKit
import Alamofire
import FSCalendar

protocol HomePageViewControllerOutput {
    var info: [FishingInfo] { get set }
    func loadData()
}

class HomePageViewController: UIViewController {
    
    private struct Constants {
        static let estimatedRowHeight: CGFloat = 38
        static let cellIdentifier = "Cell"
    }
    
    // MARK: - Properties
    
    @IBOutlet var tableView: UITableView!
    private weak var calendar: FSCalendar!
    
    lazy var output: HomePageViewControllerOutput = {
        let presenter = HomePagePresenter()
        presenter.output = self
        return presenter
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        output.loadData()
    }
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - HomePagePresentOutput
extension HomePageViewController: HomePagePresenterOutput {
    func didDataUpdate() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomePageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fishingInfo = output.info[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier) as? FishingTableViewCell {
            
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
        let fishingInfo = output.info[indexPath.row]
        
        guard let controller =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FishingDetailViewController") as? FishingDetailViewController else { return }
        controller.fish = fishingInfo
        
        controller.onDataAdded = { [weak self] fishingInfo in
            self?.tableView.reloadData()
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func deleteData(indexPath:IndexPath) {
        output.info.remove(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let fishingInfo = output.info[indexPath.row]
        
        let share = UIContextualAction(style: .normal, title: "Поделиться") { [weak self] (_, _, _)  in
            var image: UIImage?
            
            let defaultText = [fishingInfo.title, fishingInfo.timeData].compactMap({$0}).joined(separator: " ")
            
            if let data = fishingInfo.photo,
               let loadedImage = try?  NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Data] {
                let images = loadedImage.compactMap({ UIImage(data: $0) })
                image = images.first
            }
            
            let activityConteoller = UIActivityViewController(activityItems: [defaultText , image as Any], applicationActivities: nil)
            
            self?.present(activityConteoller, animated: true, completion: nil)
        }
        
        let delete = UIContextualAction(style: .normal, title: "Удалить") { [weak self] (_, _, _)  in
            
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                
                self?.tableView.setEditing(true, animated: true)
                
                if let info = self?.output.info[indexPath.row] {
                    context.delete(info)
                }
                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                
                self?.deleteData(indexPath: indexPath)
            }
        }
        
        let action = UISwipeActionsConfiguration(actions: [delete, share])
        delete.backgroundColor = #colorLiteral(red: 1, green: 0.2211629322, blue: 0.03118017327, alpha: 1)
        delete.image = UIImage(named: "delete")
        
        share.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        share.image = UIImage(named: "share")
        
        return action
    }
}
