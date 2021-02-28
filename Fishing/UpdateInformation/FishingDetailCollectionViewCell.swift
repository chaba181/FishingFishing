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
    
    @IBAction func mapButtonAction(_ sender: Any) {
        showMap?()
    }
    
    @IBAction func rateButtonAction(_ sender: Any) {
        showRate?()
    }
}
#warning("Тебе туту еще надо будет почитать на каком метод подписаться для того чтобы pagecontroll правильно менялся")

//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
//    }
