//
//  UIButton+Custom.swift
//  ratchakan
//
//  Created by JJsobtid on 12/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit

let HEIGHT_ROUND_BUTTON: CGFloat = 50.0
let TIME_ANIMATE_COLOR_C = 0.4

extension UIButton {
	
	func setParameter(_ title: String, textColor: UIColor, font: UIFont, backgroundColor: UIColor) {
		setTitle(title, for: .normal)
		setTitleColor(textColor, for: .normal)
		titleLabel?.font = font
		self.backgroundColor = backgroundColor
	}
	
	func setBottomParameter(title: String, bgColor: UIColor) {
		self.titleLabel?.font = .kanitReg18
		self.setTitle(title, for: .normal)
		self.backgroundColor = bgColor
	}

	func withImage(_ name: String) {
		titleLabel?.text = ""
		backgroundColor = .clearCanTouch
		setImage(UIImage(named: name), for: .normal)
	}
	func withImageColor(_ name: String) {
		titleLabel?.text = ""
		backgroundColor = .clearCanTouch
		let image = UIImage(named: name)?.withRenderingMode(.alwaysTemplate)
		setImage(image, for: .normal)
		imageView?.tintColor = .brandcolor1
	}
	
	func setAnimatedTouch() {
		addTarget(self, action: #selector(startAnimated(_ :)), for: .touchDown)
	}
	@objc func startAnimated(_ sender: UIButton) {
		let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
		colorAnimation.fromValue = UIColor.brandcoloralpha.cgColor
		colorAnimation.duration = 1  // animation duration
		// colorAnimation.autoreverses = true // optional in my case
		// colorAnimation.repeatCount = FLT_MAX // optional in my case
		sender.layer.add(colorAnimation, forKey: "ColorPulse")
	}
	
	func roundButton() {
		self.clipsToBounds = true
		self.layer.cornerRadius = self.frame.size.height/2
		self.titleLabel?.font = UIFont.kanitReg16
	}

	func roundBoutton(_ radius: CGFloat) {
		self.clipsToBounds = true
		self.layer.cornerRadius = radius
	}

	func disableButton(canTouch: Bool) {
		self.isEnabled = canTouch
		UIView.animate(withDuration: TIME_ANIMATE_COLOR_C) {
			self.layer.backgroundColor =  UIColor.darkgraybg.cgColor
		}
	}
	func disableButton(canTouch: Bool, withColor color: UIColor) {
		self.isEnabled = canTouch
		UIView.animate(withDuration: TIME_ANIMATE_COLOR_C) {
			self.layer.backgroundColor =  color.cgColor
		}
	}
	func enableButton(color: UIColor) {
		self.isEnabled = true
		UIView.animate(withDuration: TIME_ANIMATE_COLOR_C) {
			self.layer.backgroundColor =  color.cgColor
		}
	}

	func touchAnimate() {
		addTarget(self, action: #selector(hightlight), for: .touchDown)
		addTarget(self, action: #selector(hightlight), for: .touchDragEnter)
		
		addTarget(self, action: #selector(unhightlight), for: .touchDragExit)
		addTarget(self, action: #selector(unhightlight), for: .touchUpOutside)
		addTarget(self, action: #selector(unhightlight), for: .touchUpInside)
	}
	@objc func hightlight() {
		backgroundColor = .brandcolor3
	}
	@objc func unhightlight() {
		backgroundColor = .clearCanTouch
	}
}
