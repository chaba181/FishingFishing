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
    func start()
}

class WeatherViewController: UIViewController, WeatherPresenterOutput {

    private lazy var output: WeatherViewControllerOutput = {
        let presenter = WeatherPresenter()
        presenter.ouput = self
        return presenter
    }()
    
    @IBOutlet private weak var licationLabel: UILabel!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var weatherLabel: UILabel!
    @IBOutlet private weak var pressureLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var feelsLikeLabel: UILabel!
    @IBOutlet private weak var backgroundView: UIImageView!
    
    let gradientLayer = CAGradientLayer()
    private var activityIndicator: NVActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.layer.addSublayer(gradientLayer)
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .ballClipRotate, color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), padding: 20.0)
        activityIndicator.backgroundColor = .clear
        view.addSubview(activityIndicator)
        
        output.start()
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
        self.dayLabel.text = currentWeather.dayWeather
        
        if currentWeather.isNightMode {
            setGreyGradientBackground()
        } else {
            setBlueGradientBackground()
        }
    }
}
