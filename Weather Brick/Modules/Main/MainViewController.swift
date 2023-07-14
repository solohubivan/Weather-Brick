//
//  MainViewController.swift
//  Weather Brick
//
//  Created by Ivan Solohub on 14.07.2023.
//

import UIKit
import CoreLocation


class MainViewController: UIViewController {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescribLabel: UILabel!
    @IBOutlet weak var locationPositionLabel: UILabel!
    @IBOutlet weak var visualWeatherDisplayBrickView: UIView!
    
    var weatherData = WeatherData()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        startLocationManager()
    }
    
    // MARK: - UI setup
    
    private func setupUI() {
        setupBackgroundColor()
        setupTemperatureLabel()
        setupWeatherConditionLabel()
        setupLocationPositionLabel()
        setupVisualWeatherDisplayBrick()
    }
    
    private func setupBackgroundColor() {
        let imageView = UIImageView(image: R.image.image_background())
        imageView.frame = view.bounds
        imageView.contentMode = .scaleToFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(imageView)
    }
    
    private func setupTemperatureLabel() {
        view.addSubview(temperatureLabel)
        temperatureLabel.addConstraints(to_view: view, [
            .leading(anchor: view.leadingAnchor, constant: 16),
            .top(anchor: view.topAnchor, constant: 461),
            .bottom(anchor: view.bottomAnchor, constant: 224)])
        
        temperatureLabel.textColor = UIColor.standartTextColor
        temperatureLabel.font = R.font.ubuntuRegular(size: 83)
        temperatureLabel.text = ""
    }
    
    private func setupWeatherConditionLabel() {
        view.addSubview(weatherDescribLabel)
        weatherDescribLabel.addConstraints(to_view: view, [
            .leading(anchor: view.leadingAnchor, constant: 16),
            .top(anchor: view.topAnchor, constant: 558),
            .bottom(anchor: view.bottomAnchor, constant: 195)])
        
        weatherDescribLabel.textColor = UIColor.standartTextColor
        weatherDescribLabel.font = R.font.ubuntuLight(size: 36)
        weatherDescribLabel.text = ""
    }
    
    
    private func setupLocationPositionLabel() {
        view.addSubview(locationPositionLabel)
        locationPositionLabel.addConstraints(to_view: view, [
            .top(anchor: view.topAnchor, constant: 699),
            .bottom(anchor: view.bottomAnchor, constant: 90),
            .centerX(anchor: view.centerXAnchor)])
        
        locationPositionLabel.textColor = UIColor.standartTextColor
        locationPositionLabel.font = R.font.ubuntuMedium(size: 17)
        locationPositionLabel.text = ""
    }
    
    private func setupVisualWeatherDisplayBrick() {
        let viewFrame = CGRect(x: 0, y: 0, width: 224, height: 455)
        let customView = UIView(frame: viewFrame)
        
        let image = R.image.image_stone_normal()
        
        let imageView = UIImageView(image: image)
        imageView.frame = customView.bounds
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
        customView.addSubview(imageView)
        
        visualWeatherDisplayBrickView = customView
        visualWeatherDisplayBrickView.center.x = view.center.x
        view.addSubview(visualWeatherDisplayBrickView)
    }
    
    //MARK: - Private methods
    
    private func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        }
    }
    
    private func updateWeatherInfo(latitude: Double, longitude: Double) {
        let session = URLSession.shared
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=515fe6b9d0a1c97ce56f86231fdf5a97")!
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("DataTask error: \(error!.localizedDescription)")
                return
            }
            
            do {
                self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                print(self.weatherData)
                DispatchQueue.main.async {
                    self.updateUI()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    private func updateUI() {
        
        //updating temperatureLabel value
        let temperature = Int(weatherData.main.temp)
        temperatureLabel.text = "\(temperature)°"
        
        //updating weatherDescribLabel value
        if let weather = weatherData.weather.first?.main {
            let lowercaseWeather = weather.lowercased()
            weatherDescribLabel.text = "\(lowercaseWeather)"
        }
        
        //updating locationPositionLabel value
        let locationPositionCity = weatherData.name
        let text = "\(locationPositionCity)"
        
        let leftIconAttachment = NSTextAttachment()
        leftIconAttachment.image = R.image.icon_location()
        let rightIconAttachment = NSTextAttachment()
        rightIconAttachment.image = R.image.icon_search()
        
        let iconSize = CGSize(width: 16, height: 16)
        leftIconAttachment.bounds = CGRect(origin: .zero, size: iconSize)
        rightIconAttachment.bounds = CGRect(origin: .zero, size: iconSize)
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(attachment: leftIconAttachment))
        attributedString.append(NSAttributedString(string: text))
        attributedString.append(NSAttributedString(attachment: rightIconAttachment))
        
        locationPositionLabel.attributedText = attributedString
    }
}


//MARK: - extension to action after user location geting
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
        }
    }
}
