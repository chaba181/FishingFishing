//
//  WeatherPresenter.swift
//  Fishing
//
//  Created by mac on 16.02.2021.
//  Copyright © 2021 chabanenko. All rights reserved.
//

import Alamofire
import SwiftyJSON
import CoreLocation

protocol WeatherPresenterOutput: class {
    func startAnimating ()
    func stopAnimating()
    func setUpWitheCurrentWeather(currentWeather: CurrentWeather)
}

class WeatherPresenter: NSObject, WeatherViewControllerOutput, CLLocationManagerDelegate {
    
    private struct Constants {
        static let weatherAppKey = "bef7d43ec5d14bf5108620f2a88d951b"
        static let defaultLatitude = 123.14
        static let defaultLongitude = 14444.45
    }
    
    weak var ouput: WeatherPresenterOutput?
    
    private var lotitide = Constants.defaultLatitude
    private var longitude = Constants.defaultLongitude
    
    private let locationManager: CLLocationManager!
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
    }
    
    func loadCurrentWeather(latitude: Double, longitude: Double) {
        let requestString = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(Constants.weatherAppKey)&units=metric"
        
        ouput?.startAnimating()
        AF.request(requestString).responseJSON { [ weak self ] response in
            self?.ouput?.stopAnimating()
            
            switch response.result {
            case let .success(value):
                let jsonResponse = JSON(value)
                let currentWeather = CurrentWeather(json: jsonResponse)
                self?.ouput?.setUpWitheCurrentWeather(currentWeather: currentWeather)
            case .failure: break
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let lotitide = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        loadCurrentWeather(latitude: lotitide, longitude: longitude)
        
    }
    
    func start() {
        locationManager.startUpdatingLocation()
    }
}
