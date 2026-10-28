//
//  AlertView.swift
//  ratchakan
//
//  Created by JJsobtid on 16/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

@objc protocol CustomAlertDelegate {
	@objc optional func cancelAlert()
	@objc optional func confirmAlert()
}
class AlertView: UIView {

	var isShow: Bool = false
	var isImage: Bool = false
	
	var background: UIView!
	var alert: UIView!
	var closeButton: UIButton!
	var nextButton: UIButton!
	var separateLine: UIView!
	var separateButton: UIView!
	var titleLabel: UILabel!
	var detailLabel: UILabel!
	var timeCount: countdownLabel!
	var iconImageView: UIImageView!
	
	var data: dictStringAny!
	
	var timer: Timer!
	var alertInformation: Any?
	
	var delegate: CustomAlertDelegate?
	
	override init(frame: CGRect = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)) {
		super.init(frame: frame)
		backgroundColor = .clear
		
		iconImageView = UIImageView(image: UIImage(named: "purchaseSuccessImage"))
		iconImageView.frame = CGRect(origin: center, size: CGSize.zero)
		iconImageView.contentMode = .scaleAspectFit
		
		background = UIView(frame: frame)
		background.backgroundColor = .blackalpha
		background.addTarget(self, selector: #selector(animatedHide))
		
		closeButton = UIButton()
		closeButton.setParameter(string.th_cancel, textColor: .brandcolor1, font: .kanitReg16, backgroundColor: .clear)
		closeButton.addTarget(self, action: #selector(animatedHide), for: .touchUpInside)
		closeButton.touchAnimate()
		
		nextButton = UIButton()
		nextButton.setParameter(string.th_ok, textColor: .brandcolor1, font: .kanitReg16, backgroundColor: .clear)
		nextButton.addTarget(self, action: #selector(next_), for: .touchUpInside)
		nextButton.touchAnimate()
		
		separateLine = UIView()
		separateLine.lineView()
		separateButton = UIView()
		separateButton.lineView()
		
		alert = UIView()
		alert.cornerView()
		alert.backgroundColor = .white
		
		titleLabel = UILabel()
		titleLabel.numberOfLines = 0
		titleLabel.setParameter(font: .kanitReg16, color: .Celllabel, alignment: .center)
		titleLabel.lineBreakMode = .byWordWrapping
		
		detailLabel = UILabel()
		detailLabel.numberOfLines = 0
		detailLabel.setParameter(font: .kanitLight16, color: .guestcolor, alignment: .center)
		detailLabel.lineBreakMode = .byWordWrapping
		
		timeCount = countdownLabel()
		timeCount.setParameter(font: .kanitReg40, color: .brandcolor1, alignment: .center)
		
		alert.addsubviews([closeButton, separateButton, nextButton, separateLine, titleLabel, timeCount, detailLabel])
		
		closeButton.snp.makeConstraints { (make) in
			make.leading.equalTo(alert.snp.leading)
			make.trailing.equalTo(nextButton.snp.leading)
			make.bottom.equalTo(alert.snp.bottom)
			make.height.equalTo(55)
		}
		nextButton.snp.makeConstraints { (make) in
			make.leading.equalTo(alert.snp.trailing)
			make.trailing.equalTo(alert.snp.trailing)
			make.bottom.equalTo(alert.snp.bottom)
			make.height.equalTo(55)
		}
		
		separateLine.snp.makeConstraints { (make) in
			make.leading.equalTo(alert.snp.leading)
			make.trailing.equalTo(alert.snp.trailing)
			make.bottom.equalTo(closeButton.snp.top)
			make.height.equalTo(SEPARATE_LINE_WIDHT)
		}
		
		detailLabel.snp.makeConstraints { (make) in
			make.leading.equalTo(alert.snp.leading).offset(40)
			make.trailing.equalTo(alert.snp.trailing).offset(-40)
			make.bottom.equalTo(separateLine.snp.top).offset(-10)
			make.height.greaterThanOrEqualTo(28)
		}
		timeCount.snp.makeConstraints { (make) in
			make.centerX.equalTo(detailLabel.snp.centerX)
			make.bottom.equalTo(detailLabel.snp.top)
			make.width.equalTo(200)
			make.height.greaterThanOrEqualTo(0)
		}
		titleLabel.snp.makeConstraints { (make) in
			make.leading.equalTo(alert.snp.leading).offset(60)
			make.trailing.equalTo(alert.snp.trailing).offset(-60)
			make.bottom.equalTo(timeCount.snp.top)
			make.height.greaterThanOrEqualTo(24)
		}
		addsubviews([background, alert, iconImageView])
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func updateNewTime(_ time: Int) {
		timeCount.setTime(time)
	}
	
	func setTitle(_ title: String, detail: String, time: Int?, next: String = string.th_ok, close: String = string.th_cancel, image: Bool = false) {
		titleLabel.text = title
		detailLabel.text = detail
		isImage = image
		if detail == "ผลสอบของคุณออกแล้ว" {
			isImage = true
		}
		if time != nil {
			timeCount.setTime(time)
			timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
			nextButton.setTitle(next, for: .normal)
			closeButton.setTitle(close, for: .normal)
			nextButton.snp.remakeConstraints({ (make) in
				make.leading.equalTo(alert.snp.centerX)
				make.trailing.equalTo(alert.snp.trailing)
				make.bottom.equalTo(alert.snp.bottom)
				make.height.equalTo(closeButton.snp.height)
			})
			separateButton.snp.remakeConstraints({ (make) in
				make.width.equalTo(SEPARATE_LINE_WIDHT)
				make.height.equalTo(closeButton.snp.height)
				make.centerX.equalTo(alert.snp.centerX)
				make.bottom.equalTo(alert.snp.bottom)
			})
			closeButton.setTitleColor(.guestcolor, for: .normal)
		} else {
			closeButton.removeTarget(self, action: nil, for: .allEvents)
			closeButton.addTarget(self, action: #selector(next_), for: .touchUpInside)
			closeButton.setTitle(next, for: .normal)
			titleLabel.snp.remakeConstraints{ (make) in
				make.leading.equalTo(alert.snp.leading).offset(60)
				make.trailing.equalTo(alert.snp.trailing).offset(-60)
				make.bottom.equalTo(detailLabel.snp.top).offset(-4)
				make.height.greaterThanOrEqualTo(24)
			}
		}
	}
	
	
	@objc func updateTime() {
		if self.timeCount.timeOut {
			timer.invalidate()
			detailLabel.text = "เริ่มทำข้อสอบ"
		}
	}
	
	func animatedShow() {
		self.alert.snp.remakeConstraints({ (make) in
			make.center.equalTo(self.snp.center)
			make.width.equalTo(308)
			if isImage {
				make.top.equalTo(titleLabel.snp.top).offset(-45)
			} else {
				make.top.equalTo(titleLabel.snp.top).offset(-20)
			}
			make.height.greaterThanOrEqualTo(150)
		})
		if isImage {
			self.iconImageView.snp.remakeConstraints { (make) in
				make.size.equalTo(CGSize(width: 98, height: 79))
				make.centerY.equalTo(self.alert.snp.top)
				make.centerX.equalTo(self.alert.snp.centerX)
			}
		} else {
			
		}
		
		let currentViewController = Utility.getCurrentViewController()
		if let tabBarController = currentViewController.tabBarController {
			tabBarController.view.addSubview(self)
		} else {
			currentViewController.view.addSubview(self)
		}
		self.alert.transform = CGAffineTransform.init(scaleX: 0, y: 0)
		UIView.animate(withDuration: 0.3) {
			self.alert.transform = CGAffineTransform.init(scaleX: 1, y: 1)
			self.isShow = true
		}
	}
	@objc func animatedHide() {
		self.alert.transform = CGAffineTransform.init(scaleX: 1, y: 1)
		UIView.animate(withDuration: 0.3, animations: {
			self.alert.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
			self.iconImageView.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
		}) { (_) in
			self.removeFromSuperview()
			self.isShow = false
		}
	}
	
	@objc func next_() {
		animatedHide()
		delegate?.confirmAlert!()
	}
	
}
