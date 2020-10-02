
import UIKit
import CoreData

class CreateFishingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var noteTxt: UITextView!
    // название
    @IBOutlet weak var titleTextField: UITextField!
    // дата
    @IBOutlet weak var dateTxt: UITextField!
    // image
    
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
    }
    
    // добавляем данныe
    func pickImage() {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a photo", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePickerController.sourceType = .camera
                self.present(self.imagePickerController, animated: true, completion: nil)
            } else {
                print("Cammera not available")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cencel", style: .cancel, handler: nil ))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    //Почитать и коммент
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        images.append(image)
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
        
        if name != nil && data != nil && note != nil {
            let addInfo = self.saveName(name: name!, data: data!, note: note!)
            if let addInfo = addInfo {
                onDataAdded?(addInfo)
                navigationController?.popViewController(animated: true)
                
            }
        }
    }
    // добавляем данные при нажатии на save
    func saveName (name: String, data: String, note: String) -> FishingInfo? {
        // 1 alert если не добавили титул и дату
        if dateTxt.text!.isEmpty && titleTextField.text!.isEmpty {
            let action = UIAlertController(title: "Внимание!", message: "Поле Дата и Название должны быть заполнены", preferredStyle: .alert)
            action.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            }))
            self.present(action, animated: true, completion: nil)
            return nil
        } else {
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let person = FishingInfo(entity: FishingInfo.entity(), insertInto: context)
            // image
            
            person.setValue(name, forKey: "title")
            person.setValue(data, forKey: "timeData")
            person.setValue(note, forKey: "notes")
            person.setValue("\(Date().timeIntervalSince1970)", forKey: "id")
            
            do {
                try context.save()
                return person
            }  catch let error as NSError {
                return nil
                print("Could not save \(error) , \(error.userInfo)")
            }
        }
    }
    //    func alert () {
    //        if dateTxt.text!.isEmpty && titleTextField.text!.isEmpty {
    //                let action = UIAlertController(title: "Внимание!", message: "Поле Дата и Название должны быть заполнены", preferredStyle: .alert)
    //                action.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
    //                }))
    //                self.present(action, animated: true, completion: nil)
    //            }
    //        if titleTextField.text!.isEmpty {
    //            let action = UIAlertController(title: "Внимание!", message: "Поле Название должно быть заполнено", preferredStyle: .alert)
    //            action.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
    //            }))
    //            self.present(action, animated: true, completion: nil)
    //        }
    //
    //        if dateTxt.text!.isEmpty {
    //            let action = UIAlertController(title: "Внимание!", message: "Поле Дата должно быть заполнено", preferredStyle: .alert)
    //            action.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
    //            }))
    //            self.present(action, animated: true, completion: nil)
    //        }
    //        }
    //}
}

// UICollectionViewDataSource

extension CreateFishingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        
        if indexPath.row >= images.count || images.isEmpty {
            let plusCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PlusButtonCell.self), for: indexPath)
            cell = plusCell
            
            if let cell = cell as? PlusButtonCell {
                cell.onAddButtonClick = { [weak self] in
                    self?.pickImage()
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
}
