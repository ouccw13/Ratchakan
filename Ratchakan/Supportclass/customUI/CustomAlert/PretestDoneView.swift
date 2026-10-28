//
//  PretestDoneView.swift
//  ratchakan
//
//  Created by JJsobtid on 2/7/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class PretestDoneView: UIView {

	var view: UIView!
	var alertBackgroundView: UIView!
	var titleLabel, detailLabel: UILabel!
	var iconImageView: UIImageView!
	var acceptButton: UIButton!
	
	init(withView v: UIView) {
		super.init(frame: CGRect(origin: v.center, size: CGSize.zero))
		
		backgroundColor = .blackalpha
		view = v
		
		iconImageView = UIImageView(image: UIImage(named: "purchaseSuccessImage"))
		iconImageView.contentMode = .scaleAspectFit
		
		alertBackgroundView = UIView(frame: CGRect(origin: v.center, size: CGSize.zero))
		alertBackgroundView.backgroundColor = .white
		alertBackgroundView.cornerView(radius: 10)
		
		titleLabel = UILabel()
		titleLabel.setParameter(font: .kanitReg16, color: .Celllabel, alignment: .center)
		titleLabel.text = "ทำข้อสอบสำเร็จ"
		detailLabel = UILabel()
		detailLabel.setParameter(font: .kanitLight16, color: .placeholdercolor, alignment: .center)
		detailLabel.flexibleLine()
		detailLabel.text = "ยินดีด้วย คุณทำข้อสอบเสร็จแล้ว กรุณารอคะแนนออกหลังหมดเวลาสอบ"
		
		acceptButton = UIButton()
		acceptButton.setParameter("ตกลง", textColor: .brandcolor1, font: .kanitReg16, backgroundColor: .white)
		acceptButton.borderView(color: .darkgraybg, width: 1.0)
		
		alertBackgroundView.addsubviews([titleLabel, detailLabel, acceptButton])
		addsubviews([alertBackgroundView, iconImageView])
		
		v.addSubview(self)
		
		setDefaultLayout()
	}
	
	func acceptAddTarget(_ target: Any, selector: Selector) {
		acceptButton.addTarget(target, action: selector, for: .touchUpInside)
	}
	
	func setDefaultLayout() {
//		snp.makeConstraints { (make) in
//			make.
//		}
		titleLabel.snp.remakeConstraints { (make) in
			make.top.equalTo(alertBackgroundView.snp.top).offset(45)
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
		UIView.animate(withDuration: 0.25, animations: {
			self.layoutIfNeeded()
		})
		iconImageView.snp.remakeConstraints { (make) in
			make.size.equalTo(CGSize(width: 98, height: 79))
			make.centerX.equalTo(alertBackgroundView.snp.centerX)
			make.centerY.equalTo(alertBackgroundView.snp.top)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	/*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
