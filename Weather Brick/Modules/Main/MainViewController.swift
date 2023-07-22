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
    
    private var lastLatitude: Double = 0.0
    private var lastLongitude: Double = 0.0
    private var initialYPosition: CGFloat = 0.0
    
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
        setupTapGestureRecognizerForInfoView()
        setupPullToRefresh()
    }
    
    private func setupBackgroundColor() {
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = R.image.image_background()
        view.addSubview(backgroundImageView)
    }
    
    private func setupTemperatureLabel() {
        view.addSubview(temperatureLabel)
        temperatureLabel.addConstraints(to_view: view, [
            .leading(anchor: view.leadingAnchor, constant: Constants.leadingIndent),
            .top(anchor: view.topAnchor, constant: Constants.topIndentTemperatureLabel),
            .bottom(anchor: view.bottomAnchor, constant: Constants.bottomIndentTemperatureLabel)])
        
        temperatureLabel.textColor = UIColor.normalBlackTextColor
        temperatureLabel.font = R.font.ubuntuRegular(size: 83)
        temperatureLabel.text = ""
    }
    
    private func setupWeatherConditionLabel() {
        view.addSubview(weatherDescribLabel)
        weatherDescribLabel.addConstraints(to_view: view, [
            .leading(anchor: view.leadingAnchor, constant: Constants.leadingIndent),
            .top(anchor: view.topAnchor, constant: Constants.topIndentWeatherConditionLabel),
            .bottom(anchor: view.bottomAnchor, constant: Constants.bottomIndentWeatherConditionLabel)])
        
        weatherDescribLabel.textColor = UIColor.normalBlackTextColor
        weatherDescribLabel.font = R.font.ubuntuLight(size: 36)
        weatherDescribLabel.text = ""
    }
    
    
    private func setupLocationPositionLabel() {
        view.addSubview(locationPositionLabel)
        locationPositionLabel.addConstraints(to_view: view, [
            .top(anchor: view.topAnchor, constant: Constants.topIndentLocationPositionLabeLabel),
            .bottom(anchor: view.bottomAnchor, constant: Constants.bottomIndentLocationPositionLabel),
            .centerX(anchor: view.centerXAnchor)])
        
        locationPositionLabel.textColor = UIColor.normalBlackTextColor
        locationPositionLabel.font = R.font.ubuntuMedium(size: 17)
        locationPositionLabel.text = ""
    }
    
    private func setupVisualWeatherDisplayBrick() {
        let contentView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.widthVisualWeatherDisplayBrickView, height: Constants.heighVisualWeatherDisplayBrickView))
        
        let imageView = UIImageView(image: imageBrick)
        imageView.frame = contentView.bounds
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
        contentView.addSubview(imageView)
        
        view.addSubview(visualWeatherDisplayBrickView)
        visualWeatherDisplayBrickView.addConstraints(to_view: view, [
            .top(anchor: view.topAnchor),
            .centerX(anchor: view.centerXAnchor),
            .width(constant: Constants.widthVisualWeatherDisplayBrickView),
            .height(constant: Constants.heighVisualWeatherDisplayBrickView)])
        
        visualWeatherDisplayBrickView.addSubview(contentView)
        visualWeatherDisplayBrickView.backgroundColor = .clear
    }
    
    private func setupWindVisualWeatherDisplayBrick() {
        let customView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.widthVisualWeatherDisplayBrickView, height: Constants.heighVisualWeatherDisplayBrickView))
        
        let imageView = UIImageView(image: imageBrick)
        imageView.frame = customView.bounds
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
        customView.addSubview(imageView)
        visualWeatherDisplayBrickView = customView
        
        let angleInDegrees: CGFloat = Constants.angleInDegreesForWindImitate
        let angleInRadians = angleInDegrees * .pi / Constants.openCorner
        visualWeatherDisplayBrickView.layer.anchorPoint = CGPoint(x: Constants.anchorPointX, y: Constants.anchorPointY)
        
        visualWeatherDisplayBrickView.frame.origin.y = Constants.positionYForWindView
        visualWeatherDisplayBrickView.center.x = view.center.x
        
        UIView.animate(withDuration: Constants.animateDurationOneSec, animations: {
                self.visualWeatherDisplayBrickView.transform = CGAffineTransform(rotationAngle: angleInRadians)
            }, completion: { _ in
                self.animateRotation()
            })
        
        view.addSubview(visualWeatherDisplayBrickView)
    }
    
    private func setupInfoView() {
        
        let contentView = UIView(frame: CGRect(x: .zero, y: .zero, width: Constants.widthInfoView, height: Constants.heighInfoView))
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = contentView.bounds
        gradientLayer.colors = [
            UIColor.infoViewFirstGradientRedColor, UIColor.infoViewSecondGradientOrangeColor
        ]
        gradientLayer.locations = [Constants.gradientLocationZero, Constants.gradientLocationOne]
        gradientLayer.startPoint = CGPoint(x: Constants.gradientXCoordinate, y: Constants.gradientYBeginCoordinate)
        gradientLayer.endPoint = CGPoint(x: Constants.gradientXCoordinate, y: Constants.gradientYEndCoordinate)
        
        contentView.layer.insertSublayer(gradientLayer, at: Constants.contentViewLayer)
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.masksToBounds = true
        
        let label = UILabel()
        label.text = R.string.localizable.info()
        label.textColor = UIColor.normalBlackTextColor
        label.textAlignment = .center
        label.font = R.font.ubuntuBold(size: 18)
        
        contentView.addSubview(label)
        label.addConstraints(to_view: contentView, [
            .top(anchor: contentView.topAnchor, constant: Constants.topIndentLabelInInfoView),
            .bottom(anchor: contentView.bottomAnchor, constant: Constants.bottomIndentLabelInInfoView),
            .centerX(anchor: contentView.centerXAnchor)])
        
        view.addSubview(infoView)
        infoView.addConstraints(to_view: view, [
            .centerX(anchor: view.centerXAnchor),
            .bottom(anchor: view.bottomAnchor, constant: Constants.bottomIndentInfoView),
            .height(constant: Constants.heighInfoView),
            .width(constant: Constants.widthInfoView)])
        infoView.addSubview(contentView)
        
        infoView.layer.shadowColor = UIColor.black.cgColor
        infoView.layer.shadowOpacity = Constants.infoViewShadowOpacity
        infoView.layer.shadowOffset = CGSize(width: Constants.infoViewShadowOffsetWidth, height: Constants.infoViewShadowOffsetHeigh)
        infoView.layer.shadowRadius = Constants.infoViewShadowRadius
        infoView.layer.cornerRadius = Constants.cornerRadius
    }
    
    private func setupTapGestureRecognizerForInfoView() {
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
    
    private func setupPullToRefresh() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        visualWeatherDisplayBrickView.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        if gesture.state == .began {
            initialYPosition = visualWeatherDisplayBrickView.frame.origin.y
        } else if gesture.state == .changed {
            if translation.y > .zero && translation.y >= Constants.ten {
                let newY = initialYPosition + min(translation.y, Constants.fifty)
                visualWeatherDisplayBrickView.frame.origin.y = newY
            }
        } else if gesture.state == .ended {
            animateViewReset()
            updateWeatherInfo(latitude: lastLatitude, longitude: lastLongitude)
        }
    }
    private func animateViewReset() {
        UIView.animate(withDuration: Constants.animateDuration) {
            self.visualWeatherDisplayBrickView.frame.origin.y = self.initialYPosition
        }
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
                print("\(Constants.dataTaskError): \(error!.localizedDescription)")
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
        
        if temperature > Constants.highTemperature {
            imageName = R.image.image_stone_cracks()!
        } else {
            switch weather {
            case Constants.clearWeatherCase, Constants.sunnyWeatherCase: imageName = R.image.image_stone_normal()!
            case Constants.rainWeatherCase, Constants.drizzleWeatherCase: imageName = R.image.image_stone_wet()!
            case Constants.snowWeatherCase: imageName = R.image.image_stone_snow()!
            case Constants.fogWeatherCase, Constants.hazeWeatherCase, Constants.mistWeatherCase: imageName = applyBlurEffect(to: R.image.image_stone_normal()!)!
            default:
                imageName = R.image.image_stone_normal()!
            }
        }
        imageBrick = imageName
        
        if windSpeed > Constants.ten {
            setupWindVisualWeatherDisplayBrick()
        } else {
            setupVisualWeatherDisplayBrick()
        }
    }
    
    private func applyBlurEffect(to image: UIImage) -> UIImage? {
        if let ciImage = CIImage(image: image) {
            let blurFilter = CIFilter(name: Constants.blurFilterName)
            blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
            blurFilter?.setValue(Constants.blurEffectValue, forKey: kCIInputRadiusKey)
            
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
        let angleInDegrees: CGFloat = Constants.angleInDegreesForWindImitateBack
        let angleInRadians = angleInDegrees * .pi / Constants.openCorner

        UIView.animate(withDuration: Constants.animateDurationTwoSec, animations: {
            self.visualWeatherDisplayBrickView.transform = CGAffineTransform(rotationAngle: angleInRadians)
        }, completion: { _ in
            self.animateRotation()
        })
    }
    
    private func animateRotation() {
        let angleInDegrees: CGFloat = Constants.angleInDegreesForWindImitate
        let angleInRadians = angleInDegrees * .pi / Constants.openCorner

        UIView.animate(withDuration: Constants.animateDurationTwoSec, animations: {
            self.visualWeatherDisplayBrickView.transform = CGAffineTransform(rotationAngle: angleInRadians)
        }, completion: { _ in
            self.animateBackRotation()
        })
    }
}

