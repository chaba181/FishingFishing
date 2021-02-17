import UIKit
import CoreData

class CreateFishingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet private weak var noteTxt: UITextView!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var dateTxt: TextFieldWithDataPicker!
    @IBOutlet private weak var collectionVIew: UICollectionView!
    @IBOutlet private weak var addressText: UITextField!
    
    var date: Date?
    var imagePicker = ImagePicker()
    var openPhoto = ImageCell()
    
    lazy var datePicker = UIDatePicker()
    
    var onDataAdded: ((FishingInfo) -> Void)?
    var isEdit: Bool = false
    
    var images: [UIImage] = [] {
        didSet { collectionVIew.reloadData() }
    }
    
    // MARK: - CreateFishingViewController life cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionVIew.delegate = self
        collectionVIew.dataSource = self

        imagePicker.didImagePick = { [weak self] in
            self?.images.append($0)
            
        }
        imagePicker.didPickingCancel = { [weak self] in
            self?.showCanceledAllert()
        }
        
        dateTxt.onDonePressed = { [weak self] in
            self?.view.endEditing(true)
            
        }
        
        dateTxt.onTextChanged = { [weak self] date in
            self?.date = date
        }
        self.hideKeyboardWhenTappedaround()
    }
    
    @IBAction func addFishingInfo(_ sender: Any) {
        
        let photo1 = NSMutableArray()
        var imageData = Data()
        for imgg in images {
            let data : NSData = NSData(data: imgg.pngData()!)
            photo1.add(data)
        }
        guard let photoObject = try? NSKeyedArchiver.archivedData(withRootObject: photo1, requiringSecureCoding: false) else {return}
        imageData = photoObject
        guard let name = titleTextField.text, let data = dateTxt.text, let note = noteTxt.text, let address = addressText.text else {return}
        #warning("название метода странное")
        let addInfo = self.saveName(name: name, data: data, note: note, photo: imageData, address: address)
        if let addInfo = addInfo {
            onDataAdded?(addInfo)
            navigationController?.popViewController(animated: true)
            
        }
    }
    
    func saveName (name: String, data: String, note: String, photo: Data, address: String) -> FishingInfo? {
        if dateTxt.text?.isEmpty == true && titleTextField.text?.isEmpty == true {
            #warning("Строки в локализацию")
            alert()
            return nil
        } else {
            
            guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return nil}
            let fish = FishingInfo(entity: FishingInfo.entity(), insertInto: context)
            
            #warning("Вынеси все ключи в отдельный клас FishingInfoKeys и обращайся к ним только оттуда в идеале вообще сделай extension к FisingInfo + вынеси это в отедльный метод")
            //fish.notes = note
            fish.setValue(name, forKey: "title")
            fish.setValue(data, forKey: "timeData")
            fish.setValue(note, forKey: "notes")
            fish.setValue(photo, forKey: "photo")
            fish.setValue(address, forKey: "address")
            fish.setValue("\(Date().timeIntervalSince1970)", forKey: "id")
            
            guard (try? context.save()) != nil else {return nil}
            return fish
        }
    }
    
    func showCanceledAllert() {
        alertForphoto()
    }
}

// MARK: - UICollectionViewDataSource

extension CreateFishingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        
        if indexPath.row >= images.count || images.isEmpty {
            let plusCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PlusButtonCell.self), for: indexPath)
            cell = plusCell
            
            if let cell = cell as? PlusButtonCell {
                cell.onAddButtonClick = { [unowned self] in
                    self.imagePicker.pickImage(from: self)
                }
            }
        } else {
            let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageCell.self), for: indexPath)
            cell = imageCell
            
            if let cell = cell as? ImageCell {
                cell.imageView.image = images[indexPath.row]
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

// MARK: - UIAllertController

extension CreateFishingViewController {
    func alert () {
        let action = UIAlertController(title: "Внимание!", message: "Поле Дата и Название должны быть заполнены", preferredStyle: .alert)
        action.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
        }))
        self.present(action, animated: true, completion: nil)
        
    }
    func alertForphoto () {
        let allert = UIAlertController(title: "Внимание", message: "Вы отменили выбор картинки", preferredStyle: .alert)
        allert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: { _ in }))
        self.present(allert, animated: true, completion: nil)
    }
    
}
// MARK: - hideKeyboardWhenTappedaround

extension UIViewController {
    func hideKeyboardWhenTappedaround() {
        let taps = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dissmissKeyboard))
        taps.cancelsTouchesInView = false
        view.addGestureRecognizer(taps)
    }
    @objc func dissmissKeyboard () {
        view.endEditing(true)
    }
}
