//
//  InfoPageView.swift
//  Weather Brick
//
//  Created by Ivan Solohub on 15.07.2023.
//

import UIKit

class InfoPageView: UIViewController {
    
    @IBOutlet weak private var brickConditionsDescribView: UIView!
    @IBOutlet weak private var infoLabelsFrameView: UIView!
    @IBOutlet weak private var backToMainVCView: UIView!
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var mainTitleLabel: UILabel!
    
    private let infoLabelsTexts = [
        R.string.localizable.brick_is_wet_raining(),
        R.string.localizable.brick_is_dry_sunny(),
        R.string.localizable.brick_is_hard_to_see_fog(),
        R.string.localizable.brick_with_cracks_very_hot(),
        R.string.localizable.brick_with_snow_snow(),
        R.string.localizable.brick_is_swinging_windy(),
        R.string.localizable.brick_is_gone_no_internet()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    //MARK: - Private methods
    private func setupUI() {
        setupBrickConditionDescribView()
        setupTitleLabel()
        setupBackToMainVCView()
        setupTapGestureForBackToMainView()
        setupConditionInfo()
    }

    private func setupBrickConditionDescribView() {
        setupContentView()

        brickConditionsDescribView.applyShadow(opacity: Constants.describtionViewShadowOpacity, offset: CGSize(width: .zero, height: Constants.describtionViewShadowOffsetHeigh), radius: Constants.describtionViewShadowRadius, cornerRadius: Constants.cornerRadius)
        
        brickConditionsDescribView.layer.cornerRadius = Constants.cornerRadius
    }
    
    private func setupContentView() {
        contentView.backgroundColor = UIColor.describtionViewOrangeBackgroundColor
        contentView.layer.cornerRadius = Constants.cornerRadius
        
        contentView.applyShadow(color: UIColor.describtionViewOrangeShadowColor, opacity: Constants.contentViewShadowOpacity, offset: CGSize(width: Constants.contentViewShadowOffsetWidth, height: .zero), radius: Constants.contentViewShadowRadius, cornerRadius: Constants.cornerRadius)
    }
  
    private func setupTitleLabel() {
        mainTitleLabel.text = R.string.localizable.info()
        mainTitleLabel.font = R.font.ubuntuBold(size: 18)
        mainTitleLabel.textColor = UIColor.normalBlackTextColor
    }
  
    private func setupConditionInfo() {
        infoLabelsFrameView.backgroundColor = .clear
        
        for (index, text) in infoLabelsTexts.enumerated() {
            let labelFrame = CGRect(x: .zero, y: CGFloat(index) * Constants.heighInfoLabel, width: infoLabelsFrameView.bounds.width, height: Constants.heighInfoLabel)
            let label = UILabel(frame: labelFrame)
            label.text = text
            label.textAlignment = .left
            label.font = R.font.ubuntuRegular(size: 15)
            label.textColor = UIColor.normalBlackTextColor
            
            infoLabelsFrameView.addSubview(label)
        }
    }
         
    private func setupBackToMainVCView() {
        backToMainVCView.layer.borderWidth = Constants.borderWidth
        backToMainVCView.layer.borderColor = UIColor.backToMainVCViewGreyColor.cgColor
        backToMainVCView.layer.cornerRadius = Constants.cornerRadius
        backToMainVCView.backgroundColor = .clear
        
        let labelInside = UILabel()
        labelInside.text = R.string.localizable.hide()
        labelInside.textColor = UIColor.backToMainVCViewGreyColor
        labelInside.font = R.font.ubuntuMedium(size: 15)
        labelInside.textAlignment = .center
        
        backToMainVCView.addSubview(labelInside)
        labelInside.addConstraints(to_view: backToMainVCView)
    }
    
    private func setupTapGestureForBackToMainView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openMainVC))
        backToMainVCView.addGestureRecognizer(tapGesture)
    }
    
    @objc func openMainVC(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            let mainVC = MainViewController()
            mainVC.modalPresentationStyle = .fullScreen
            present(mainVC, animated: false)
        }
    }
}

//MARK: - Constants
extension InfoPageView {
    private enum Constants {
        static let cornerRadius: CGFloat = 15
        static let heighInfoLabel: CGFloat = 30
        static let borderWidth: CGFloat = 1

        static let contentViewShadowOffsetWidth: CGFloat = 8
        static let contentViewShadowOpacity: Float = 1
        static let contentViewShadowRadius: CGFloat = 1
        static let describtionViewShadowOffsetHeigh: CGFloat = 5
        static let describtionViewShadowOpacity: Float = 0.3
        static let describtionViewShadowRadius: CGFloat = 2
    }
}
