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
    
    private var datePicker: UIDatePicker? { inputView as? UIDatePicker }
    
    // MARK: - Init/Deninit
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Private
    
    private func setup() {
        self.textAlignment = .center
        
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: false)
        
        self.inputAccessoryView = toolbar
        self.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    // MARK: - Actions
    
    @objc private func donePressed () {
        onDonePressed?()
    }
    
    @objc private func dateChanged() {
        guard let date = self.datePicker?.date else { return }
        self.text = DateHelper.shared.string(from: date, dateFormat: "dd MM yyyy")
        onTextChanged?(date)
    }
}
