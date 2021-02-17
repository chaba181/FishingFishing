//
//  WeatherViewController.swift
//  
//
//  Created by mac on 11.02.2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation

protocol WeatherViewControllerOutput {
    func loadCurrentWeather(latitude: Double, longitude: Double )
}

class WeatherViewController: UIViewController, CLLocationManagerDelegate, WeatherPresenterOutput {

    private lazy var output: WeatherViewControllerOutput = {
        let presenter = WeatherPresenter()
        presenter.ouput = self
        return presenter
    }()
    
    @IBOutlet weak var licationLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var backgroundView: UIImageView!
    
    let gradientLayer = CAGradientLayer()
    
    var lat1 = 11.124
    var lon1 = 111.3545
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.layer.addSublayer(gradientLayer)
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .ballClipRotate, color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), padding: 20.0)
        activityIndicator.backgroundColor = .clear
        view.addSubview(activityIndicator)
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat1 = location.coordinate.latitude
        lon1 = location.coordinate.longitude
        output.loadCurrentWeather(latitude: lat1, longitude: lon1)

    }
    
    func setBlueGradientBackground() {
        let topColor = UIColor(red: 95.0/255.0, green: 165.0/255.0, blue: 1.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 114.0/255.0, blue: 184.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    func setGreyGradientBackground() {
        let topColor = UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green: 72.0/255.0, blue: 72.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    func setDate () {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        self.dayLabel.text = dateFormatter.string(from: date)
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
    func setUpWitheCurrentWeather(currentWeather: CurrentWeather) {
        self.weatherImageView.image = currentWeather.icon
        self.pressureLabel.text = currentWeather.pressureString
        self.feelsLikeLabel.text = currentWeather.appearmentString
        self.temperatureLabel.text = currentWeather.temperatureString
        self.humidityLabel.text = currentWeather.himidityString
        self.licationLabel.text = currentWeather.location
        self.weatherLabel.text = currentWeather.weatherName
        
        if currentWeather.isNightMode {
            setBlueGradientBackground()
        } else {
            setGreyGradientBackground()
        }
    }
    func setLocation() {
        
    }
}
