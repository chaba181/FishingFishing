//
//  FishingDetailTableViewCell.swift
//  Fishing
//
//  Created by mac on 21.01.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import UIKit

class FishingDetailTableViewCell: UITableViewCell {
    
    @IBOutlet  weak var keyLabel: UILabel!
    @IBOutlet  weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
