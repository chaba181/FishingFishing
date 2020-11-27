import UIKit
import CoreData

class CreateFishingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet private var noteTxt: UITextView!

    @IBOutlet private var titleTextField: UITextField!
    
    @IBOutlet private var dateTxt: UITextField!
    #warning("Private?")
    var imagePicker = ImagePicker()
    
    var openPhoto = ImageCell()
    
    lazy var datePicker = UIDatePicker()
    
    var onDataAdded: ((FishingInfo) -> Void)?
    var isEdit: Bool = false
    #warning("тебе нужна эта переменная?")
    var imagePickerController: UIImagePickerController!
    
    var images: [UIImage] = [] {
        didSet { collectionVIew.reloadData() }
    }
    
    #warning("оутлеты вверх")
    @IBOutlet weak var collectionVIew: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        createDatePicker()
        
        collectionVIew.delegate = self
        collectionVIew.dataSource = self
        #warning("Разберись с memory maangment, retain cycle и зачем здесь нужен weak self")
        imagePicker.didImagePick = { [weak self] image in
            self?.images.append(image)
         
        }
        imagePicker.didPickingCancel = { [weak self] in
            self?.showCanceledAllert()
        }
    }
    #warning("закоменшечый код + я просил сделать отдельный клас TextFieldWithPicker который несет в себе эту логику")
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
        #warning("Сделай отдельный класс DateHelper который будет синглтоном и будет уметь работать с датой")
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
        #warning("убери варнинг")
        guard let photoObject = try? NSKeyedArchiver.archivedData(withRootObject: photo1, requiringSecureCoding: false) else {return}
            imageData = photoObject
        #warning("закоменченый код")
        // let photo = images.first?.pngData()
        #warning("перепеши через if let или guard let")
        if name != nil && data != nil && note != nil {
            #warning("название метода странное")
            let addInfo = self.saveName(name: name!, data: data!, note: note!, photo: imageData)
            if let addInfo = addInfo {
                onDataAdded?(addInfo)
                navigationController?.popViewController(animated: true)
                
        }
        }
    }
    
    #warning("закоменченый код")
    // добавляем данные при нажатии на save
    func saveName (name: String, data: String, note: String, photo: Data) -> FishingInfo? {
        // 1 alert если не добавили титул и дату
        #warning("Убрать !")
        if dateTxt.text!.isEmpty && titleTextField.text!.isEmpty {
            #warning("Строки в локализацию")
            #warning("Сделай екстенш для UIViewController который умеет показывать алерты, что б не копировать код повсеместно")
            let action = UIAlertController(title: "Внимание!", message: "Поле Дата и Название должны быть заполнены", preferredStyle: .alert)
            action.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            }))
            self.present(action, animated: true, completion: nil)
            return nil
        } else {
            
            guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {return nil}
            #warning("почему person?")
            let person = FishingInfo(entity: FishingInfo.entity(), insertInto: context)
            
            #warning("Вынеси все ключи в отдельный клас FishingInfoKeys и обращайся к ним только оттуда в идеале вообще сделай extension к FisingInfo + вынеси это в отедльный метод")
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
    
    #warning("убери do cathc")
    func showCanceledAllert() {
        #warning("Алерт должен вызываться из екстеншена который ты напишешь, строки в локализацию")
        let allert = UIAlertController(title: "Внимание", message: "Вы отменили выбор картинки", preferredStyle: .alert)
        allert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: { _ in }))
        self.present(allert, animated: true, completion: nil)
    }
}

#warning("сделай здесь не комментарий а прагма марк")
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
