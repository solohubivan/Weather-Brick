//
//  MainViewControllerPresenter.swift
//  Weather Brick
//
//  Created by Ivan Solohub on 24.07.2023.
//

import Foundation
import UIKit

protocol MainVCPresenterProtocol: AnyObject {
    func createTextForLocationPosition() -> String
    func fetchData(latitude: Double, longitude: Double)
    func getDataForCell() -> BrickCellViewModel
}


class MainViewControllerPresenter: MainVCPresenterProtocol {
   
    private var weatherData = WeatherData()
    private weak var view: MainViewProtocol?
    
    init(view: MainViewProtocol) {
        self.view = view
    }
    
    // Public Methods
    
    func getDataForCell() -> BrickCellViewModel {
        let weather = (weatherData.weather.first?.main)!
        let temperature = Int(weatherData.main.temp)
        let wind = Double(weatherData.wind.speed)
        
        return BrickCellViewModel(weather: weather, temperature: temperature, windSpeed: wind)
    }
    
    func createTextForLocationPosition() -> String {

        return " \(weatherData.name), \(weatherData.sys.country) "
    }
    
    func fetchData(latitude: Double, longitude: Double) {
        updateWeatherInfo(latitude: latitude, longitude: longitude)
    }

    // Private Methods
    
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
                    self.view?.updateUI(with: self.weatherData)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
