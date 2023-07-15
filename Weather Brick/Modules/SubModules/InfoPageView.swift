//
//  InfoPageView.swift
//  Weather Brick
//
//  Created by Ivan Solohub on 15.07.2023.
//

import UIKit

class InfoPageView: UIViewController {
    
    private var brickConditionsDescribtionView = UIView()
    private var backToMainVCView = UIView()

    private var mainTitleLabel = UILabel()
    
    let mainVC = MainViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()
        setupUI()
    }
    
    //MARK: - Private methods
    private func setupUI() {
       
        setupDescribtionView()
        setupBackToMainVCView()
        setupTitleLabel()
        setupTapGestureRecognizer()
    }
    
    private func setupBackground() {
        view.backgroundColor = .white
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = R.image.image_background()
        view.addSubview(backgroundImageView)
    }
    
    private func setupDescribtionView() {
        view.addSubview(brickConditionsDescribtionView)
        brickConditionsDescribtionView.addConstraints(to_view: view, [
            .top(anchor: view.topAnchor, constant: 220),
            .bottom(anchor: view.bottomAnchor, constant: 220),
            .leading(anchor: view.leadingAnchor, constant: 49),
            .trailing(anchor: view.trailingAnchor, constant: 57)])
        
        brickConditionsDescribtionView.backgroundColor = .orange
    }
    
    private func setupTitleLabel() {
        view.addSubview(mainTitleLabel)
        mainTitleLabel.addConstraints(to_view: brickConditionsDescribtionView, [
            .top(anchor: brickConditionsDescribtionView.topAnchor, constant: 24),
            .centerX(anchor: brickConditionsDescribtionView.centerXAnchor),
            .height(constant: 22)])
        
        mainTitleLabel.text = "INFO"
        mainTitleLabel.font = R.font.ubuntuBold(size: 18)
        mainTitleLabel.textColor = UIColor.standartTextColor
    }
    
    private func setupBackToMainVCView() {
        view.addSubview(backToMainVCView)
        backToMainVCView.addConstraints(to_view: brickConditionsDescribtionView, [
            .bottom(anchor: brickConditionsDescribtionView.bottomAnchor, constant: 24),
            .height(constant: 31),
            .width(constant: 115),
            .centerX(anchor: brickConditionsDescribtionView.centerXAnchor)])
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

            mainVC.modalPresentationStyle = .fullScreen
            present(mainVC, animated: false)
        }
    }
}
