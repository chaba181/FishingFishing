import UIKit
import Alamofire
import FSCalendar

class ViewController: UIViewController {
    
    var presenter: Presenter?
    
    @IBOutlet private var tbldViewData: UITableView!
    private weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = Presenter()
        presenter?.controller = self
        
        tbldViewData.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tbldViewData.delegate = self
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
        if let cell = tbldViewData.dequeueReusableCell(withIdentifier: "Cell") {
            cell.textLabel?.text = [fishingInfo.title, fishingInfo.timeData].compactMap({$0}).joined(separator: " ")
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
    
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                if editingStyle == .delete {
                    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                        self.tbldViewData.setEditing(true, animated: true)
                        context.delete(((presenter?.info [indexPath.row]))!)
                    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                        deleteData(indexPath: indexPath)
                }
                }
        }
   
    func deleteData(indexPath:IndexPath) {
        self.presenter?.info.remove(at: indexPath.row)
    }
}
