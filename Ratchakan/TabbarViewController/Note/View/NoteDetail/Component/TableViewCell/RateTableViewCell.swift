//
//  RateTableViewCell.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 20/8/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit
import Cosmos

class RateTableViewCell: UITableViewCell {
    
    static let identifier = "RateCell"
    
    var callBack: ((Double, String?) -> ())!
    
    var comment: Comment! {
        didSet {
            if comment != nil {
                updateUI()
                ratingStar.rating = comment.rating
                titleLabel.text = comment.user.displayName
                commentLabel.text = comment.comment
                dateLabel.text = Date().dateFormatter(timeStamp: comment.createdAt)
                let imageName = comment.user.gender!
                userImageView.image = UIImage(named: imageName)
            }
        }
    }
    
    private let titleLabel: UILabel! = {
        let lb = UILabel()
        lb.font = .kanitLight14
        lb.textColor = .canceltext
        lb.text = "ให้คะแนน"
        return lb
    }()
    
    private var ratingStar: CosmosView = {
        let view = CosmosView()
        view.settings.filledImage = UIImage(named: "iconStar1Large")
        view.settings.emptyImage = UIImage(named: "iconStar3Large")
        view.settings.starSize = 25
        view.settings.starMargin = 10
        view.settings.totalStars = 5
        view.settings.fillMode = .full
        view.rating = 0
        return view
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .kanitLight12
        label.textColor = .brownGrey
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .sarabun12
        label.textColor = .greyishBrown
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setParameter("แก้ไข", textColor: .pinky, font: .kanitReg12, backgroundColor: .clearCanTouch)
        return button
    }()
    
    let headerView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUI()
        handlingRatingStarButton()
    }
    
    private func setupUI() {
        headerView.backgroundColor = .brandcolor_bg
        
        contentView.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.height.equalTo(16)
        }
        
        if comment != nil {
            
        } else {
            contentView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(headerView.snp.bottom).offset(12)
                make.leading.equalTo(contentView.snp.leading).offset(16)
            }
            
            ratingStar.settings.updateOnTouch = false
            contentView.addSubview(ratingStar)
            ratingStar.snp.makeConstraints { (make) in
                make.centerX.equalTo(contentView.snp.centerX)
                make.top.equalTo(headerView.snp.bottom).offset(36)
                make.height.equalTo(25)
                make.bottom.equalTo(contentView.snp.bottom).offset(-36)
            }
        }
    }
    
    private func updateUI() {
        
        if comment != nil {
            contentView.addSubview(userImageView)
            userImageView.snp.makeConstraints { (make) in
                make.top.equalTo(headerView.snp.bottom).offset(16)
                make.leading.equalTo(contentView.snp.leading).offset(16)
                make.size.equalTo(36)
            }
            userImageView.layer.cornerRadius = 18
        
            titleLabel.snp.remakeConstraints { (make) in
                make.top.equalTo(headerView.snp.bottom).offset(16)
                make.leading.equalTo(userImageView.snp.trailing).offset(8)
            }
            titleLabel.font = .kanitReg14
        
            contentView.addSubview(dateLabel)
            dateLabel.snp.makeConstraints { (make) in
                make.top.equalTo(headerView.snp.bottom).offset(18)
                make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            }
        
            ratingStar.settings.updateOnTouch = false
            ratingStar.isUserInteractionEnabled = false
            ratingStar.snp.remakeConstraints { (make) in
                make.top.equalTo(headerView.snp.bottom).offset(68)
                make.centerX.equalTo(contentView.snp.centerX)
            }
        
            contentView.addSubview(commentLabel)
            commentLabel.snp.makeConstraints { (make) in
                make.top.equalTo(ratingStar.snp.bottom).offset(16)
                make.leading.equalTo(contentView.snp.leading).offset(16)
                make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            }
            
            contentView.addSubview(editButton)
            editButton.snp.makeConstraints { (make) in
                make.top.equalTo(commentLabel.snp.bottom).offset(24)
                make.centerX.equalTo(commentLabel.snp.centerX)
                make.bottom.equalTo(contentView.snp.bottom).offset(-24)
            }
            editButton.addTarget(self, action: #selector(editButtonDidTap(sender:)), for: .touchUpInside)
        }
    }
    
    @objc func editButtonDidTap(sender: UIButton) {
        let score = ratingStar.rating
        callBack(score, commentLabel.text)
    }
    
    func handlingRatingStarButton() {
        ratingStar.didTouchCosmos = { [weak self] (value) in
            self?.callBack(value, nil)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
