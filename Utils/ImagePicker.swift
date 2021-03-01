//
//  ImagePicker.swift
//  Fishing
//
//  Created by mac on 11.11.2020.
//  Copyright © 2020 chabanenko. All rights reserved.
//

import UIKit

class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var imagePickerController: UIImagePickerController
    var didImagePick: ((UIImage) -> Void)?
    var didPickingCancel: (() -> Void)?
    
    override init() {
        imagePickerController  = UIImagePickerController()
        super.init()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
    }
    
    func pickImage(from viewCotroller: UIViewController) {
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a photo", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self?.imagePickerController.sourceType = .camera
                viewCotroller.present(self?.imagePickerController ?? UIImagePickerController(), animated: true, completion: nil)
            }
        })
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            self?.imagePickerController.sourceType = .photoLibrary
            viewCotroller.present(self?.imagePickerController ?? UIImagePickerController(), animated: true, completion: nil)
            
        })
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))

        viewCotroller.present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        didImagePick?(image)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        didPickingCancel?()
    }
}
