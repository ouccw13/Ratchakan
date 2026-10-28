//
//  PretestDetailHeaderView.swift
//  ratchakan
//
//  Created by Chatchawarn  Udomchutipath on 3/10/2565 BE.
//  Copyright © 2565 BE Chatcha.sobtid. All rights reserved.
//

import UIKit
import SDWebImage

class PretestDetailHeaderView: UIView {
    var coverImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        createView()
        setConstraints()
    }
    
    // MARK: create view
    private func createView() {
        clipsToBounds = true
        
        coverImageView = UIImageView()
        coverImageView.sd_setImage(with:URL(string: "https://s3-ap-southeast-1.amazonaws.com/sobtidimage/advertisement/banner/tablet/5c9aab1451c33f153fae54d2b59e1483-ErL7GviLZyxjHP1R.png")!,placeholderImage: UIImage(named: "placeholderImage"))
        addsubviews([coverImageView])
    }
    
    // MARK: set constraints
    private func setConstraints() {
        coverImageView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top)
            make.leading.equalTo(snp.leading)
            make.trailing.equalTo(snp.trailing)
            make.bottom.equalTo(snp.bottom)
        }
    }
    
    func setBanner(banner: String = "") {
        if IS_IPAD {
            coverImageView.sd_setImage(with: URL(string: "https://s3-ap-southeast-1.amazonaws.com/sobtidimage/advertisement/banner/tablet/" + banner))
        }else{
            coverImageView.sd_setImage(with: URL(string: "https://s3-ap-southeast-1.amazonaws.com/sobtidimage/advertisement/banner/phone/" + banner))
        }
    }
}
