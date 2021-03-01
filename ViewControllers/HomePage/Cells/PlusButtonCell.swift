//
//  PlusButtonCell.swift
//  Fishing
//
//  Created by mac on 29.09.2020.
//  Copyright © 2020 chabanenko. All rights reserved.
//

import UIKit

class PlusButtonCell: UICollectionViewCell {
    
    var onAddButtonClick: (() -> Void)?
    
    @IBAction private func onAddClicked(_ sender: Any) {
        onAddButtonClick?()
    }
}
