//
//  ExtansionAlert.swift
//  Fishing
//
//  Created by mac on 22.02.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import Foundation
import UIKit

extension CreateFishingViewController {
    
    func alert() {
        let action = UIAlertController(title: "Внимание!", message: "Поле Дата и Название должны быть заполнены", preferredStyle: .alert)
        action.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
        self.present(action, animated: true, completion: nil)
    }
    
    func alertForPhoto() {
        let allert = UIAlertController(title: "Внимание", message: "Вы отменили выбор картинки", preferredStyle: .alert)
        allert.addAction( UIAlertAction(title: "OK", style: .cancel, handler: { _ in }))
        self.present(allert, animated: true, completion: nil)
    }
}
