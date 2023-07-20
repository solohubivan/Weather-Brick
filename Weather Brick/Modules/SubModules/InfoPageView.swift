//
//  InfoPageView.swift
//  Weather Brick
//
//  Created by Ivan Solohub on 15.07.2023.
//

import UIKit

class InfoPageView: UIViewController {
    
    @IBOutlet weak var brickConditionsDescribtionView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var backToMainVCView: UIView!
    
    private var contentView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()
        setupUI()
    }
    
    //MARK: - Private methods
    private func setupUI() {
        setupDescribtionView()
        setupTitleLabel()
        setupBackToMainVCView()
        setupTapGestureRecognizer()
        setupConditionInfo()
    }
    
    private func setupBackground() {
        view.backgroundColor = .white
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = R.image.image_background()
        view.addSubview(backgroundImageView)
    }
    
    private func setupDescribtionView() {
        contentView = UIView(frame: CGRect(x: Constants.zero, y: Constants.zero, width: Constants.widthContentView, height: Constants.heighView))
        contentView.backgroundColor = UIColor.describtionViewBackgroundColor
        contentView.layer.cornerRadius = Constants.cornerRadius
        
        let orangeShadowPath = UIBezierPath(roundedRect: contentView.bounds.insetBy(dx: Constants.dx, dy: Constants.zero), cornerRadius: contentView.layer.cornerRadius)
        contentView.layer.shadowColor = UIColor.describtionViewShadowColor
        contentView.layer.shadowOffset = CGSize(width: Constants.contentViewShadowOffsetWidth, height: Constants.zero)
        contentView.layer.shadowOpacity = Constants.contentViewShadowOpacity
        contentView.layer.shadowRadius = Constants.contentViewShadowRadius
        contentView.layer.shadowPath = orangeShadowPath.cgPath
        
        view.addSubview(brickConditionsDescribtionView)
        brickConditionsDescribtionView.addConstraints(to_view: view, [
            .top(anchor: view.topAnchor, constant: Constants.topIdentBrickConditionsDescribtionView),
            .centerX(anchor: view.centerXAnchor),
            .height(constant: Constants.heighView),
            .width(constant: Constants.widthConditionsDescribtionView)])
        brickConditionsDescribtionView.addSubview(contentView)

        brickConditionsDescribtionView.layer.cornerRadius = Constants.cornerRadius
        
        brickConditionsDescribtionView.layer.shadowOffset = CGSize(width: Constants.zero, height: Constants.brickConditionsDescribtionViewShadowOffsetHeigh)
        brickConditionsDescribtionView.layer.shadowOpacity = Constants.brickConditionsDescribtionViewShadowOpacity
        brickConditionsDescribtionView.layer.shadowRadius = Constants.brickConditionsDescribtionViewShadowRadius
    }
    
    private func setupTitleLabel() {
        view.addSubview(mainTitleLabel)
        mainTitleLabel.addConstraints(to_view: contentView, [
            .top(anchor: contentView.topAnchor, constant: Constants.topIdent),
            .centerX(anchor: contentView.centerXAnchor),
            .height(constant: Constants.heighTitleLabel)])
        
        mainTitleLabel.text = R.string.localizable.info()
        mainTitleLabel.font = R.font.ubuntuBold(size: 18)
        mainTitleLabel.textColor = UIColor.normalTextColor
    }
    
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
    
    private func setupInfoLabels(label: UILabel) {
        label.font = R.font.ubuntuRegular(size: 15)
        label.textColor = UIColor.normalTextColor
    }
    
    private func setupBackToMainVCView() {
        view.addSubview(backToMainVCView)
        backToMainVCView.addConstraints(to_view: contentView, [
            .bottom(anchor: contentView.bottomAnchor, constant: Constants.bottomIndentBackToMainVCView),
            .height(constant: Constants.heightBackToMainVCView),
            .width(constant: Constants.widthBackToMainVCView),
            .centerX(anchor: contentView.centerXAnchor)])
        backToMainVCView.layer.borderWidth = Constants.borderWidth
        backToMainVCView.layer.borderColor = UIColor.backToMainVCLabelBorderColor
        backToMainVCView.layer.cornerRadius = Constants.cornerRadius
        backToMainVCView.backgroundColor = .clear
        
        let label = UILabel()
        label.text = R.string.localizable.hide()
        label.textColor = UIColor.backToMainVCLabelTextColor
        label.font = R.font.ubuntuMedium(size: 15)
        label.textAlignment = .center
        
        backToMainVCView.addSubview(label)
        label.addConstraints(to_view: backToMainVCView)
    }
    
    private func setupTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        backToMainVCView.addGestureRecognizer(tapGesture)
    }
    
    @objc func userTapped(_ gesture: UITapGestureRecognizer) {
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
        
        static let zero: CGFloat = 0
        static let dx: CGFloat = -5
        
        static let contentViewShadowOffsetWidth: CGFloat = 4
        static let contentViewShadowOpacity: Float = 1
        static let contentViewShadowRadius: CGFloat = 1
        static let brickConditionsDescribtionViewShadowOffsetHeigh: CGFloat = 5
        static let brickConditionsDescribtionViewShadowOpacity: Float = 0.3
        static let brickConditionsDescribtionViewShadowRadius: CGFloat = 2
        
        static let widthContentView: CGFloat = 265
        static let widthConditionsDescribtionView: CGFloat = 269
        static let heighView: CGFloat = 372
        
        static let topIdentBrickConditionsDescribtionView: CGFloat = 220
        static let topIdent: CGFloat = 24
        static let heighTitleLabel: CGFloat = 22
        static let heighInfoLabel: CGFloat = 30
        static let leadingIndent: CGFloat = 30
        
        static let bottomIndentBackToMainVCView: CGFloat = 24
        static let heightBackToMainVCView: CGFloat = 31
        static let widthBackToMainVCView: CGFloat = 115
        
        static let borderWidth: CGFloat = 1
    }
}
