//
//  CustomTableViewCell.swift
//  Weather Brick
//
//  Created by Ivan Solohub on 27.08.2023.
//

import UIKit

struct BrickCellViewModel {
    let weather: String
    let temperature: Int
    let windSpeed: Double
}

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var visualWeatherDisplayBrickView: UIView!
    @IBOutlet weak var windBrickStateImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    public func updateBrickStateImage(with viewModel: BrickCellViewModel) {
        var imageName = UIImage()
        
        if viewModel.temperature > Constants.highTemperature {
            imageName = R.image.image_stone_cracks()!
        } else {
            if let weatherType = WeatherType(rawValue: viewModel.weather) {
                switch weatherType {
                case .clear, .sunny: imageName = R.image.image_stone_normal()!
                case .rain, .drizzle: imageName = R.image.image_stone_wet()!
                case .snow: imageName = R.image.image_stone_snow()!
                case .fog, .haze, .mist: imageName = applyBlurEffect(to: R.image.image_stone_normal()!, blurEffect: Constants.blurEffectValue)!
                }
            } else {
                imageName = R.image.image_stone_normal()!
            }
        }
        windBrickStateImageView.image = imageName
        
        if viewModel.windSpeed > Constants.highWind {
            setupWindVisualWeatherDisplayBrick()
        }
    }
        
    
    private func applyBlurEffect(to image: UIImage, blurEffect: CGFloat) -> UIImage? {
        if let ciImage = CIImage(image: image) {
            let blurFilter = CIFilter(name: Constants.blurFilterName)
            blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
            blurFilter?.setValue(blurEffect, forKey: kCIInputRadiusKey)
            
            if let outputCIImage = blurFilter?.outputImage {
                let context = CIContext(options: [CIContextOption.useSoftwareRenderer: false])
                if let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) {
                    let blurredImage = UIImage(cgImage: outputCGImage, scale: image.scale, orientation: image.imageOrientation)
                    return blurredImage
                }
            }
        }
        return nil
    }
    
    private func setupWindVisualWeatherDisplayBrick() {
        let angleInRadians = Constants.angleWindImitate * .pi / Constants.openCorner

        visualWeatherDisplayBrickView.layer.anchorPoint = CGPoint(x: Constants.anchorPointX, y: .zero)

        visualWeatherDisplayBrickView.transform = CGAffineTransform(translationX: .zero, y: Constants.yOffset).rotated(by: -angleInRadians)
        
        UIView.animate(withDuration: Constants.animateDurationTwoSec, delay: .zero, options: [.curveEaseInOut, .autoreverse, .repeat, .allowUserInteraction], animations: {
            self.visualWeatherDisplayBrickView.transform = CGAffineTransform(translationX: .zero, y: Constants.yOffset).rotated(by: angleInRadians)
        }, completion: nil)
    }
}

extension CustomTableViewCell {
    private enum Constants {
        static let angleWindImitate: CGFloat = 15.0
        static let openCorner: CGFloat = 180
        static let anchorPointX: CGFloat = 0.5
        static let animateDurationTwoSec: TimeInterval = 2
        
        static let blurEffectValue: CGFloat = 5.0
        static let blurFilterName: String = "CIGaussianBlur"
        
        static let highTemperature: Int = 30
        static let highWind: CGFloat = 10
        
        static let yOffset: CGFloat = -230
    }

    private enum WeatherType: String {
        case clear = "Clear"
        case sunny = "Sunny"
        case rain = "Rain"
        case drizzle = "Drizzle"
        case snow = "Snow"
        case fog = "Fog"
        case haze = "Haze"
        case mist = "Mist"
    }

}
