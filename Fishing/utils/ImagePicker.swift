//
//  ImagePicker.swift
//  Fishing
//
//  Created by mac on 11.11.2020.
//  Copyright © 2020 chabanenko. All rights reserved.
//

import Foundation
import UIKit
class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    #warning("Добавь сюда возможность кропать картинки, почитай что такое crop imag for UIPickerViewContrller, сделай это параметром этого класса")
    private var imagePickerController: UIImagePickerController
    var didImagePick: ((UIImage) -> Void)?
    var didPickingCancel: (() -> Void)?
    
    override init() {
        imagePickerController  = UIImagePickerController()
        super.init()
        imagePickerController.delegate = self
    }
    
    func pickImage(from viewCotroller: UIViewController) {
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a photo", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                #warning("строки вынеси в локализацию")
                #warning("тут retain cycle - почитай что это и попробуй убарть")
                self.imagePickerController.sourceType = .camera
                viewCotroller.present(self.imagePickerController, animated: true, completion: nil)
            } else {
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_: UIAlertAction) in
            #warning("тут retain cycle - почитай что это и попробуй убарть")
            self.imagePickerController.sourceType = .photoLibrary
            viewCotroller.present(self.imagePickerController, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cencel", style: .cancel, handler: nil ))
        
        viewCotroller.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {return}
        didImagePick?(image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        didPickingCancel?()
        
    }
    
}
