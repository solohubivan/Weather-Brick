//
//  CALayerExtension.swift
//  Weather Brick
//
//  Created by Ivan Solohub on 01.09.2023.
//

import UIKit

extension CALayer {
    func applyLayerShadow(color: UIColor = UIColor.black, opacity: Float = 1, offset: CGSize = CGSize(width: 2, height: 4), radius: CGFloat = 4, cornerRadius: CGFloat = 0) {
        
        self.cornerRadius = cornerRadius
        self.shadowColor = color.cgColor
        self.shadowOpacity = opacity
        self.shadowOffset = offset
        self.shadowRadius = radius
    }
}
