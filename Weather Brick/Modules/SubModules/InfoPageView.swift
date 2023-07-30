//
//  InfoPageView.swift
//  Weather Brick
//
//  Created by Ivan Solohub on 15.07.2023.
//

import UIKit

class InfoPageView: UIViewController {
    
    @IBOutlet weak private var brickConditionsDescribView: UIView!
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var mainTitleLabel: UILabel!
    @IBOutlet weak private var returnMainVCButton: UIButton!
    @IBOutlet weak private var infoLabelsStackView: UIStackView!
 
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
        setupContentView()
        
        brickConditionsDescribView.backgroundColor = .clear
        brickConditionsDescribView.layer.cornerRadius = Constants.cornerRadius

        brickConditionsDescribView.applyShadow(opacity: Constants.describtionViewShadowOpacity, offset: CGSize(width: .zero, height: Constants.describtionViewShadowOffsetHeigh), radius: Constants.describtionViewShadowRadius, cornerRadius: Constants.cornerRadius)
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
    
    private func setupInfoLabelsStackView() {
        infoLabelsStackView.backgroundColor = .clear
        infoLabelsStackView.spacing = Constants.spaceBetweenInfoLabels
    
       for i in infoLabelsTexts {
            let label = UILabel()
            label.text = i
            label.font = R.font.ubuntuRegular(size: 15)
            label.textColor = UIColor.normalBlackTextColor
         infoLabelsStackView.addArrangedSubview(label)
        }
    }

    private func setupReturnToMainVCButton() {
        returnMainVCButton.backgroundColor = .clear
        returnMainVCButton.layer.borderWidth = Constants.borderWidth
        returnMainVCButton.layer.borderColor = UIColor.returnToMainVCButtonGreyColor.cgColor
        returnMainVCButton.layer.cornerRadius = Constants.cornerRadius
        
        
        returnMainVCButton.setTitle(R.string.localizable.hide(), for: .normal)
        returnMainVCButton.setTitleColor(UIColor.returnToMainVCButtonGreyColor, for: .normal)
        returnMainVCButton.titleLabel?.font = R.font.ubuntuMedium(size: 15)
    }
    
    @IBAction func openMainVC(_ sender: Any) {
        let mainVC = MainViewController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: false)
    }
}

//MARK: - Constants
extension InfoPageView {
    private enum Constants {
        static let cornerRadius: CGFloat = 15
        static let borderWidth: CGFloat = 1
        static let contentViewShadowOffsetWidth: CGFloat = 8
        static let contentViewShadowOpacity: Float = 1
        static let contentViewShadowRadius: CGFloat = 1
        static let describtionViewShadowOffsetHeigh: CGFloat = 5
        static let describtionViewShadowOpacity: Float = 0.3
        static let describtionViewShadowRadius: CGFloat = 2
        
        static let spaceBetweenInfoLabels: CGFloat = 15
    }
}
