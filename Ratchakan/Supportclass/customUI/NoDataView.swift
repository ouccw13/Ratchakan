//
//  NoDataView.swift
//  ratchakan
//
//  Created by JJsobtid on 18/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class NoDataView: UIView {
	
	var nodataImage: UIImageView!
	var detailLabel: UILabel!
	
	init(_ frame: CGRect,withText text: String = string.th_data_not_found, image: String = "noDataIcon") {
		super.init(frame: frame)
	
		backgroundColor = .clear
		detailLabel = UILabel()
		detailLabel.setParameter(font: .kanitReg16, color: .brandcolor3_dark, alignment: .center)
		detailLabel.flexibleLine()
		detailLabel.text = text
		
		nodataImage = UIImageView()
		nodataImage.setParameter(name: image, mode: .scaleAspectFit)
		
		addsubviews([nodataImage, detailLabel])
		
		setConstrain()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setConstrain() {
		nodataImage.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 100, height: 100))
			make.centerX.equalTo(snp.centerX)
			make.centerY.equalTo(snp.centerY).offset(-20)
		}
		detailLabel.snp.makeConstraints { (make) in
			make.leading.equalTo(snp.leading).offset(30)
			make.trailing.equalTo(snp.trailing).offset(-30)
			make.top.equalTo(nodataImage.snp.bottom).offset(20)
//			make.height.greaterThanOrEqualTo(24)
		}
	}
	
}
