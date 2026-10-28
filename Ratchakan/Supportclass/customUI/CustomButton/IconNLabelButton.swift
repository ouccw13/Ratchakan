//
//  IconNLabelButton.swift
//  ratchakan
//
//  Created by JJsobtid on 10/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class IconNLabelButton: UIView {

	var iconImage: UIImageView!
	var titleLabel: UILabel!
	var identifier: String!
	
	var delegate: GenderSelectDelegate?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		iconImage = UIImageView()
		titleLabel = UILabel()
		titleLabel.textColor = .Celllabel
		titleLabel.font = .kanitLight16
		
		let tapButtonGesture = UITapGestureRecognizer(target: self, action: #selector(touchInSide(_:)))
		self.addGestureRecognizer(tapButtonGesture)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func circleNText(_ text: String, withID id: String) {
		iconImage.image = UIImage(named: "emptySelect")
		titleLabel.text = text
		identifier = id
		
		addSubview(iconImage)
		addSubview(titleLabel)
		
		setLayout()
	}
	
	func setLayout() {
		if identifier == "male" || identifier == "female" {
			iconImage.snp.makeConstraints({ (make) in
				make.size.equalTo(CGSize(width: 11, height: 11))
				make.centerY.equalTo(snp.centerY)
				make.leading.equalTo(snp.leading).offset(2)
			})
			titleLabel.snp.makeConstraints({ (make) in
				make.height.equalTo(24)
				make.width.equalTo(50)
				make.centerY.equalTo(iconImage.snp.centerY)
				make.leading.equalTo(iconImage.snp.trailing).offset(11)
			})
		} else {
			titleLabel.textColor = .guestcolor
			titleLabel.font = .kanitLight14
			iconImage.snp.makeConstraints({ (make) in
				make.size.equalTo(CGSize(width: 17, height: 17))
				make.centerY.equalTo(snp.centerY)
				make.leading.equalTo(snp.leading).offset(19)
			})
			titleLabel.snp.makeConstraints({ (make) in
				make.height.equalTo(20)
				make.centerY.equalTo(iconImage.snp.centerY)
				make.leading.equalTo(iconImage.snp.trailing).offset(14)
				make.trailing.equalTo(self.snp.trailing).offset(-MARGIN)
			})
		}
	}
	
	@objc func touchInSide(_ sender: UITapGestureRecognizer) {
//		if identifier == "male" || identifier == "female" {
		if iconImage.image != UIImage(named: "selectedIcon") {
			iconImage.image = UIImage(named: "selectedIcon")
			delegate?.select(gender: identifier)
		}
//		}
	}
	
	func didUnselectedGender() {
		iconImage.image = UIImage(named: "emptySelect")
	}
	/*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
