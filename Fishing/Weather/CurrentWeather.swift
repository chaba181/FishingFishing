//
//  CurrentWeather.swift
//  Fishing
//
//  Created by mac on 11.02.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

struct CurrentWeather {
    let temperature: Double
    let pressure: Double
    let humidity: Double
    let appearmentTemperature: Double
    let iconName: String?
    var weatherName: String?
    var location: String
    var icon: UIImage? {
        return UIImage(named: iconName ?? "")
    }
    var dayWeather: String
    
    var isNightMode: Bool {
        let suffix = iconName?.suffix(1)
        return suffix == "n"
        
    }
    
    init(jason: JSON) {
        
        let jsonWeather = jason["weather"].array?.first
        let jsonTemp = jason["main"]
        self.iconName = jsonWeather?["icon"].stringValue
        
        self.weatherName = jsonWeather?["main"].stringValue
        self.location  = jason["name"].stringValue
        
        self.pressure = ((round(jsonTemp["pressure"].doubleValue)))
        self.temperature = ((round(jsonTemp["temp"].doubleValue)))
        self.humidity = ((round(jsonTemp["humidity"].doubleValue)))
        self.appearmentTemperature = ((round(jsonTemp["feels_like"].doubleValue)))
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        self.dayWeather = dateFormatter.string(from: date)
    }
    
}

extension CurrentWeather {
    var pressureString: String {
        return ("\(Int(pressure)) mm")
    }
    var temperatureString: String {
        return ("\(Int(temperature))˚C")
    }
    var himidityString: String {
        return ("\(Int(humidity)) %")
    }
    var appearmentString: String {
        return ("Feels like: \(Int(appearmentTemperature))˚C")
    }
    
}
