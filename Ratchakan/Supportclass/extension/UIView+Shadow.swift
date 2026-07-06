//
//  UIView+Shadow.swift
//  ratchakan
//
//  Created by JJsobtid on 12/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	
	func reSetLayout() {
		setNeedsDisplay()
		setNeedsLayout()
		layoutIfNeeded()
	}
	
	func addsubviews(_ views: [UIView]) {
		for view in views {
			addSubview(view)
		}
	}
    
    func cornerView(radius: CGFloat = 10, clip: Bool = true) {
        clipsToBounds = clip
        layer.cornerRadius = radius
    }
	
	func dropShadow(scale: Bool = true) {
		self.layer.masksToBounds = false
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOpacity = 0.5
		self.layer.shadowOffset = CGSize(width: -1, height: 1)
		self.layer.shadowRadius = 1
		
		self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
		self.layer.shouldRasterize = true
		self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
	}
	
	func dropShadow(color: UIColor, opacity: Float = 1, offSet: CGSize = CGSize(width: 0, height: 3), radius: CGFloat = 4, scale: Bool = true) {
		self.layer.masksToBounds = false
		self.layer.shadowColor = color.cgColor
		self.layer.shadowOpacity = opacity
		self.layer.shadowOffset = offSet
		self.layer.shadowRadius = radius
		
		self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
		self.layer.shouldRasterize = true
		self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
	}
	
	func dropShadowCircle(color: UIColor = .brandcolor1, radius: CGFloat = 5, scale: Bool = true)  {
		self.layer.masksToBounds = false
		self.layer.shadowColor = color.cgColor
		self.layer.shadowOpacity = 1
		self.layer.shadowOffset = CGSize(width: 0, height: 0)
		self.layer.shadowRadius = radius
		
		let startAngle: CGFloat = 3 * .pi / 2
		let endAngle: CGFloat = (3 * .pi / 2) + (2 * .pi)
		self.layer.shadowPath = UIBezierPath(arcCenter: center, radius: bounds.height/2, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
		self.layer.shouldRasterize = true
		self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
	}
	
	func removeShadow() {
		self.layer.shadowColor = UIColor.clear.cgColor
		self.layer.shadowOpacity = 0.0
	}
	
	func lineView(withColor color: UIColor = .darkgraybg) {
		backgroundColor = color
		accessibilityIdentifier = "underline"
	}

	func cornerView(radius: CGFloat = 10) {
		clipsToBounds = true
		layer.cornerRadius = radius
	}
	func circleView() {
        layer.cornerRadius = self.frame.height/2
		clipsToBounds = true
	}
	func borderView(color: UIColor, width: CGFloat) {
		layer.borderColor = color.cgColor
		layer.borderWidth = width
	}
	
	func show() {
		isHidden = false
	}
	func hide() {
		isHidden = true
	}
	func showHide() {
		isHidden = !isHidden
	}
	
	func testBorder() {
		let testSwitchFrame = TestFrameView()
		testSwitchFrame.addAndMakeConstraints(withSuperview: self)
	}
	
	func addBackgroundGradient(colors: [UIColor], horizontal: Bool) {
		let gradientColors = colors.map { $0.cgColor }
		
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = bounds
		
		gradientLayer.colors = gradientColors
		gradientLayer.locations = [0.0, 0.5]
		if horizontal {
			gradientLayer.startPoint = CGPoint(x: 0, y: 0)
			gradientLayer.endPoint = CGPoint(x: 1, y: 0)
		} else {
			gradientLayer.startPoint = CGPoint(x: 0, y: 0)
			gradientLayer.endPoint = CGPoint(x: 0, y: 1)
		}
		layer.insertSublayer(gradientLayer, at: 0)
	}
	
	func removeBackgroundGradient() {
		if let layer = layer.sublayers?.first as? CAGradientLayer {
			layer.removeFromSuperlayer()
		} else {
//			addBackgroundGradient(colors: [.brandcolor1, .brandcolor2], horizontal: false)
		}
	}
	
	func addTarget(_ target: Any, selector: Selector) {
		let tapGestureRecognizer = UITapGestureRecognizer(target: target, action: selector)
		tapGestureRecognizer.delegate = target as? UIGestureRecognizerDelegate
		addGestureRecognizer(tapGestureRecognizer)
		isUserInteractionEnabled = true
	}
	
	func scrollViewContentFitToSubview() -> CGSize {
		
		var content = CGRect()
		for view in subviews {
			if not(view.isHidden) {
				content = content.union(view.frame)
			}
		}
		
		return CGSize(width: content.size.width, height: content.size.height + MARGIN)
	}
	
	func overlabKeyboard(_ parent: UIView, targetY: CGFloat? = nil) -> (Bool, CGFloat) {
		if let pointOnView = superview?.convert(frame, to: parent) {
			if targetY == nil {
				if (pointOnView.origin.y + pointOnView.size.height) >= ORIGIN_Y_KEYBOARD {
					let differentOrigin = ((pointOnView.origin.y + pointOnView.size.height) - ORIGIN_Y_KEYBOARD) + MARGIN
					return (true, differentOrigin)
				}
			} else {
				if (pointOnView.origin.y + pointOnView.size.height) >= targetY! {
					let differentOrigin = ((pointOnView.origin.y + pointOnView.size.height) - targetY!) + MARGIN
					return (true, differentOrigin)
				}
			}
			return (false, 0)
		}
		return (false, 0)
	}
	
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func makeSecure() {
        // 1. สร้าง UITextField ล่องหน
        let textField = UITextField()
        textField.isSecureTextEntry = true
        
        // 2. ดึง Layer ที่เป็น "Secure Layer" ของ TextField ออกมา
        // ซึ่ง Layer นี้ Apple ออกแบบมาให้กลายเป็นสีดำเมื่อมีการแคปหน้าจอ
        guard let secureLayer = textField.subviews.first?.subviews.first else { return }
        
        // 3. ย้ายลำดับการแสดงผล (Layout)
        secureLayer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(secureLayer)
        
        // 4. ตั้งค่าให้ Secure Layer คลุมทั้ง View ของเรา
        NSLayoutConstraint.activate([
            secureLayer.topAnchor.constraint(equalTo: self.topAnchor),
            secureLayer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            secureLayer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            secureLayer.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        // 5. ย้าย UI Content เดิมของเรา (เช่น ข้อสอบ) เข้าไปอยู่ใน Secure Layer นี้
        if let lastSubview = self.subviews.last, lastSubview != secureLayer {
            secureLayer.addSubview(lastSubview)
        }
    }
}
