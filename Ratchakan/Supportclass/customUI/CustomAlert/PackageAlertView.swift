//
//  PackageAlertView.swift
//  ratchakan
//
//  Created by JJsobtid on 2/7/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class PackageAlertView: UIView {

	var success: Bool!
	
	var view: UIView!
	var alertBackgroundView: UIView!
	var titleLabel, detailLabel: UILabel!
	var iconImageView: UIImageView!
	var acceptButton, closeButton: UIButton!
	
	init(withView v: UIView, title: String, detail: String, button: String, success: Bool = true) {
		super.init(frame: CGRect(origin: v.center, size: CGSize.zero))
		
		self.success = success
		backgroundColor = .blackalpha
		view = v
		
		iconImageView = UIImageView(image: UIImage(named: success ? "icSuccessGift" : "alertNewIcon"))
		iconImageView.contentMode = .scaleAspectFit
		
		alertBackgroundView = UIView(frame: CGRect(origin: v.center, size: CGSize.zero))
		alertBackgroundView.backgroundColor = .white
		alertBackgroundView.cornerView(radius: 10)
		
		closeButton = UIButton()
		closeButton.setImage(UIImage(named: "closeIcon"), for: .normal)
		closeButton.backgroundColor = .clearCanTouch
		closeButton.addTarget(self, action: #selector(animationHide), for: .touchUpInside)
		
		titleLabel = UILabel()
		titleLabel.setParameter(font: .kanitReg16, color: .Celllabel, alignment: .center)
		titleLabel.text = title
		detailLabel = UILabel()
		detailLabel.setParameter(font: .kanitLight16, color: .placeholdercolor, alignment: .center)
		detailLabel.flexibleLine()
		detailLabel.text = detail
		
		acceptButton = UIButton()
		acceptButton.setParameter(button, textColor: .brandcolor1, font: .kanitReg16, backgroundColor: .white)
		acceptButton.borderView(color: .darkgraybg, width: 1.0)
		acceptButton.addTarget(self, action: #selector(animationHide), for: .touchUpInside)
		
		alertBackgroundView.addsubviews([titleLabel, detailLabel, closeButton, acceptButton])
		addsubviews([alertBackgroundView, iconImageView])
		
		v.addSubview(self)
		
		setDefaultLayout()
		
		if !success {
			closeButton.hide()
		}
	}
	
	func acceptAddTarget(_ target: Any, selector: Selector) {
		acceptButton.addTarget(target, action: selector, for: .touchUpInside)
	}
	
	@objc func setDefaultLayout() {
		snp.remakeConstraints { (make) in
			make.center.equalTo(view.snp.center)
			make.size.equalTo(CGSize())
		}
		alertBackgroundView.snp.remakeConstraints { (make) in
			make.size.equalTo(CGSize())
			make.center.equalTo(view.snp.center)
		}
		iconImageView.snp.remakeConstraints { (make) in
			make.size.equalTo(CGSize())
			make.centerX.equalTo(alertBackgroundView.snp.centerX)
			make.centerY.equalTo(alertBackgroundView.snp.top)
		}
		closeButton.snp.remakeConstraints { (make) in
			make.size.equalTo(CGSize())
			make.top.equalTo(alertBackgroundView.snp.top).offset(MARGIN)
			make.trailing.equalTo(alertBackgroundView.snp.trailing).offset(-MARGIN)
		}
		titleLabel.snp.remakeConstraints { (make) in
			make.top.equalTo(alertBackgroundView.snp.top).offset(47)
			make.leading.equalTo(alertBackgroundView.snp.leading).offset(MARGIN)
			make.trailing.equalTo(alertBackgroundView.snp.trailing).offset(-MARGIN)
		}
		detailLabel.snp.remakeConstraints { (make) in
			make.top.equalTo(titleLabel.snp.bottom).offset(4)
			make.leading.equalTo(titleLabel.snp.leading)
			make.trailing.equalTo(titleLabel.snp.trailing)
		}
		acceptButton.snp.remakeConstraints { (make) in
			make.top.equalTo(detailLabel.snp.bottom).offset(10)
			make.height.equalTo(51)
			make.leading.equalTo(alertBackgroundView.snp.leading).offset(-1)
			make.trailing.equalTo(alertBackgroundView.snp.trailing).offset(1)
			make.bottom.equalTo(alertBackgroundView.snp.bottom).offset(1)
		}
	}
	
	func showLayout() {
		snp.remakeConstraints { (make) in
			make.center.equalTo(view.snp.center)
			make.edges.equalTo(view.snp.edges)
		}
		alertBackgroundView.snp.remakeConstraints { (make) in
			make.height.greaterThanOrEqualTo(150)//heightAlert)
			if IS_IPHONE_5_OR_LESS {
				make.width.equalTo(280)
			} else {
				make.width.equalTo(320)
			}
			make.center.equalTo(view.snp.center)
		}
		closeButton.snp.remakeConstraints { (make) in
			make.size.equalTo(CGSize(width: 15, height: 15))
			make.top.equalTo(alertBackgroundView.snp.top).offset(MARGIN)
			make.trailing.equalTo(alertBackgroundView.snp.trailing).offset(-MARGIN)
		}
		iconImageView.snp.remakeConstraints { (make) in
			make.size.equalTo(success ? CGSize(width: 98, height: 82) : CGSize(width: 98, height: 82))
			make.centerX.equalTo(alertBackgroundView.snp.centerX)
			make.centerY.equalTo(alertBackgroundView.snp.top)
		}
		UIView.animate(withDuration: 0.25, animations: {
			self.layoutIfNeeded()
		})
	}
	
	@objc func animationHide() {
		setDefaultLayout()
		UIView.animate(withDuration: 0.25, animations: {
			self.layoutIfNeeded()
		})
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
