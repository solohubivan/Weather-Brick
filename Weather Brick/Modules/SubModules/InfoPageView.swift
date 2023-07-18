//
//  InfoPageView.swift
//  Weather Brick
//
//  Created by Ivan Solohub on 15.07.2023.
//

import UIKit

class InfoPageView: UIViewController {
    
    private var brickConditionsDescribtionView = UIView()
    private var contentView = UIView()
    private var backToMainVCView = UIView()
    private var mainTitleLabel = UILabel()
    
    let conditionInfo1 = UILabel()
    
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
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: 265, height: 372))
        contentView.backgroundColor = UIColor(red: 1, green: 0.6, blue: 0.375, alpha: 1)
        contentView.layer.cornerRadius = 15
        
        let orangeShadowPath = UIBezierPath(roundedRect: contentView.bounds.insetBy(dx: -5, dy: 0), cornerRadius: contentView.layer.cornerRadius)
        contentView.layer.shadowColor = UIColor(red: 0.98, green: 0.37, blue: 0.16, alpha: 1).cgColor
        contentView.layer.shadowOffset = CGSize(width: 4, height: 0)
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowRadius = 1
        contentView.layer.shadowPath = orangeShadowPath.cgPath
        
        view.addSubview(brickConditionsDescribtionView)
        brickConditionsDescribtionView.addConstraints(to_view: view, [
            .top(anchor: view.topAnchor, constant: 220),
            .centerX(anchor: view.centerXAnchor),
            .height(constant: 372),
            .width(constant: 269)])
        brickConditionsDescribtionView.addSubview(contentView)

        brickConditionsDescribtionView.layer.cornerRadius = 15
        
        brickConditionsDescribtionView.layer.shadowOffset = CGSize(width: 0, height: 5)
        brickConditionsDescribtionView.layer.shadowOpacity = 0.3
        brickConditionsDescribtionView.layer.shadowRadius = 2
    }
    
    private func setupTitleLabel() {
        view.addSubview(mainTitleLabel)
        mainTitleLabel.addConstraints(to_view: contentView, [
            .top(anchor: contentView.topAnchor, constant: 24),
            .centerX(anchor: contentView.centerXAnchor),
            .height(constant: 22)])
        
        mainTitleLabel.text = "INFO"
        mainTitleLabel.font = R.font.ubuntuBold(size: 18)
        mainTitleLabel.textColor = UIColor.standartTextColor
    }
    
    private func setupConditionInfo() {
        
        let labelInfo1 = UILabel()
        view.addSubview(labelInfo1)
        labelInfo1.addConstraints(to_view: contentView, [
            .top(anchor: mainTitleLabel.bottomAnchor, constant: 24),
            .leading(anchor: contentView.leadingAnchor, constant: 30),
            .height(constant: 30)])
        setupInfoLabels(label: labelInfo1)
        labelInfo1.text = "Brick is wet - raining"
        
        let labelInfo2 = UILabel()
        view.addSubview(labelInfo2)
        labelInfo2.addConstraints(to_view: contentView, [
            .top(anchor: labelInfo1.bottomAnchor),
            .leading(anchor: contentView.leadingAnchor, constant: 30),
            .height(constant: 30)])
        setupInfoLabels(label: labelInfo2)
        labelInfo2.text = "Brick is dry - sunny"
        
        let labelInfo3 = UILabel()
        view.addSubview(labelInfo3)
        labelInfo3.addConstraints(to_view: contentView, [
            .top(anchor: labelInfo2.bottomAnchor),
            .leading(anchor: contentView.leadingAnchor, constant: 30),
            .height(constant: 30)])
        setupInfoLabels(label: labelInfo3)
        labelInfo3.text = "Brick is hard to see - fog"
        
        let labelInfo4 = UILabel()
        view.addSubview(labelInfo4)
        labelInfo4.addConstraints(to_view: contentView, [
            .top(anchor: labelInfo3.bottomAnchor),
            .leading(anchor: contentView.leadingAnchor, constant: 30),
            .height(constant: 30)])
        setupInfoLabels(label: labelInfo4)
        labelInfo4.text = "Brick with cracks - very hot"
        
        let labelInfo5 = UILabel()
        view.addSubview(labelInfo5)
        labelInfo5.addConstraints(to_view: contentView, [
            .top(anchor: labelInfo4.bottomAnchor),
            .leading(anchor: contentView.leadingAnchor, constant: 30),
            .height(constant: 30)])
        setupInfoLabels(label: labelInfo5)
        labelInfo5.text = "Brick with snow - snow"
        
        let labelInfo6 = UILabel()
        view.addSubview(labelInfo6)
        labelInfo6.addConstraints(to_view: contentView, [
            .top(anchor: labelInfo5.bottomAnchor),
            .leading(anchor: contentView.leadingAnchor, constant: 30),
            .height(constant: 30)])
        setupInfoLabels(label: labelInfo6)
        labelInfo6.text = "Brick is swinging - windy"
        
        let labelInfo7 = UILabel()
        view.addSubview(labelInfo7)
        labelInfo7.addConstraints(to_view: contentView, [
            .top(anchor: labelInfo6.bottomAnchor),
            .leading(anchor: contentView.leadingAnchor, constant: 30),
            .height(constant: 30)])
        setupInfoLabels(label: labelInfo7)
        labelInfo7.text = "Brick is gone - No Internet"
    }
    
    private func setupInfoLabels(label: UILabel) {
        label.font = R.font.ubuntuRegular(size: 15)
        label.textColor = UIColor.standartTextColor
    }
    
    private func setupBackToMainVCView() {
        view.addSubview(backToMainVCView)
        backToMainVCView.addConstraints(to_view: contentView, [
            .bottom(anchor: contentView.bottomAnchor, constant: 24),
            .height(constant: 31),
            .width(constant: 115),
            .centerX(anchor: contentView.centerXAnchor)])
        backToMainVCView.layer.borderWidth = 1
        backToMainVCView.layer.borderColor = UIColor(red: 0.342, green: 0.342, blue: 0.342, alpha: 1).cgColor
        backToMainVCView.layer.cornerRadius = 15
        
        let label = UILabel()
        label.text = "Hide"
        label.textColor = UIColor(red: 0.342, green: 0.342, blue: 0.342, alpha: 1)
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
