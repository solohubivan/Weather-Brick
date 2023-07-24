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
    
    @IBOutlet weak var bricksImageView: UIImageView!
    private var imageBrick = UIImage()

    private var weatherData = WeatherData()
    private var locationManager = CLLocationManager()

    private var initialYPosition: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        startLocationManager()
    }
    
    // MARK: - UI setup
    
    private func setupUI() {
        visualWeatherDisplayBrickView.isHidden = true
        setupInfoView()
        setupTemperatureLabel()
        setupWeatherConditionLabel()
        setupLocationPositionLabel()
        setupTapGestureRecognizerForInfoView()
        setupPullToRefresh()
    }
    
    private func setupTemperatureLabel() {
        temperatureLabel.textColor = UIColor.normalBlackTextColor
        temperatureLabel.font = R.font.ubuntuRegular(size: 83)
        temperatureLabel.text = ""
    }
    
    private func setupWeatherConditionLabel() {
        weatherDescribLabel.textColor = UIColor.normalBlackTextColor
        weatherDescribLabel.font = R.font.ubuntuLight(size: 36)
        weatherDescribLabel.text = ""
    }
    
    
    private func setupLocationPositionLabel() {
        locationPositionLabel.textColor = UIColor.normalBlackTextColor
        locationPositionLabel.font = R.font.ubuntuMedium(size: 17)
        locationPositionLabel.text = ""
    }
    
    private func setupVisualWeatherDisplayBrick() {
        visualWeatherDisplayBrickView.isHidden = false
        visualWeatherDisplayBrickView.backgroundColor = .clear
        setupBricksImageView(image: imageBrick)
    }
    
    private func setupBricksImageView(image: UIImage) {
        bricksImageView.image = image
        bricksImageView.frame = visualWeatherDisplayBrickView.bounds
        bricksImageView.contentMode = .scaleToFill
        bricksImageView.clipsToBounds = true
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
                self.animateBrickRotation()
            })
        
        view.addSubview(visualWeatherDisplayBrickView)
    }
    
    private func setupInfoView() {
        
        let contentView = UIView(frame: CGRect(x: .zero, y: .zero, width: infoView.bounds.width, height: infoView.bounds.height))
        
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

        infoView.addSubview(contentView)

        infoView.layer.shadowColor = UIColor.black.cgColor
        infoView.layer.shadowOpacity = Constants.infoViewShadowOpacity
        infoView.layer.shadowOffset = CGSize(width: Constants.infoViewShadowOffsetWidth, height: Constants.infoViewShadowOffsetHeigh)
        infoView.layer.shadowRadius = Constants.infoViewShadowRadius
        infoView.layer.cornerRadius = Constants.cornerRadius
    }
    
    private func setupTapGestureRecognizerForInfoView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openInfoPageVC))
        infoView.addGestureRecognizer(tapGesture)
    }
    
    @objc func openInfoPageVC(_ gesture: UITapGestureRecognizer) {
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
            
            let mainVC = MainViewController()
            mainVC.modalPresentationStyle = .fullScreen
            present(mainVC, animated: false)
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
                print(error!.localizedDescription)
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
            case R.string.localizable.clear(), R.string.localizable.sunny(): imageName = R.image.image_stone_normal()!
            case R.string.localizable.rain(), R.string.localizable.drizzle(): imageName = R.image.image_stone_wet()!
            case R.string.localizable.snow(): imageName = R.image.image_stone_snow()!
            case R.string.localizable.fog(), R.string.localizable.haze(), R.string.localizable.mist(): imageName = applyBlurEffect(to: R.image.image_stone_normal()!)!
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
    
    private func animateBricksBackRotation() {
        let angleInDegrees: CGFloat = Constants.angleInDegreesForWindImitateBack
        let angleInRadians = angleInDegrees * .pi / Constants.openCorner

        UIView.animate(withDuration: Constants.animateDurationTwoSec, animations: {
            self.visualWeatherDisplayBrickView.transform = CGAffineTransform(rotationAngle: angleInRadians)
        }, completion: { _ in
            self.animateBrickRotation()
        })
    }
    
    private func animateBrickRotation() {
        let angleInDegrees: CGFloat = Constants.angleInDegreesForWindImitate
        let angleInRadians = angleInDegrees * .pi / Constants.openCorner

        UIView.animate(withDuration: Constants.animateDurationTwoSec, animations: {
            self.visualWeatherDisplayBrickView.transform = CGAffineTransform(rotationAngle: angleInRadians)
        }, completion: { _ in
            self.animateBricksBackRotation()
        })
    }
}

//MARK: - extension to action after user's location getting
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
        static let blurFilterName: String = "CIGaussianBlur"

        static let iconSize: CGFloat = 16
        
        static let topIndentLabelInInfoView: CGFloat = 16
        static let bottomIndentLabelInInfoView: CGFloat = 47
        
        static let ten: CGFloat = 10
        static let fifty: CGFloat = 50
        static let widthVisualWeatherDisplayBrickView: CGFloat = 224
        static let heighVisualWeatherDisplayBrickView: CGFloat = 455
        
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
