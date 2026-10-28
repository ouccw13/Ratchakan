//
//  NoDataCollectionViewCell.swift
//  ratchakan
//
//  Created by Kasidid Wachirachai on 15/9/2563 BE.
//  Copyright © 2563 JJsobtid. All rights reserved.
//

import UIKit

class NoDataCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "noData"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        
        let noDataView = NoDataView(contentView.frame)
        contentView.addSubview(noDataView)
        noDataView.snp.makeConstraints { (make) in
            make.center.equalTo(contentView.snp.center)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
