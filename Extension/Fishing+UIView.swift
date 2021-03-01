//
//  Fishing+UIView.swift
//  Fishing
//
//  Created by Pavel Reva on 01.03.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import UIKit

extension UIView {
    func setBlueGradientBackground() {
        let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
        setupGradient(topColor: topColor, bottomColor: bottomColor)
    }
    
    func setGreyGradientBackground() {
        let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
        setupGradient(topColor: topColor, bottomColor: bottomColor)
    }
    
    private func setupGradient(topColor: CGColor, bottomColor: CGColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [topColor, bottomColor]
        self.layer.addSublayer(gradientLayer)
    }
}
