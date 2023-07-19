//
//  MainViewController.swift
//  Weather Brick
//
//  Created by Ivan Solohub on 14.07.2023.
//

import UIKit
import CoreLocation
import CoreImage


class MainViewController: UIViewController {
    
    @IBOutlet weak private var temperatureLabel: UILabel!
    @IBOutlet weak private var weatherDescribLabel: UILabel!
    @IBOutlet weak private var locationPositionLabel: UILabel!
    @IBOutlet weak private var visualWeatherDisplayBrickView: UIView!
    @IBOutlet weak private var infoView: UIView!
    
    private var weatherData = WeatherData()
    private var locationManager = CLLocationManager()
    
    private var imageBrick = UIImage()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        startLocationManager()
    }
    
    // MARK: - UI setup
    
    private func setupUI() {
        setupBackgroundColor()
        setupInfoView()
        setupTemperatureLabel()
        setupWeatherConditionLabel()
        setupLocationPositionLabel()
        setupTapGestureRecognizer()
    }
    
    private func setupBackgroundColor() {
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = R.image.image_background()
        view.addSubview(backgroundImageView)
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
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 224, height: 455))
        
        let imageView = UIImageView(image: imageBrick)
        imageView.frame = customView.bounds
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
        customView.addSubview(imageView)
        
        visualWeatherDisplayBrickView = customView
        visualWeatherDisplayBrickView.center.x = view.center.x
        
        view.addSubview(visualWeatherDisplayBrickView)
    }
    
    private func setupWindVisualWeatherDisplayBrick() {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 224, height: 455))
        
        let imageView = UIImageView(image: imageBrick)
        imageView.frame = customView.bounds
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
        customView.addSubview(imageView)
        visualWeatherDisplayBrickView = customView
        
        let angleInDegrees: CGFloat = 15.0
        let angleInRadians = angleInDegrees * .pi / 180.0
        visualWeatherDisplayBrickView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        visualWeatherDisplayBrickView.frame.origin.y = -8
        visualWeatherDisplayBrickView.center.x = view.center.x
        
        UIView.animate(withDuration: 1, animations: {
                self.visualWeatherDisplayBrickView.transform = CGAffineTransform(rotationAngle: angleInRadians)
            }, completion: { _ in
                self.animateRotation()
            })
        
        view.addSubview(visualWeatherDisplayBrickView)
    }
    
    
    private func setupInfoView() {
        
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 175, height: 85))
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = contentView.bounds
        gradientLayer.colors = [
            UIColor(red: 1, green: 0.6, blue: 0.375, alpha: 1).cgColor,
            UIColor(red: 0.977, green: 0.315, blue: 0.106, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.3, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.3, y: 0.8)
        
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
        let label = UILabel()
        label.text = "INFO"
        label.textColor = UIColor.standartTextColor
        label.textAlignment = .center
        label.font = R.font.ubuntuBold(size: 18)
        
        contentView.addSubview(label)
        label.addConstraints(to_view: contentView, [
            .top(anchor: contentView.topAnchor, constant: 16),
            .bottom(anchor: contentView.bottomAnchor, constant: 47),
            .centerX(anchor: contentView.centerXAnchor)])
        
        view.addSubview(infoView)
        infoView.addConstraints(to_view: view, [
            .centerX(anchor: view.centerXAnchor),
            .bottom(anchor: view.bottomAnchor, constant: -22),
            .height(constant: 85),
            .width(constant: 175)])
        infoView.addSubview(contentView)
        
        infoView.layer.shadowColor = UIColor.black.cgColor
        infoView.layer.shadowOpacity = 0.5
        infoView.layer.shadowOffset = CGSize(width: 2, height: 4)
        infoView.layer.shadowRadius = 4
        infoView.layer.cornerRadius = 15
    }
    
    private func setupTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        infoView.addGestureRecognizer(tapGesture)
    }
    
    @objc func userTapped(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            
            let infoPageVC = InfoPageView()
            infoPageVC.modalPresentationStyle = .fullScreen
            present(infoPageVC, animated: false)
        }
    }
    
    //method for updatingDataAndView

    
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

        let temperature = Int(weatherData.main.temp)
        temperatureLabel.text = "\(temperature)°"
 
        if let weather = weatherData.weather.first?.main {
            let lowercaseWeather = weather.lowercased()
            weatherDescribLabel.text = "\(lowercaseWeather)"
        }
        
        updateBrickStateImage()
        createFormatForLocationPositionLabel()
    }
    
    private func updateBrickStateImage() {
        let weather = weatherData.weather.first?.main
        let temperature = Int(weatherData.main.temp)
        let windSpeed = Double(weatherData.wind.speed)
        
        var imageName = UIImage()
        
        if temperature > 30 {
            imageName = R.image.image_stone_cracks()!
        } else {
            switch weather {
            case "Clouds": imageName = R.image.image_stone_cracks()!
            case "Clear", "Sunny": imageName = R.image.image_stone_normal()!
            case "Rain", "Drizzle": imageName = R.image.image_stone_wet()!
            case "Snow": imageName = R.image.image_stone_snow()!
            case "Fog", "Haze", "Mist": imageName = applyBlurEffect(to: R.image.image_stone_normal()!)!
            default:
                imageName = R.image.image_stone_normal()!
            }
        }
        imageBrick = imageName
        
        if windSpeed > 10 {
            setupWindVisualWeatherDisplayBrick()
        } else {
            setupVisualWeatherDisplayBrick()
        }
    }
    
    private func applyBlurEffect(to image: UIImage) -> UIImage? {
        if let ciImage = CIImage(image: image) {
            let blurFilter = CIFilter(name: "CIGaussianBlur")
            blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
            blurFilter?.setValue(5.0, forKey: kCIInputRadiusKey)
            
            if let outputCIImage = blurFilter?.outputImage {
                let context = CIContext(options: nil)
                if let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) {
                    let blurredImage = UIImage(cgImage: outputCGImage)
                    return blurredImage
                }
            }
        }
        return nil
    }
    
    private func createFormatForLocationPositionLabel() {
        let text = " \(weatherData.name), \(weatherData.sys.country) "
        
        let leftIconAttachment = NSTextAttachment()
        leftIconAttachment.image = R.image.icon_location()
        let rightIconAttachment = NSTextAttachment()
        rightIconAttachment.image = R.image.icon_search()
        
        let iconSize = CGSize(width: Constants.iconSize, height: Constants.iconSize)
        leftIconAttachment.bounds = CGRect(origin: .zero, size: iconSize)
        rightIconAttachment.bounds = CGRect(origin: .zero, size: iconSize)
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(attachment: leftIconAttachment))
        attributedString.append(NSAttributedString(string: text))
        attributedString.append(NSAttributedString(attachment: rightIconAttachment))
        
        locationPositionLabel.attributedText = attributedString
    }
    
    private func animateBackRotation() {
        let angleInDegrees: CGFloat = -15.0
        let angleInRadians = angleInDegrees * .pi / 180.0

        UIView.animate(withDuration: 2, animations: {
            self.visualWeatherDisplayBrickView.transform = CGAffineTransform(rotationAngle: angleInRadians)
        }, completion: { _ in
            self.animateRotation()
        })
    }
    
    private func animateRotation() {
        let angleInDegrees: CGFloat = 15.0
        let angleInRadians = angleInDegrees * .pi / 180.0

        UIView.animate(withDuration: 2, animations: {
            self.visualWeatherDisplayBrickView.transform = CGAffineTransform(rotationAngle: angleInRadians)
        }, completion: { _ in
            self.animateBackRotation()
        })
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

//MARK: - Constants
extension MainViewController {
    private enum Constants {
        static let iconSize: CGFloat = 16
    }
}
