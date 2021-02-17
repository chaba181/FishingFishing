//
//  TipsViewController.swift
//  Fishing
//
//  Created by mac on 28.01.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import UIKit

class TipsViewController: UIViewController {

    @IBOutlet weak var tipsTextView: UITextView!
    @IBOutlet weak var tipsImage: UIImageView!
    @IBOutlet weak var tipsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        tipsImage.image = UIImage(named: "advice1")
        tipsTextView.text = NSLocalizedString("carp", comment: "123")
    }
    
}
