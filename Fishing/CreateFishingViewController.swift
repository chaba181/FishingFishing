import UIKit
import CoreData

class CreateFishingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet private var noteTxt: UITextView!

    @IBOutlet private var titleTextField: UITextField!
    
    @IBOutlet private var dateTxt: UITextField!
    
    var imagePicker = ImagePicker()
    
    var openPhoto = ImageCell()
    
    lazy var datePicker = UIDatePicker()
    
    var onDataAdded: ((FishingInfo) -> Void)?
    var isEdit: Bool = false
    
    var imagePickerController: UIImagePickerController!
    
    var images: [UIImage] = [] {
        didSet { collectionVIew.reloadData() }
    }
    
    @IBOutlet weak var collectionVIew: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        createDatePicker()
        
        collectionVIew.delegate = self
        collectionVIew.dataSource = self
        imagePicker.didImagePick = { [weak self] image in
            self?.images.append(image)
         
        }
        imagePicker.didPickingCancel = { [weak self] in
            self?.showCanceledAllert()
        }
    }
    
    func createDatePicker () {
        
        dateTxt.textAlignment = .center
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // barButton
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: false)
        
        // assign toolbar
        dateTxt.inputAccessoryView = toolbar
        dateTxt.inputView = datePicker
        
        // date picker mode
        datePicker.datePickerMode = .date
    }
    @objc private func donePressed () {
        
        // fornatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        dateTxt.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @IBAction func addFishingInfo(_ sender: Any) {
        let name = titleTextField.text
        let data = dateTxt.text
        let note = noteTxt.text
        let photo1 = NSMutableArray()
        var imageData = Data()
        for imgg in images {
            let data : NSData = NSData(data: imgg.pngData()!)
            photo1.add(data)
        }
        
        guard let photoObject = try? NSKeyedArchiver.archivedData(withRootObject: photo1, requiringSecureCoding: false) else {return}
            imageData = photoObject
        // let photo = images.first?.pngData()
        if name != nil && data != nil && note != nil {
            let addInfo = self.saveName(name: name!, data: data!, note: note!, photo: imageData)
            if let addInfo = addInfo {
                onDataAdded?(addInfo)
                navigationController?.popViewController(animated: true)
                
        }
        }
    }
    // добавляем данные при нажатии на save
    func saveName (name: String, data: String, note: String, photo: Data) -> FishingInfo? {
        // 1 alert если не добавили титул и дату
        if dateTxt.text!.isEmpty && titleTextField.text!.isEmpty {
            let action = UIAlertController(title: "Внимание!", message: "Поле Дата и Название должны быть заполнены", preferredStyle: .alert)
            action.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            }))
            self.present(action, animated: true, completion: nil)
            return nil
        } else {
            
            guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return nil}
            let person = FishingInfo(entity: FishingInfo.entity(), insertInto: context)
            
            person.setValue(name, forKey: "title")
            person.setValue(data, forKey: "timeData")
            person.setValue(note, forKey: "notes")
            person.setValue(photo, forKey: "photo")
            person.setValue("\(Date().timeIntervalSince1970)", forKey: "id")
                        
            do {
                try context.save()
                return person
            } catch let error as NSError {
                print("Could not save \(error) , \(error.userInfo)")
                return nil
            }
        }
    }
    func showCanceledAllert() {
        let allert = UIAlertController(title: "Внимание", message: "Вы отменили выбор картинки", preferredStyle: .alert)
        allert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: { _ in }))
        self.present(allert, animated: true, completion: nil)
    }
}

// UICollectionViewDataSource

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
