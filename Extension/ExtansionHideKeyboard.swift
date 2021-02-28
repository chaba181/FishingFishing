//
//  ExtansionHideKeyboard.swift
//  Fishing
//
//  Created by mac on 22.02.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedaround() {
        let taps = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dissmissKeyboard))
        taps.cancelsTouchesInView = false
        view.addGestureRecognizer(taps)
    }
    @objc func dissmissKeyboard () {
        view.endEditing(true)
    }
}
