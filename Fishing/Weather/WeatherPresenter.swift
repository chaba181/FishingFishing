//
//  WeatherPresenter.swift
//  Fishing
//
//  Created by mac on 16.02.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol WeatherPresenterOutput: class {
    func startAnimating ()
    func stopAnimating()
    func setUpWitheCurrentWeather(currentWeather: CurrentWeather)
    func setLocation()
}

class WeatherPresenter: WeatherViewControllerOutput {
    weak var ouput: WeatherPresenterOutput?
    
    func loadCurrentWeather(latitude: Double, longitude: Double ) {
        ouput?.startAnimating()
        
        AF.request("http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(Constants.appKey)&units=metric").responseJSON { [ weak self ] response in
            
            self?.ouput?.stopAnimating()
            
            switch response.result {
            case let .success(value):
                let jsonResponse = JSON(value)
                let currentWeather = CurrentWeather(jason: jsonResponse)
                self?.ouput?.setUpWitheCurrentWeather(currentWeather: currentWeather)
            case .failure: break
            }
        }
    }
}
