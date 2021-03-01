//
//  DateFormatterSingltone.swift
//  Fishing
//
//  Created by mac on 22.02.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import Foundation

class DateHelper {
    
    static let shared = DateHelper()
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    func string(from date: Date, dateFormat: String) -> String {
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
    
    func currentDateString(dateFormat: String) -> String {
        return string(from: Date(), dateFormat: dateFormat)
    }
}
