//
//  BarProcessView.swift
//  ratchakan
//
//  Created by JJsobtid on 11/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit
import Firebase

class BarProcessView: CustomShape {

	var bar, percentBar: CAShapeLayer!
	var barGradient: CAGradientLayer!
	var percentLabel: UILabel!
    
	var num: Int!
	var pastQuesion: Float!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		num = 0
		pastQuesion = 0
		
		bar = createBar(.separateLine, w: bounds.width, half: false)
		bar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
		layer.addSublayer(bar)
		
		percentLabel = UILabel()
		percentLabel.setParameter(font: .kanitLight10, color: .white, alignment: .right)
		
		barGradient = CAGradientLayer()
		percentBar = CAShapeLayer()
		
	}
	
	init(_ frame: CGRect, questionNum: Int) {
		super.init(frame: frame)
		
		num = questionNum
		pastQuesion = 0
		
		let pathBar = UIBezierPath()
		pathBar.move(to: CGPoint(x: 0, y: bounds.height/2))
		pathBar.addLine(to: CGPoint(x: bounds.width, y: bounds.height/2))
		pathBar.close()
		
		bar = CAShapeLayer()
		bar.frame = frame
		bar.path = pathBar.cgPath
		bar.lineWidth = bar.frame.height
		bar.fillColor = nil
        bar.lineJoin = CAShapeLayerLineJoin.round
        bar.lineCap = CAShapeLayerLineCap.square
		bar.strokeColor = UIColor.Collectionbg.cgColor
		bar.strokeStart = 0.0
		layer.addSublayer(bar)
		
		percentBar = CAShapeLayer()
		percentBar.frame = frame
		percentBar.path = pathBar.cgPath
		percentBar.lineWidth = bar.frame.height
		percentBar.fillColor = nil
        percentBar.lineJoin = CAShapeLayerLineJoin.round
        percentBar.lineCap = CAShapeLayerLineCap.square
		percentBar.strokeColor = UIColor.brandcolor1.cgColor
		percentBar.strokeStart = 0.0
		percentBar.strokeEnd = 1.0
		layer.addSublayer(percentBar)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func animationLineNum(questionNum: Float) {
		let pathAnimate = CABasicAnimation(keyPath: "strokeEnd")
		pathAnimate.duration = 0.25
		let fromValue = Float(pastQuesion)/Float(num)/2.0
		let toValue = Float(questionNum)/Float(num)/2.0
        
		pathAnimate.fromValue = fromValue
		pathAnimate.toValue = toValue
        pathAnimate.fillMode = CAMediaTimingFillMode.forwards
		pathAnimate.isCumulative = false
		pathAnimate.isAdditive = false
		pathAnimate.isRemovedOnCompletion = false
		
		percentBar.add(pathAnimate, forKey: "strokeEnd")
		
		pastQuesion = questionNum
	}
	
	func animationLine(toPercent percent: CGFloat) {
		let pathAnimate = CABasicAnimation(keyPath: "strokeEnd")
		let duration = first ? 1.0 : 0.001
		pathAnimate.duration = duration
		pathAnimate.fromValue = 0.0
		pathAnimate.toValue = percent
		if percent < 0.5 {
			pathAnimate.toValue = 0.5
		}
        pathAnimate.fillMode = CAMediaTimingFillMode.forwards
		pathAnimate.isCumulative = false
		pathAnimate.isAdditive = false
		pathAnimate.isRemovedOnCompletion = false
		
		percentBar.add(pathAnimate, forKey: "strokeEnd")
		addSubview(percentLabel)
		
        UIView.animate(withDuration: 0.5, delay: duration, options: UIView.AnimationOptions(rawValue: 0), animations: {
			self.percentLabel.alpha = 1
		}, completion: nil)
	}
	func animationDidStop(animate: CAAnimation, finished: Bool) {
		if finished {
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions(rawValue: 0), animations: {
				self.percentLabel.alpha = 1
			}, completion: nil)
		}
	}
	
	func createGradientLayer(_ percent: CGFloat) {
		let mainColor = fromcolorNew[returnIndex(percent)]
		let secondColor = toColorNew[returnIndex(percent)]
		
		let colors = [mainColor.cgColor, secondColor.cgColor]
		
		barGradient.frame = CGRect(x: -MARGIN, y: 0, width: bounds.width + 2*MARGIN, height: MARGIN)
        barGradient.colors = colors
		barGradient.startPoint = CGPoint(x: 0, y: 0)
		barGradient.endPoint = CGPoint(x: 1, y: 0)
		barGradient.locations = [0]
		if percent < 0.5 {
			barGradient.locations = [0, NSNumber(value: Float(percent/2))]
		}
	}
	func createBar(_ color: UIColor, w: CGFloat, half: Bool) -> CAShapeLayer {
		
		let pathBar = UIBezierPath()
		pathBar.move(to: CGPoint(x: 0, y: bounds.height/2))
		pathBar.addLine(to: CGPoint(x: w, y: bounds.height/2))
		pathBar.close()
		
		let tempBar = CAShapeLayer()
		tempBar.frame = frame
		tempBar.path = pathBar.cgPath
		tempBar.lineWidth = tempBar.frame.height
		tempBar.fillColor = nil
        tempBar.lineJoin = CAShapeLayerLineJoin.round
        tempBar.lineCap = CAShapeLayerLineCap.round
		tempBar.strokeColor = color.cgColor
		tempBar.strokeStart = 0.0
		
		if half {
			tempBar.fillColor = UIColor.clear.cgColor
			tempBar.strokeColor = UIColor.black.cgColor
			tempBar.strokeEnd = 0.0
		}
		
		return tempBar
	}
	
	func updateData(_ percent: CGFloat, id: String) {
		Crashlytics.crashlytics().setCustomValue(id, forKey: "bar_id")
		var per: CGFloat = percent
        
		if bounds.width <= 0.1 {
			return
		}
		if percent*bounds.width < 28 {
			per = 28/bounds.width
		}
		
		if percentBar != nil {
			percentBar.removeFromSuperlayer()
			barGradient.removeFromSuperlayer()
			percentLabel.removeFromSuperview()
		}

		let pathBar = UIBezierPath()
		pathBar.move(to: CGPoint(x: 0, y: MARGIN/2))
		pathBar.addLine(to: CGPoint(x: bounds.width * per, y: MARGIN/2))
		pathBar.close()
		
		percentBar.frame = bounds
		percentBar.path = pathBar.cgPath
		percentBar.lineWidth = frame.height
		percentBar.fillColor = nil
        percentBar.lineJoin = CAShapeLayerLineJoin.round
        percentBar.lineCap = CAShapeLayerLineCap.round
		percentBar.fillColor = UIColor.clear.cgColor
		percentBar.strokeColor = UIColor.black.cgColor
		percentBar.strokeEnd = 0.0
		percentBar.strokeStart = 0.0
		
		percentBar.frame = CGRect(x: MARGIN, y: 0, width: bounds.width, height: MARGIN)
		createGradientLayer(percent)

		barGradient.mask = percentBar
		layer.addSublayer(barGradient)
		
		percentLabel.frame = CGRect(x: -MARGIN, y: 0, width:MARGIN + (bounds.width * per), height: bounds.height)
		percentLabel.numberOfLines = 1
		percentLabel.text = "\(String(format: "%.2f", percent*100)) %"
		percentLabel.textAlignment = .right
		percentLabel.alpha = 0

		animationLine(toPercent: per)
		if first {
			first = false
		} else {
			
		}
	}
}
