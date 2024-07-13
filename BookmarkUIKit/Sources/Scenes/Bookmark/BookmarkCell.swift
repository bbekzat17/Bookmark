//
//  BookmarkCell.swift
//  BookmarkUIKit
//
//  Created by Bekzat Batyrkhanov on 26.02.2024.
//

import UIKit

class BookmarkCell: UITableViewCell {
    
    var titleLabel = UILabel()
    var rightImageView = UIImageView(image: UIImage(named: "rightImage"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(rightImageView)
        
        configureImageView()
        configureTitleLabel()
        
        setImageConstraints()
        setTitleLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(bookmark: BookmarkModel) {
        titleLabel.text = bookmark.title
    }
    
    func configureImageView() {
        
    }
    
    func configureTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setImageConstraints() {
        rightImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(24)
            make.height.equalTo(46)
        }
    }
    
    func setTitleLabelConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    
}
