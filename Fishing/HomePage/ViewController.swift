import UIKit
import Alamofire
import FSCalendar

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet var tbldViewData: UITableView!
    private weak var calendar: FSCalendar!
    
    var presenter: Presenter?
    
    // MARK: - View Controller life cycle
    
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
