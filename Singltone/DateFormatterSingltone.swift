//
//  DateFormatterSingltone.swift
//  Fishing
//
//  Created by mac on 22.02.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import Foundation
import UIKit

class DateFormatterSingltone {
    
    static let sharedFormat = DateFormatterSingltone()
    
    func format() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
        return formatter
    }
    
    func setupFormat() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }
    
    func currentDate () -> String {
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: date as Date)
        return dateString
    }
}