//MARK: - extension to action after user's location getting
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
            
            lastLatitude = lastLocation.coordinate.latitude
            lastLongitude = lastLocation.coordinate.longitude
        }
    }
}

//MARK: - Constants
extension MainViewController {
    private enum Constants {
        static let blurFilterName: String = "CIGaussianBlur"
        static let dataTaskError: String = "DataTask error"
        static let clearWeatherCase: String = "Clear"
        static let sunnyWeatherCase: String = "Sunny"
        static let rainWeatherCase: String = "Rain"
        static let drizzleWeatherCase: String = "Drizzle"
        static let snowWeatherCase: String = "Snow"
        static let fogWeatherCase: String = "Fog"
        static let hazeWeatherCase: String = "Haze"
        static let mistWeatherCase: String = "Mist"
        
        static let iconSize: CGFloat = 16
        
        static let leadingIndent: CGFloat = 16
        static let topIndentTemperatureLabel: CGFloat = 461
        static let bottomIndentTemperatureLabel: CGFloat = 224
        static let topIndentWeatherConditionLabel: CGFloat = 558
        static let bottomIndentWeatherConditionLabel: CGFloat = 195
        static let topIndentLocationPositionLabeLabel: CGFloat = 699
        static let bottomIndentLocationPositionLabel: CGFloat = 90
        static let topIndentLabelInInfoView: CGFloat = 16
        static let bottomIndentLabelInInfoView: CGFloat = 47
        static let bottomIndentInfoView: CGFloat = -22
        
