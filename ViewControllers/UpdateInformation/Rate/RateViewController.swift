//
//  RateViewController.swift
//  Fishing
//
//  Created by mac on 23.01.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {
    
    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private weak var rateStackView: UIStackView!
    @IBOutlet private weak var sadButton: UIButton!
    @IBOutlet private weak var goodButton: UIButton!
    @IBOutlet private weak var amazingButton: UIButton!
    @IBOutlet weak var closeRate: UIButton!
    
    var fishRating: String?
    
    var onRatingChosen: ((String?) -> Void)?

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        transform()
        //blurEffect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateRateButtons()
    }
    
    // MARK: - Private
    
    private func blurEffect () {
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.insertSubview(blurView, at: 1)
        
    }
    
    private func transform () {
        sadButton.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        goodButton.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        amazingButton.transform = CGAffineTransform.init(scaleX: 0, y: 0)
    }
    
    private func animateRateButtons() {
        let rate = [sadButton,goodButton,amazingButton]
        for (idex, value) in rate.enumerated() {
            let delay = Double(idex) * 0.2
            UIView.animate(withDuration: 0.6, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                value?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func rateFishing (sender: UIButton) {
        switch sender.tag {
        case 0: fishRating = "bad"
        case 1: fishRating = "good"
        case 2: fishRating = "brilliant"
        case 3: fishRating = "good"
        default: break
        }
        onRatingChosen?(fishRating)
        dismiss(animated: true, completion: nil)
    }
}
