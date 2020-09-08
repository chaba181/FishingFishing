
import UIKit
import CoreData

class CreateFishingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var noteTxt: UITextView!
    // название
    @IBOutlet weak var titleTextField: UITextField!
    // дата
    @IBOutlet weak var dateTxt: UITextField!
    
    lazy var datePicker = UIDatePicker()
    
    @IBOutlet weak var imageView: UIImageView!
    
    var onDataAdded: ((FishingInfo) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePicker()
        
    }
       
    // добавляем данные
    // /// // /
    @IBAction func chosseImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a photo", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                print("Cammera not available")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cencel", style: .cancel, handler: nil ))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    //Почитать и коммент
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
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
    
    @IBAction func addInfo(_ sender: Any) {
        let name = titleTextField.text
        let data = dateTxt.text
       if name != nil && data != nil {
           let addInfo = self.saveName(name: name!, data: data!)
           if let addInfo = addInfo {
               onDataAdded?(addInfo)
                navigationController?.popViewController(animated: true)
            
        }
        }
    }
    
    func saveName (name: String, data: String) -> FishingInfo? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let person = FishingInfo(entity: FishingInfo.entity(), insertInto: context)
        person.setValue(name, forKey: "title")
        person.setValue(data, forKey: "timeData")
                
                do {
                    try context.save()
                    return person
                }  catch let error as NSError {
                    return nil
                    print("Could not save \(error) , \(error.userInfo)")
                }
                
            }
    
}
