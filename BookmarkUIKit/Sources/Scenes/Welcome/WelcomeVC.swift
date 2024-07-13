//
//  ViewController.swift
//  BookmarkUIKit
//
//  Created by Bekzat Batyrkhanov on 15.02.2024.
//

import UIKit
import SnapKit

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    //MARK: - UI
    
    func configUI() {
        
        view.backgroundColor = .black
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bgImage")
        
        let titleLabel = UILabel()
        titleLabel.text = "Save all interesting links in one app"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        titleLabel.numberOfLines = 2
        
        let button = UIButton()
        button.setTitle("Let's start collecting ", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(buttonTaped), for: .touchUpInside)
        
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(button)
        
        imageView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height * 0.72)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.width.equalToSuperview().inset(20)
            $0.height.equalTo(92)
            $0.top.equalTo(imageView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.size.equalTo(BookmarUIKitConstants.buttonSize)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
    }
    
    //MARK: - Actions
    
    @objc private func buttonTaped() {
        navigationController?.pushViewController(MainVC(), animated: true)
    }
}

