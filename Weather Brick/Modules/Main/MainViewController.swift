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
    @IBOutlet weak private var showInfoVC: UIButton!
    @IBOutlet weak private var tableViewBrickState: UITableView!

    private var locationManager = CLLocationManager()

    private var presenter: MainVCPresenterProtocol!
    
    private var weatherData: WeatherData?
    
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
        tableViewBrickState.isHidden = true
        setupButtonShowInfoVC()
        setupTemperatureLabel()
        setupWeatherConditionLabel()
        setupLocationPositionLabel()
    }
    
    private func setupTableViewBrickState() {
        tableViewBrickState.isHidden = false
        tableViewBrickState.dataSource = self
        tableViewBrickState.delegate = self
        tableViewBrickState.backgroundColor = .clear
        tableViewBrickState.separatorColor = .clear
        tableViewBrickState.register(UINib(nibName: Constants.nibNameCustomCell, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        tableViewBrickState.refreshControl = refreshControl
    }
    
    @objc private func refreshActivated() {
        locationManager.startUpdatingLocation()
    }
    
    private func setupTemperatureLabel() {
        temperatureLabel.textColor = UIColor.nightRider2D2D2D
        temperatureLabel.font = R.font.ubuntuRegular(size: 83)
        temperatureLabel.text = ""
    }
    
    private func setupWeatherConditionLabel() {
        weatherDescribLabel.textColor = UIColor.nightRider2D2D2D
        weatherDescribLabel.font = R.font.ubuntuLight(size: 36)
        weatherDescribLabel.text = ""
    }
    
    private func setupLocationPositionLabel() {
        locationPositionLabel.textColor = UIColor.nightRider2D2D2D
        locationPositionLabel.font = R.font.ubuntuMedium(size: 17)
        locationPositionLabel.text = ""
    }

    private func setupButtonShowInfoVC() {
        showInfoVC.setTitle(R.string.localizable.info(), for: .normal)
        showInfoVC.titleLabel?.font = R.font.ubuntuBold(size: 18)
        showInfoVC.setTitleColor(UIColor.nightRider2D2D2D, for: .normal)
        
        showInfoVC.applyShadow(opacity: Constants.infoButtonShadowOpacity, offset: CGSize(width: Constants.infoButtonShadowOffsetWidth, height: Constants.infoButtonShadowOffsetHeigh), radius: Constants.infoButtonShadowRadius)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        showInfoVC.applyGradient(colors: [UIColor.fF9960, UIColor.f9501B], locations: [Constants.gradientLocationZero, Constants.gradientLocationOne], startPoint: CGPoint(x: Constants.gradientXCoordinate, y: .zero), endPoint: CGPoint(x: Constants.gradientXCoordinate, y: Constants.gradientYEndCoordinate), cornerRadius: Constants.cornerRadius, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    
    @IBAction func openInfoVC(_ sender: Any) {
        let infoPageVC = InfoPageViewController()
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
            refreshControl.endRefreshing()
            locationManager.stopUpdatingLocation()
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
        return Constants.tableParameter
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Constants.tableParameter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! CustomTableViewCell
        cell.selectionStyle = .none
        cell.weatherData = weatherData
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height
    }
}

extension MainViewController: MainViewProtocol {
    func updateUI(with weatherData: WeatherData) {
        
        self.weatherData = weatherData
        
        let temperature = Int(weatherData.main.temp)
        temperatureLabel.text = "\(temperature)°"
 
        if let weather = weatherData.weather.first?.main {
            let lowercaseWeather = weather.lowercased()
            weatherDescribLabel.text = "\(lowercaseWeather)"
        }
        
        setupTableViewBrickState()

        locationPositionLabel.attributedText = createStringForLocationPosition(iconSize: CGSize(width: Constants.iconSize, height: Constants.iconSize))
    }
}

//MARK: - Constants
extension MainViewController {
    private enum Constants {
        static let cellIdentifier: String = "CustomCell"
        static let nibNameCustomCell: String = "CustomTableViewCell"

        static let iconSize: CGFloat = 16
        static let cornerRadius: CGFloat = 15
        
        static let tableParameter: Int = 1

        static let gradientXCoordinate: CGFloat = 0.3
        static let gradientYEndCoordinate: CGFloat = 0.8
        static let gradientLocationZero: NSNumber = 0
        static let gradientLocationOne: NSNumber = 1
        
        static let infoButtonShadowOpacity: Float = 0.5
        static let infoButtonShadowOffsetWidth: CGFloat = 3
        static let infoButtonShadowOffsetHeigh: CGFloat = 4
        static let infoButtonShadowRadius: CGFloat = 4
    }
}
