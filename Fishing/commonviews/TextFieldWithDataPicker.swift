//
//  TextFieldWithDataPicker.swift
//  Fishing
//
//  Created by mac on 02.12.2020.
//  Copyright © 2020 chabanenko. All rights reserved.
//

import UIKit

class TextFieldWithDataPicker: UITextField {
    
    var onDonePressed: (() -> Void)?
    var onTextChanged: ((Date) -> Void)?
    
    var date: Date? {
        datePicker?.date
    }
    
    private var datePicker: UIDatePicker? {
        inputView as? UIDatePicker
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.textAlignment = .center
        let datePicker = DateFormatterSingltone.sharedFormat.setupFormat()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: false)
        
        self.inputAccessoryView = toolbar
        self.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    @objc private func donePressed () {
        onDonePressed?()
    }
    
    @objc private func dateChanged() {
        let formatter = DateFormatterSingltone.sharedFormat.format()
        guard let date = self.datePicker?.date else { return }
        self.text = formatter.string(from: date)
        onTextChanged?(date)
    }
}
