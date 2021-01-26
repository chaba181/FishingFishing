//
//  RateViewController.swift
//  Fishing
//
//  Created by mac on 23.01.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {

    @IBOutlet weak var rateStackView: UIStackView!
    @IBOutlet weak var sadButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var amazingButton: UIButton!
    var fishRating: String?
    
    @IBAction func rateFishing (sender: UIButton) {
        switch sender.tag {
        case 0: fishRating = "bad"
        case 1: fishRating = "good"
        case 2: fishRating = "brilliant"
        default: break
        }
        performSegue(withIdentifier: "unwidSegueToDVC", sender: sender)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
            let rate = [sadButton,goodButton,amazingButton]
        for (idex, value) in rate.enumerated() {
            let delay = Double(idex) * 0.2
            UIView.animate(withDuration: 0.6, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                value?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }, completion: nil)
        }
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        sadButton.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        goodButton.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        amazingButton.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        // Do any additional setup after loading the view.
    }
    
}
