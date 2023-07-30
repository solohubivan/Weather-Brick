//
//  MainViewControllerPresenter.swift
//  Weather Brick
//
//  Created by Ivan Solohub on 24.07.2023.
//

import Foundation
import UIKit

protocol MainVCPresenterProtocol: AnyObject {
    func createTextForLocationPosition(with weatherData: WeatherData) -> String
}


class MainViewControllerPresenter: MainVCPresenterProtocol {
    func createTextForLocationPosition(with weatherData: WeatherData) -> String {

        return " \(weatherData.name), \(weatherData.sys.country) "
    }
}
