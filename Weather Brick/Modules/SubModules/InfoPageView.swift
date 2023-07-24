//
//  InfoPageView.swift
//  Weather Brick
//
//  Created by Ivan Solohub on 15.07.2023.
//

import UIKit

class InfoPageView: UIViewController {
    
    @IBOutlet weak var brickConditionsDescribView: UIView!
    @IBOutlet weak var infoLabelsFrameView: UIView!
    @IBOutlet weak var backToMainVCView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    
    let infoLabelsTexts = [
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
        
        brickConditionsDescribView.layer.cornerRadius = Constants.cornerRadius
        
        brickConditionsDescribView.layer.shadowOffset = CGSize(width: .zero, height: Constants.describtionViewShadowOffsetHeigh)
        brickConditionsDescribView.layer.shadowOpacity = Constants.describtionViewShadowOpacity
        brickConditionsDescribView.layer.shadowRadius = Constants.describtionViewShadowRadius
    }
    
    private func setupContentView() {
        contentView.backgroundColor = UIColor.describtionViewOrangeBackgroundColor
        contentView.layer.cornerRadius = Constants.cornerRadius
        
        let orangeShadowPath = UIBezierPath(roundedRect: contentView.bounds.insetBy(dx: Constants.dx, dy: .zero), cornerRadius: contentView.layer.cornerRadius)
        contentView.layer.shadowColor = UIColor.describtionViewOrangeShadowColor
        contentView.layer.shadowOffset = CGSize(width: Constants.contentViewShadowOffsetWidth, height: .zero)
        contentView.layer.shadowOpacity = Constants.contentViewShadowOpacity
        contentView.layer.shadowRadius = Constants.contentViewShadowRadius
        contentView.layer.shadowPath = orangeShadowPath.cgPath
    }
  
    private func setupTitleLabel() {
        mainTitleLabel.text = R.string.localizable.info()
        mainTitleLabel.font = R.font.ubuntuBold(size: 18)
        mainTitleLabel.textColor = UIColor.normalBlackTextColor
    }
  
    private func setupConditionInfo() {
        infoLabelsFrameView.backgroundColor = .clear
        
        for (index, text) in infoLabelsTexts.enumerated() {
            let labelFrame = CGRect(x: 0, y: CGFloat(index) * Constants.heighInfoLabel, width: infoLabelsFrameView.bounds.width, height: Constants.heighInfoLabel)
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

        static let dx: CGFloat = -5
        
        static let contentViewShadowOffsetWidth: CGFloat = 4
        static let contentViewShadowOpacity: Float = 1
        static let contentViewShadowRadius: CGFloat = 1
        static let describtionViewShadowOffsetHeigh: CGFloat = 5
        static let describtionViewShadowOpacity: Float = 0.3
        static let describtionViewShadowRadius: CGFloat = 2

        static let heighInfoLabel: CGFloat = 30
        
        static let borderWidth: CGFloat = 1
    }
}
