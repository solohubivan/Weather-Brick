//
//  InfoPageViewController.swift
//  Weather Brick
//
//  Created by Ivan Solohub on 15.07.2023.
//

import UIKit
import QuartzCore

class InfoPageViewController: UIViewController {
    
    @IBOutlet weak private var brickConditionsDescribView: UIView!
    @IBOutlet weak private var mainTitleLabel: UILabel!
    @IBOutlet weak private var returnToMainVCButton: UIButton!
    @IBOutlet weak private var infoLabelsStackView: UIStackView!
    
    private var mainVC = MainViewController()
    
    private var infoLabelsTexts = [
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
        setupInfoLabelsStackView()
        setupReturnToMainVCButton()
    }
    
    private func setupBrickConditionDescribView() {
        brickConditionsDescribView.layer.cornerRadius = Constants.cornerRadius
        brickConditionsDescribView.backgroundColor = .white
        
        brickConditionsDescribView.applyShadow(opacity: Constants.describtionViewShadowOpacity, offset: CGSize(width: .zero, height: Constants.describtionViewShadowOffsetHeigh), radius: Constants.describtionViewShadowRadius, cornerRadius: Constants.cornerRadius)
    }
    
    private func setupSublayerToDescribeView() {
        let orangeShadow = CALayer()
        orangeShadow.backgroundColor = UIColor.fF9960.cgColor
        orangeShadow.frame = brickConditionsDescribView.bounds
        brickConditionsDescribView.layer.insertSublayer(orangeShadow, at: .zero)
        
        orangeShadow.applyLayerShadow(color: UIColor.fB5F29, opacity: Constants.orangeShadowOpacity, offset: CGSize(width: Constants.orangeShadowOffsetWidth, height: .zero), radius: Constants.orangeShadowRadius, cornerRadius: Constants.cornerRadius)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupSublayerToDescribeView()
    }

    private func setupTitleLabel() {
        mainTitleLabel.text = R.string.localizable.info()
        mainTitleLabel.font = R.font.ubuntuBold(size: 18)
        mainTitleLabel.textColor = UIColor.nightRider2D2D2D
    }
    
    private func setupInfoLabelsStackView() {
        infoLabelsStackView.backgroundColor = .clear
        infoLabelsStackView.spacing = Constants.spaceBetweenInfoLabels
    
       for i in infoLabelsTexts {
            let label = UILabel()
            label.text = i
            label.font = R.font.ubuntuRegular(size: 15)
            label.textColor = UIColor.nightRider2D2D2D
         infoLabelsStackView.addArrangedSubview(label)
        }
    }

    private func setupReturnToMainVCButton() {
        returnToMainVCButton.backgroundColor = .clear
        returnToMainVCButton.layer.borderWidth = Constants.borderWidth
        returnToMainVCButton.layer.borderColor = UIColor.matterhorn575757.cgColor
        returnToMainVCButton.layer.cornerRadius = Constants.cornerRadius
        
        returnToMainVCButton.setTitle(R.string.localizable.hide(), for: .normal)
        returnToMainVCButton.setTitleColor(UIColor.matterhorn575757, for: .normal)
        returnToMainVCButton.titleLabel?.font = R.font.ubuntuMedium(size: 15)
    }
    
    @IBAction func openMainVC(_ sender: Any) {
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: false)
    }
}

//MARK: - Constants
extension InfoPageViewController {
    private enum Constants {
        static let cornerRadius: CGFloat = 15
        static let borderWidth: CGFloat = 1
        static let orangeShadowOffsetWidth: CGFloat = 8
        static let orangeShadowOpacity: Float = 1
        static let orangeShadowRadius: CGFloat = 1
        static let describtionViewShadowOffsetHeigh: CGFloat = 5
        static let describtionViewShadowOpacity: Float = 0.2
        static let describtionViewShadowRadius: CGFloat = 2
        
        static let spaceBetweenInfoLabels: CGFloat = 15
    }
}
