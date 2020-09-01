
import UIKit
import Alamofire
import FSCalendar

class ViewController: UIViewController {
    
    fileprivate weak var calendar: FSCalendar!

    override func viewDidLoad() {
        
        super.viewDidLoad()
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
}
extension ViewController: FSCalendarDataSource, FSCalendarDelegate {
}
