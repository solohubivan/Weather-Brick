//
//  MainViewControllerPresenter.swift
//  Weather Brick
//
//  Created by Ivan Solohub on 24.07.2023.
//

import Foundation
import UIKit


protocol MainVCPresenterProtocol: AnyObject {
    func createFormatForLocationPositionLabel(label: UILabel, with weatherData: WeatherData)
}


class MainViewControllerPresenter: MainVCPresenterProtocol {
    
    var weatherData = WeatherData()
    
    func createFormatForLocationPositionLabel(label: UILabel, with weatherData: WeatherData) {
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
        
        label.attributedText = attributedString
    }
}

extension MainViewControllerPresenter {
    private enum Constants {
        static let iconSize: CGFloat = 16
    }
}
