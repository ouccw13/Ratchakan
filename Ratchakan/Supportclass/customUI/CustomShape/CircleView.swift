//
//  CircleView.swift
//  ratchakan
//
//  Created by JJsobtid on 11/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import QuartzCore

enum CheckmarkType {
	case none
	case correct
	case error
}

class CircleView: CustomShape {
	
	var circleLayer: CAShapeLayer!
	var checkLayer: CAShapeLayer!
	var circleBGLayer: CAShapeLayer!
	var errorLayer: CAShapeLayer?
	var typeCheck: CheckmarkType!
	let gradient = CAGradientLayer()
	var point: UIView!
	var countLabel: LabelCounting!
	
	let circleWidth: CGFloat = 13.0
	
	init(withColor color: UIColor, type: CheckmarkType, frame: CGRect) {
		super.init(frame: frame)
		typeCheck = type
		tintColor = color
		drawCircle()
		drawLayer()
	}
	
	init(withColor color: UIColor, frame: CGRect) {
		super.init(frame: frame)
		typeCheck = .correct
		tintColor = color
		drawCircle()
		drawLayer()
	}
	
	init(withBackground color: UIColor, frame: CGRect) {
		super.init(frame: frame)
		tintColor = .brandcolor1
		drawCircleBackground()
		
		countLabel = LabelCounting(frame: frame)
		countLabel.hasPercent = true
		countLabel.text = "0%"
		countLabel.font = .kanitReg32
		countLabel.textColor = .brandcolor1
		addSubview(countLabel)
		countLabel.snp.makeConstraints { (make) in
			make.center.equalTo(snp.center)
			make.height.equalTo(48)
		}
		
		point = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: 4))
		point.backgroundColor = .white
		point.circleView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func animation() {
		
		let fadeAnimate = CABasicAnimation.init(keyPath: "strokeEnd")
		fadeAnimate.fromValue = 0.0
		fadeAnimate.toValue = 1.0
		fadeAnimate.duration = 1.0
		fadeAnimate.delegate = self
        fadeAnimate.fillMode = CAMediaTimingFillMode.forwards
		fadeAnimate.isRemovedOnCompletion = false
		circleLayer.add(fadeAnimate, forKey: "strokeEnd")
		if checkLayer != nil {
			checkLayer!.add(fadeAnimate, forKey: "strokeEnd")
		} else if errorLayer != nil {
			errorLayer!.add(fadeAnimate, forKey: "strokeEnd")
		}
	}
	
	func drawCircle() {
		if circleLayer != nil {
			circleLayer.removeFromSuperlayer()
		}
		circleLayer = CAShapeLayer()
		circleLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
		circleLayer.path = pathForBox().cgPath
		circleLayer.strokeColor = tintColor.cgColor
		circleLayer.lineWidth = 3.0
		circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = CAShapeLayerLineCap.round
        circleLayer.lineJoin = CAShapeLayerLineJoin.round
		circleLayer.strokeStart = 0.0
		circleLayer.strokeEnd = 0.0
		layer.addSublayer(circleLayer)
	}
	
	func drawLayer() {
		if checkLayer != nil {
			checkLayer.removeFromSuperlayer()
		}
		checkLayer = CAShapeLayer()
		checkLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
		if typeCheck == .correct {
			checkLayer.path = pathForCheckMark().cgPath
		} else if typeCheck == .error {
			checkLayer.path = pathForErrorMark().cgPath
		}
		checkLayer.strokeColor = tintColor.cgColor
		checkLayer.lineWidth = 3.0
		checkLayer.fillColor = UIColor.clear.cgColor
        checkLayer.lineCap = CAShapeLayerLineCap.round
        checkLayer.lineJoin = CAShapeLayerLineJoin.round
		checkLayer.strokeStart = 0.0
		checkLayer.strokeEnd = 0.0
		layer.addSublayer(checkLayer)
	}
	
	func drawCircleBackground() {
		if circleBGLayer != nil {
			circleBGLayer.removeFromSuperlayer()
		}
		circleBGLayer = CAShapeLayer()
		circleBGLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
		circleBGLayer.path = pathForBox().cgPath
		circleBGLayer.strokeColor = UIColor.Collectionbg.cgColor
		circleBGLayer.lineWidth = circleWidth
		circleBGLayer.fillColor = UIColor.clear.cgColor
        circleBGLayer.lineCap = CAShapeLayerLineCap.round
        circleBGLayer.lineJoin = CAShapeLayerLineJoin.round
		circleBGLayer.strokeStart = 0.0
		circleBGLayer.strokeEnd = 1.0
		layer.addSublayer(circleBGLayer)
		
	}
	func drawPercentCircle() {
		let radius = bounds.width/2
		
		let startAngle: CGFloat = 3 * .pi / 2
		let endAngle: CGFloat = ((3 * .pi / 2) + (2 * .pi))
		
		let pathDraw = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

		if circleLayer != nil {
			circleLayer.removeFromSuperlayer()
			point.removeFromSuperview()
		}
		circleLayer = CAShapeLayer()
		circleLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
		circleLayer.path = pathDraw.cgPath
		circleLayer.strokeColor = tintColor.cgColor
		circleLayer.lineWidth = circleWidth
		circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = CAShapeLayerLineCap.round
        circleLayer.lineJoin = CAShapeLayerLineJoin.round
		circleLayer.strokeStart = 0.0
		circleLayer.strokeEnd = 0.0
		layer.addSublayer(circleLayer)
			
		addSubview(point)
		point.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 4, height: 4))
			make.centerX.equalTo(snp.centerX)
			make.centerY.equalTo(snp.top)
		}

	}
	
	func animationPercent(_ percent: CGFloat) {
		if first {
			first = false
			var perc: CGFloat = 0.001
			if percent > 0 {
				perc = percent
			}
			
			circleLayer.strokeColor = circleFromColorNew[returnPassPercent(percent)].cgColor
			countLabel.textColor = circleFromColor[returnPassPercentText(percent)]
			
			let fadeAnimate = CABasicAnimation.init(keyPath: "strokeEnd")
			fadeAnimate.fromValue = 0.0
			fadeAnimate.toValue = perc
			fadeAnimate.duration = 1.0
			fadeAnimate.delegate = self
            fadeAnimate.fillMode = CAMediaTimingFillMode.forwards
			fadeAnimate.isRemovedOnCompletion = false
			circleLayer.add(fadeAnimate, forKey: "strokeEnd")
			countLabel.countFromZero(to: Float(perc * 100), duration: 1.0)
		}
	}
	
	func pathForBox() -> UIBezierPath {
		let radius = bounds.width/2
		
		let startAngle: CGFloat = 3 * .pi / 2
		let endAngle: CGFloat = (3 * .pi / 2) + (2 * .pi)
		
		let pathDraw = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
		
		return pathDraw
	}
	
	func pathForCheckMark() -> UIBezierPath {
		let checkMarkPath = UIBezierPath()
		checkMarkPath.move(to: CGPoint(x: bounds.width/3.1578, y: bounds.height/2))
		checkMarkPath.addLine(to: CGPoint(x: bounds.width/2.0618, y: bounds.height/1.57894))
		checkMarkPath.addLine(to: CGPoint(x: bounds.width/1.3953, y: bounds.height/2.7272))
		return checkMarkPath
	}
	
	func pathForErrorMark() -> UIBezierPath {
		let checkMarkPath = UIBezierPath()
		checkMarkPath.move(to: CGPoint(x: bounds.width*0.2673, y: bounds.height*0.32))
		checkMarkPath.addLine(to: CGPoint(x: bounds.width*0.7477, y: bounds.height*0.6944))
		checkMarkPath.move(to: CGPoint(x: bounds.width*0.7477, y: bounds.height*0.32))
		checkMarkPath.addLine(to: CGPoint(x: bounds.width*0.2673, y: bounds.height*0.6944))
		return checkMarkPath
	}
	
}
