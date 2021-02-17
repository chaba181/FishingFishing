//
//  FishingDetailCollectionViewCell.swift
//  Fishing
//
//  Created by mac on 23.01.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import UIKit

class FishingDetailCollectionViewCell: UICollectionViewCell {
    
    var showMap: (() -> Void)?
    var showRate: (() -> Void)?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rateButton: UIButton! {
        didSet {
            rateButton.layer.cornerRadius = 5
            rateButton.layer.borderWidth = 1
            rateButton.layer.borderColor = UIColor.white.cgColor
            
        }
    }
    
    @IBOutlet weak var mapButton: UIButton! {
        didSet {
            mapButton.layer.cornerRadius = 5
            mapButton.layer.borderWidth = 1
            mapButton.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @IBAction func mapButtinAction(_ sender: Any) {
        showMap?()
    }
    
    @IBAction func rateButtonAction(_ sender: Any) {
        showRate?()
    }
}
