//
//  MainViewController.swift
//  Weather Brick
//
//  Created by Ivan Solohub on 14.07.2023.
//

import UIKit
import CoreLocation
import CoreImage

protocol MainViewProtocol: AnyObject {
    func updateUI(with weatherData: WeatherData)
}

class MainViewController: UIViewController {
    
    @IBOutlet weak private var temperatureLabel: UILabel!
    @IBOutlet weak private var weatherDescribLabel: UILabel!
    @IBOutlet weak private var locationPositionLabel: UILabel!
    @IBOutlet weak private var visualWeatherDisplayBrickView: UIView!
    @IBOutlet weak private var showInfoVC: UIButton!
    @IBOutlet weak private var tableViewBrickState: UITableView!
    
    private var imageBrick = UIImage()

    private var weatherData = WeatherData()
    private var locationManager = CLLocationManager()

    private var presenter: MainVCPresenterProtocol!
    
    private var currentLatitude: Double?
    private var currentLongitude: Double?
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshActivated), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLocationManager()
        presenter = MainViewControllerPresenter(view: self)
        setupUI()
    }
    
    // MARK: - UI setup
    
    private func setupUI() {
 //       visualWeatherDisplayBrickView.isHidden = true
        setupButtonShowInfoVC()
        setupTemperatureLabel()
        setupWeatherConditionLabel()
        setupLocationPositionLabel()
        setupTableViewBrickState()
    }
    
    private func setupTableViewBrickState() {
        tableViewBrickState.dataSource = self
        tableViewBrickState.delegate = self
        tableViewBrickState.backgroundColor = .clear
        tableViewBrickState.separatorColor = .clear
        
        tableViewBrickState.register(UINib(nibName: Constants.nibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        tableViewBrickState.refreshControl = refreshControl
    }
    
    @objc private func refreshActivated() {
        presenter.fetchData(latitude: currentLatitude!, longitude: currentLongitude!)
        refreshControl.endRefreshing()
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
    
    private func setupWindVisualWeatherDisplayBrick() {
        let customView = UIView(frame: CGRect(x: .zero, y: .zero, width: visualWeatherDisplayBrickView.bounds.width, height: visualWeatherDisplayBrickView.bounds.height))
           
        let imageView = UIImageView(image: imageBrick)
        imageView.frame = customView.bounds
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
            
        customView.addSubview(imageView)
        visualWeatherDisplayBrickView = customView
            
        let angleInDegrees: CGFloat = Constants.angleWindImitate
        let angleInRadians = angleInDegrees * .pi / Constants.openCorner
        
        visualWeatherDisplayBrickView.layer.anchorPoint = CGPoint(x: Constants.anchorPointX, y: .zero)
            
        visualWeatherDisplayBrickView.frame.origin.y = Constants.positionYForWindView
        visualWeatherDisplayBrickView.center.x = view.center.x
            
        UIView.animate(withDuration: Constants.animateDurationOneSec, animations: {
                self.visualWeatherDisplayBrickView.transform = CGAffineTransform(rotationAngle: angleInRadians)
                }, completion: { _ in
                    self.animateBrickRotation()
                })
            view.addSubview(visualWeatherDisplayBrickView)
        }
    
    private func setupButtonShowInfoVC() {
        
   //     showInfoVC.setTitle(R.string.localizable.info(), for: .normal)
   //     showInfoVC.setTitle("Solohub", for: .normal)

   //     showInfoVC.titleLabel?.font = R.font.ubuntuBold(size: 18)
  //      showInfoVC.setTitleColor(UIColor.normalBlackTextColor, for: .normal)
   //     showInfoVC.backgroundColor = .orange

    
        showInfoVC.applyGradient(colors: [UIColor.infoViewFirstGradientRedColor, UIColor.infoViewSecondGradientOrangeColor], locations: [Constants.gradientLocationZero, Constants.gradientLocationOne], startPoint: CGPoint(x: Constants.gradientXCoordinate, y: .zero), endPoint: CGPoint(x: Constants.gradientXCoordinate, y: Constants.gradientYEndCoordinate), cornerRadius: Constants.cornerRadius, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
       
        showInfoVC.setTitle("Solohub", for: .normal)
        showInfoVC.titleLabel?.font = R.font.ubuntuBold(size: 18)
        showInfoVC.setTitleColor(UIColor.normalBlackTextColor, for: .normal)
        
        showInfoVC.backgroundColor = .clear
    //    showInfoVC.insertSubview(gradientLayer, at: 0)
     /*
        showInfoVC.applyShadow(opacity: Constants.infoButtonShadowOpacity, offset: CGSize(width: Constants.infoButtonShadowOffsetWidth, height: Constants.infoButtonShadowOffsetHeigh), radius: Constants.infoButtonShadowRadius)
     */
    }
    
    @IBAction func openInfoVC(_ sender: Any) {
        let infoPageVC = InfoPageView()
        infoPageVC.modalPresentationStyle = .fullScreen
        present(infoPageVC, animated: false)
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
    
    private func createStringForLocationPosition(iconSize: CGSize) -> NSAttributedString {
        let locationIcon = NSTextAttachment(image: R.image.icon_location()!)
        locationIcon.bounds = CGRect(origin: .zero, size: iconSize)
        let searchIcon = NSTextAttachment(image: R.image.icon_search()!)
        searchIcon.bounds = CGRect(origin: .zero, size: iconSize)
        
        let resultString = NSMutableAttributedString()
        resultString.append(NSAttributedString(attachment: locationIcon))
        resultString.append(NSAttributedString(string: presenter.createTextForLocationPosition()))
        resultString.append(NSAttributedString(attachment: searchIcon))
        return resultString
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
            case R.string.localizable.fog(), R.string.localizable.haze(), R.string.localizable.mist(): imageName = applyBlurEffect(to: R.image.image_stone_normal()!, blurEffect: Constants.blurEffectValue)!
            default:
                imageName = R.image.image_stone_normal()!
            }
        }
        imageBrick = imageName
        
        if windSpeed > Constants.highWind {
            setupWindVisualWeatherDisplayBrick()
        }
    }
    
    private func applyBlurEffect(to image: UIImage, blurEffect: CGFloat) -> UIImage? {
        if let ciImage = CIImage(image: image) {
            let blurFilter = CIFilter(name: Constants.blurFilterName)
            blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
            blurFilter?.setValue(blurEffect, forKey: kCIInputRadiusKey)
            
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

    private func animateBricksBackRotation() {
        let angleInDegrees: CGFloat = Constants.angleWindImitateBack
        let angleInRadians = angleInDegrees * .pi / Constants.openCorner

        UIView.animate(withDuration: Constants.animateDurationTwoSec, animations: {
            self.visualWeatherDisplayBrickView.transform = CGAffineTransform(rotationAngle: angleInRadians)
        }, completion: { _ in
            self.animateBrickRotation()
        })
    }
    
    private func animateBrickRotation() {
        let angleInDegrees: CGFloat = Constants.angleWindImitate
        let angleInRadians = angleInDegrees * .pi / Constants.openCorner

        UIView.animate(withDuration: Constants.animateDurationTwoSec, animations: {
            self.visualWeatherDisplayBrickView.transform = CGAffineTransform(rotationAngle: angleInRadians)
        }, completion: { _ in
            self.animateBricksBackRotation()
        })
    }
    
    private func showLocationAlert() {
        let alertController = UIAlertController(title: R.string.localizable.please_allow_this_app_to_access_your_location(), message: R.string.localizable.enable_location_services_in_settings(), preferredStyle: .alert)
                
        let settingsAction = UIAlertAction(title: R.string.localizable.settings(), style: .default) { (_) in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsURL) {
                       UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }
            }
        
        alertController.addAction(settingsAction)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - Extensions

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            presenter.fetchData(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
            currentLatitude = lastLocation.coordinate.latitude
            currentLongitude = lastLocation.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .denied, .restricted:
                showLocationAlert()
            default:
                break
            }
        }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! TableViewCell
        cell.selectionStyle = .none
        updateBrickStateImage()
        cell.brickStateImageView.image = imageBrick

        return cell
    }
}

extension MainViewController: MainViewProtocol {
    func updateUI(with weatherData: WeatherData) {

        let temperature = Int(weatherData.main.temp)
        temperatureLabel.text = "\(temperature)°"
 
        if let weather = weatherData.weather.first?.main {
            let lowercaseWeather = weather.lowercased()
            weatherDescribLabel.text = "\(lowercaseWeather)"
        }
        
        updateBrickStateImage()

        locationPositionLabel.attributedText = createStringForLocationPosition(iconSize: CGSize(width: Constants.iconSize, height: Constants.iconSize))
    }
}

//MARK: - Constants
extension MainViewController {
    private enum Constants {
        static let cellIdentifier: String = "CustomCell"
        static let nibName: String = "TableViewCell"
        static let blurFilterName: String = "CIGaussianBlur"

        static let iconSize: CGFloat = 16
        static let cornerRadius: CGFloat = 15
        
        static let translationYFive: CGFloat = 5
        static let translationYEight: CGFloat = 8
        
        static let angleWindImitate: CGFloat = 15.0
        static let angleWindImitateBack: CGFloat = -15.0
        static let openCorner: CGFloat = 180
        static let anchorPointX: CGFloat = 0.5
        static let positionYForWindView: CGFloat = -8
        
        static let gradientXCoordinate: CGFloat = 0.3
        static let gradientYEndCoordinate: CGFloat = 0.8
        static let gradientLocationZero: NSNumber = 0
        static let gradientLocationOne: NSNumber = 1
        
        static let blurEffectValue: CGFloat = 5.0
        
        static let infoButtonShadowOpacity: Float = 0.5
        static let infoButtonShadowOffsetWidth: CGFloat = 3
        static let infoButtonShadowOffsetHeigh: CGFloat = 4
        static let infoButtonShadowRadius: CGFloat = 4

        static let animateDurationOneSec: TimeInterval = 1
        static let animateDurationTwoSec: TimeInterval = 2
        static let animateDuration: TimeInterval = 0.3
        
        static let highTemperature: Int = 30
        static let highWind: CGFloat = 10
    }
}
