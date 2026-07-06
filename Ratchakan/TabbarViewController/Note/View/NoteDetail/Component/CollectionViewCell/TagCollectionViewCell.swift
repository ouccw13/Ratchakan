//
//  TagCollectionViewCell.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 19/8/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TagCell"
    
    var titleText: String! {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .kanitLight14
        label.textColor = .weakness_d_s
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(8)
            make.trailing.equalTo(contentView.snp.trailing).offset(8)
        }
        
        contentView.cornerView(radius: 3)
        contentView.borderView(color: .weakness_d_s, width: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
