//
//  InfoPageView.swift
//  Weather Brick
//
//  Created by Ivan Solohub on 15.07.2023.
//

import UIKit

class InfoPageView: UIViewController {
    
    @IBOutlet weak var brickConditionsDescribView: UIView!
    
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var backToMainVCView: UIView!
    @IBOutlet weak var contentView: UIView!
    
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
   //     setupConditionInfo()
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
  /*
    private func setupConditionInfo() {
        
        let labelInfo1 = UILabel()
        view.addSubview(labelInfo1)
        labelInfo1.addConstraints(to_view: contentView, [
            .top(anchor: mainTitleLabel.bottomAnchor, constant: Constants.topIdent),
            .leading(anchor: contentView.leadingAnchor, constant: Constants.leadingIndent),
            .height(constant: Constants.heighInfoLabel)])
        setupInfoLabels(label: labelInfo1)
        labelInfo1.text = R.string.localizable.brick_is_wet_raining()
        
        let labelInfo2 = UILabel()
        view.addSubview(labelInfo2)
        labelInfo2.addConstraints(to_view: contentView, [
            .top(anchor: labelInfo1.bottomAnchor),
            .leading(anchor: contentView.leadingAnchor, constant: Constants.leadingIndent),
            .height(constant: Constants.heighInfoLabel)])
        setupInfoLabels(label: labelInfo2)
        labelInfo2.text = R.string.localizable.brick_is_dry_sunny()
        
        let labelInfo3 = UILabel()
        view.addSubview(labelInfo3)
        labelInfo3.addConstraints(to_view: contentView, [
            .top(anchor: labelInfo2.bottomAnchor),
            .leading(anchor: contentView.leadingAnchor, constant: Constants.leadingIndent),
            .height(constant: Constants.heighInfoLabel)])
        setupInfoLabels(label: labelInfo3)
        labelInfo3.text = R.string.localizable.brick_is_hard_to_see_fog()
        
        let labelInfo4 = UILabel()
        view.addSubview(labelInfo4)
        labelInfo4.addConstraints(to_view: contentView, [
            .top(anchor: labelInfo3.bottomAnchor),
            .leading(anchor: contentView.leadingAnchor, constant: Constants.leadingIndent),
            .height(constant: Constants.heighInfoLabel)])
        setupInfoLabels(label: labelInfo4)
        labelInfo4.text = R.string.localizable.brick_with_cracks_very_hot()
        
        let labelInfo5 = UILabel()
        view.addSubview(labelInfo5)
        labelInfo5.addConstraints(to_view: contentView, [
            .top(anchor: labelInfo4.bottomAnchor),
            .leading(anchor: contentView.leadingAnchor, constant: Constants.leadingIndent),
            .height(constant: Constants.heighInfoLabel)])
        setupInfoLabels(label: labelInfo5)
        labelInfo5.text = R.string.localizable.brick_with_snow_snow()
        
        let labelInfo6 = UILabel()
        view.addSubview(labelInfo6)
        labelInfo6.addConstraints(to_view: contentView, [
            .top(anchor: labelInfo5.bottomAnchor),
            .leading(anchor: contentView.leadingAnchor, constant: Constants.leadingIndent),
            .height(constant: Constants.heighInfoLabel)])
        setupInfoLabels(label: labelInfo6)
        labelInfo6.text = R.string.localizable.brick_is_swinging_windy()
        
        let labelInfo7 = UILabel()
        view.addSubview(labelInfo7)
        labelInfo7.addConstraints(to_view: contentView, [
            .top(anchor: labelInfo6.bottomAnchor),
            .leading(anchor: contentView.leadingAnchor, constant: Constants.leadingIndent),
            .height(constant: Constants.heighInfoLabel)])
        setupInfoLabels(label: labelInfo7)
        labelInfo7.text = R.string.localizable.brick_is_gone_no_internet()
    }
    */
    private func setupInfoLabels(label: UILabel) {
        label.font = R.font.ubuntuRegular(size: 15)
        label.textColor = UIColor.normalBlackTextColor
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
        static let leadingIndent: CGFloat = 30
        
        static let borderWidth: CGFloat = 1
    }
}
