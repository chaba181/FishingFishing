//
//  ExtansionCollectionViewForCreateFishingVc.swift
//  Fishing
//
//  Created by mac on 22.02.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import Foundation
import UIKit

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
// MARK: - extension FishingDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource

extension FishingDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FishingDetailCollectionViewCell else {return UICollectionViewCell()}
        cell.imageView.image = images[indexPath.row]
        fish?.rating = buttonString
        cell.rateButton.setImage(UIImage(named: buttonString ?? ""), for: .normal)
        cell.showMap = { [weak self] in
            self?.goTotheMapView() }
        cell.showRate = { [weak self] in
            self?.goToTheRateView()
        }
        return cell
    }
}
