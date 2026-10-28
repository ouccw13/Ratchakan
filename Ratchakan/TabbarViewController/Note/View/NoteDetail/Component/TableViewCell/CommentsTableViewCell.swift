//
//  CommentsTableViewCell.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 24/8/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit
import Cosmos

class CommentsTableViewCell: UITableViewCell {

    static let identifier = "CommentsCell"
    
    var comment: Comment! {
        didSet {
            userNameLabel.text = comment.user.displayName
            ratingStar.rating = comment.rating
            commentLabel.text = comment.comment
            dateLabel.text = Date().dateFormatter(timeStamp: comment.createdAt)
            let imageName = comment.user.gender!
            userImageView.image = UIImage(named: imageName)
        }
    }
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .green
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .kanitReg14
        label.textColor = .canceltext
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let ratingStar: CosmosView = {
        let view = CosmosView()
        view.settings.filledImage = UIImage(named: "iconStar1Small")
        view.settings.emptyImage = UIImage(named: "iconStar3Small")
        view.settings.updateOnTouch = false
        view.settings.starSize = 10
        view.settings.starMargin = 3
        view.settings.totalStars = 5
        view.settings.fillMode = .full
        view.rating = 0
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .kanitLight12
        label.textColor = .brownGrey
        label.text = "11 ก.ค. 63, 11:12 น."
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .sarabun12
        label.textColor = .greyishBrown
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    private func setupUI() {
        selectionStyle = .none
        
        contentView.addSubview(userImageView)
        userImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.top.equalTo(contentView.snp.top).offset(16)
            make.leading.equalTo(contentView.snp.leading).offset(16)
        }
        userImageView.layer.cornerRadius = 18
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(18)
            make.width.equalTo(dateLabel.text!.width(withConstrainedHeight: 0, font: .kanitLight12))
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
        
        contentView.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.leading.equalTo(userImageView.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(dateLabel.snp.leading).priority(1000)
        }
        
        contentView.addSubview(ratingStar)
        ratingStar.snp.makeConstraints { (make) in
            make.leading.equalTo(userImageView.snp.trailing).offset(8)
            make.bottom.equalTo(userImageView.snp.bottom).offset(-1)
        }
        
        contentView.addSubview(commentLabel)
        commentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(userNameLabel.snp.leading)
            make.top.equalTo(ratingStar.snp.bottom).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
        }
        
        let underLine = UIView()
        underLine.backgroundColor = .reddishPink
        underLine.alpha = 0.1
        
        contentView.addSubview(underLine)
        underLine.snp_makeConstraints { (make) in
            make.height.equalTo(1)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
