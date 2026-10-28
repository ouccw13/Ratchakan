//
//  CustomCollectionViewCell.swift
//  ratchakan
//
//  Created by JJsobtid on 16/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class PretestCollectionSelectDateCell: UICollectionViewCell {
	
	static let cellDateIdentifier = "PretestCollectionSelectDate"
	static let cellTimeIdentifier = "PretestCollectionSelectTime"
	
	var title: UILabel!
	var selectNow: Bool!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		cornerView()
		borderView(color: .darkgraybg, width: 1.0)
		title = UILabel()
		title.setParameter(font: .kanitReg14, color: .darkgraybg, alignment: .center)

		contentView.addSubview(title)
		title.snp.makeConstraints { (make) in
			make.centerY.equalTo(contentView.snp.centerY)
			make.leading.equalTo(contentView.snp.leading).offset(6)
			make.trailing.equalTo(contentView.snp.trailing).offset(-6)
			make.height.equalTo(21)
		}
		
		selectNow = false
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func unselectGradient() {
		selectNow = false
		title.textColor = .darkgraybg
		borderView(color: .darkgraybg, width: 1.0)
		removeBackgroundGradient()
	}
	
	func selectGradient() {
		selectNow = true
		title.textColor = .white
		borderView(color: .clear, width: 1.0)
		addBackgroundGradient(colors: [.brandcolor1, .brandcolor2], horizontal: true)
	}
}
