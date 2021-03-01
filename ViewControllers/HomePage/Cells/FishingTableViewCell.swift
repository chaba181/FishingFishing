//
//  FishingTableViewCell.swift
//  Fishing
//
//  Created by mac on 18.01.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import UIKit

class FishingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fishingName: UILabel!
    @IBOutlet weak var fishingDate: UILabel!
    @IBOutlet weak var fishingLocation: UILabel!
    @IBOutlet weak var fishingImage: UIImageView! {
        didSet {
            fishingImage.layer.cornerRadius = fishingImage.frame.height / 2
            fishingImage.clipsToBounds = true
        }
    }
}