        static let ten: CGFloat = 10
        static let fifty: CGFloat = 50
        static let widthVisualWeatherDisplayBrickView: CGFloat = 224
        static let heighVisualWeatherDisplayBrickView: CGFloat = 455
        static let widthInfoView: CGFloat = 175
        static let heighInfoView: CGFloat = 85
        
        static let angleInDegreesForWindImitate: CGFloat = 15.0
        static let angleInDegreesForWindImitateBack: CGFloat = -15.0
        static let openCorner: CGFloat = 180
        static let anchorPointX: CGFloat = 0.5
        static let anchorPointY: CGFloat = 0
        static let positionYForWindView: CGFloat = -8
        static let gradientXCoordinate: CGFloat = 0.3
        static let gradientYBeginCoordinate: CGFloat = 0
        static let gradientYEndCoordinate: CGFloat = 0.8
        static let infoViewShadowOpacity: Float = 0.5
        static let infoViewShadowOffsetWidth: CGFloat = 2
        static let infoViewShadowOffsetHeigh: CGFloat = 4
        static let infoViewShadowRadius: CGFloat = 4
        
        static let gradientLocationZero: NSNumber = 0
        static let gradientLocationOne: NSNumber = 1
        static let contentViewLayer: UInt32 = 0

        static let animateDurationOneSec: TimeInterval = 1
        static let animateDurationTwoSec: TimeInterval = 2
        static let animateDuration: TimeInterval = 0.3
        
        static let highTemperature: Int = 30
        static let blurEffectValue: CGFloat = 5.0
        
        static let cornerRadius: CGFloat = 15
    }
}
