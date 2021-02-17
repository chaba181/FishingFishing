//
//  TipsTableViewCell.swift
//  Fishing
//
//  Created by mac on 28.01.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import UIKit

class TipsTableViewCell: UITableViewCell {

    @IBOutlet weak var tipsImage: UIImageView! {
        didSet {
            
            tipsImage.layer.cornerRadius = tipsImage.frame.height/2
            tipsImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var tipsLabel: UILabel! 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
