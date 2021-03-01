//
//  CurrentWeather.swift
//  Fishing
//
//  Created by mac on 11.02.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import SwiftyJSON

struct CurrentWeather {
    
    let temperature: Double
    let pressure: Double
    let humidity: Double
    let appearmentTemperature: Double
    let iconName: String?
    var weatherName: String?
    var location: String
    var dayWeather: String
    
    var isNightMode: Bool { return iconName?.suffix(1) == "n" }
    var icon: UIImage? { return iconName.flatMap { UIImage(named: $0) } }
    
    init(json: JSON) {
        
        let jsonWeather = json["weather"].array?.first
        let jsonTemp = json["main"]
        self.iconName = jsonWeather?["icon"].stringValue
        
        self.weatherName = jsonWeather?["main"].stringValue
        self.location  = json["name"].stringValue
        
        self.pressure = ((round(jsonTemp["pressure"].doubleValue)))
        self.temperature = ((round(jsonTemp["temp"].doubleValue)))
        self.humidity = ((round(jsonTemp["humidity"].doubleValue)))
        self.appearmentTemperature = ((round(jsonTemp["feels_like"].doubleValue)))

        self.dayWeather = DateHelper.shared.string(from: Date(), dateFormat: "EEEE")
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
