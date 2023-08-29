//
//  WindTableViewCell.swift
//  Weather Brick
//
//  Created by Ivan Solohub on 27.08.2023.
//

import UIKit

class WindTableViewCell: UITableViewCell {
    
    @IBOutlet weak var visualWeatherDisplayBrickView: UIView!
    @IBOutlet weak var windBrickStateImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupWindVisualWeatherDisplayBrick()
    }
    
    private func setupWindVisualWeatherDisplayBrick() {
        let angleInDegrees: CGFloat = Constants.angleWindImitate
        let angleInRadians = angleInDegrees * .pi / Constants.openCorner

        visualWeatherDisplayBrickView.layer.anchorPoint = CGPoint(x: Constants.anchorPointX, y: .zero)
        
        let yOffset = Constants.yOffsetValue

        visualWeatherDisplayBrickView.transform = CGAffineTransform(translationX: .zero, y: CGFloat(yOffset)).rotated(by: -angleInRadians)
        
        UIView.animate(withDuration: Constants.animateDurationTwoSec, delay: .zero, options: [.curveEaseInOut, .autoreverse, .repeat, .allowUserInteraction], animations: {
            self.visualWeatherDisplayBrickView.transform = CGAffineTransform(translationX: .zero, y: CGFloat(yOffset)).rotated(by: angleInRadians)
        }, completion: nil)
    }
     
}

extension WindTableViewCell {
    private enum Constants {
        static let angleWindImitate: CGFloat = 15.0
        static let angleWindImitateBack: CGFloat = -15.0
        static let openCorner: CGFloat = 180
        static let anchorPointX: CGFloat = 0.5
        static let animateDurationOneSec: TimeInterval = 1
        static let animateDurationTwoSec: TimeInterval = 2
        static let animateDuration: TimeInterval = 0.3
        static let yOffsetValue: Int = -230
    }
}
