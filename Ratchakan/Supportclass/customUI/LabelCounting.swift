//
//  LabelCounting.swift
//  ratchakan
//
//  Created by JJsobtid on 18/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import Foundation
import UIKit

enum CountingMethod {
	case easeInOut, easeIn, easeOut, linear
}

enum AnimationDuration {
	case laborious, plodding, strolling, brisk, instant
	
	var value: Double {
		switch self {
		case .laborious: return 20.0
		case .plodding: return 15.0
		case .strolling: return 8.0
		case .brisk: return 2.0
		case .instant: return 0.0
		}
	}
}

enum DecimalPoints {
	case zero, one, two, ridiculous
	
	var format: String {
		switch self {
		case .zero: return "%.0f"
		case .one: return "%.1f"
		case .two: return "%.2f"
		case .ridiculous: return "%f"
		}
	}
}

typealias OptionalCallback = (() -> Void)
typealias OptionalFormatBlock = (() -> String)

class LabelCounting: UILabel {
	var completion: OptionalCallback?
	var animationDuration: AnimationDuration = .brisk
	var decimalPoints: DecimalPoints = .zero
	var countingMethod: CountingMethod = .easeInOut
	var customFormatBlock: OptionalFormatBlock?
	var hasPercent: Bool = false
	
	fileprivate var currentValue: Float {
		if progress >= totalTime { return destinationValue }
		return startingValue + (update(t: Float(progress / totalTime)) * (destinationValue - startingValue))
	}
	
	fileprivate var rate: Float = 0
	fileprivate var startingValue: Float = 0
	fileprivate var destinationValue: Float = 0
	fileprivate var progress: TimeInterval = 0
	fileprivate var lastUpdate: TimeInterval = 0
	fileprivate var totalTime: TimeInterval = 0
	fileprivate var easingRate: Float = 0
	fileprivate var timer: CADisplayLink?
	
	func count(from: Float, to: Float, duration: TimeInterval? = nil) {
		startingValue = from
		destinationValue = to
		timer?.invalidate()
		timer = nil
		
		if (duration == 0.0) {
			// No animation
			setTextValue(value: to)
			completion?()
			return
		}
		
		easingRate = 3.0
		progress = 0.0
		totalTime = duration ?? animationDuration.value
		lastUpdate = Date.timeIntervalSinceReferenceDate
		rate = 3.0
		
		addDisplayLink()
	}
	
	func countFromCurrent(to: Float, duration: TimeInterval? = nil) {
		count(from: currentValue, to: to, duration: duration ?? nil)
	}
	
	func countFromZero(to: Float, duration: TimeInterval? = nil) {
		count(from: 0, to: to, duration: duration ?? nil)
	}
	
	func stop() {
		timer?.invalidate()
		timer = nil
		progress = totalTime
		completion?()
	}
	
	fileprivate func addDisplayLink() {
		timer = CADisplayLink(target: self, selector: #selector(self.updateValue(timer:)))
        timer?.add(to: .main, forMode: RunLoop.Mode.default)
        timer?.add(to: .main, forMode: RunLoop.Mode.tracking)
	}
	
	fileprivate func update(t: Float) -> Float {
		var t = t
		
		switch countingMethod {
		case .linear:
			return t
		case .easeIn:
			return powf(t, rate)
		case .easeInOut:
			var sign: Float = 1
			if Int(rate) % 2 == 0 { sign = -1 }
			t *= 2
			return t < 1 ? 0.5 * powf(t, rate) : (sign*0.5) * (powf(t-2, rate) + sign*2)
		case .easeOut:
			return 1.0-powf((1.0-t), rate);
		}
	}
	
	@objc fileprivate func updateValue(timer: Timer) {
		let now: TimeInterval = Date.timeIntervalSinceReferenceDate
		progress += now - lastUpdate
		lastUpdate = now
		
		if progress >= totalTime {
			self.timer?.invalidate()
			self.timer = nil
			progress = totalTime
		}
		
		setTextValue(value: currentValue)
		if progress == totalTime { completion?() }
	}
	
	fileprivate func setTextValue(value: Float) {
		if hasPercent {
			text = "\(String(format: customFormatBlock?() ?? decimalPoints.format, value))%"
		} else {
			text = String(format: customFormatBlock?() ?? decimalPoints.format, value)
		}
	}
	
}

class LoadingLabel: UILabel {
	
	var timer: Timer!
	
	func setText(_ text: String?) {
        if text == "เลขที่ 3 อาคารพร้อมพันธ์ุ 3 ห้อง 601-602 ซอยลาดพร้าว 3 ถนนลาดพร้าว แขวงจอมพล เขตจตุจักร กทม 10900" {
            self.text = "56/1 ซอยเรวดี ถนนพระราม 6 แขวงสามเสนใน เขตพญาไท กรุงเทพมหานคร 10400"
        }else if text == "02-024-6668" {
            self.text = "02-060-2889"
        }else{
            if text != nil {
                if timer != nil {
                    timer.invalidate()
                }
                self.text = text
            } else {
                self.text = "กำลังโหลด"
                timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(loadingLabel), userInfo: nil, repeats: true)
            }
        }
	}
	
	@objc func loadingLabel() {
		if self.text == "กำลังโหลด" {
			self.text = "กำลังโหลด."
		} else if self.text == "กำลังโหลด." {
			self.text = "กำลังโหลด.."
		} else if self.text == "กำลังโหลด.." {
			self.text = "กำลังโหลด..."
		} else if self.text == "กำลังโหลด..." {
			self.text = "กำลังโหลด"
		}
	}
}

class countdownLabel: UILabel {
	
	var timer: Timer!
	var secCount: Int!
	var timeOut: Bool = false
	
	func setTime(_ sec: Int?) {
		if sec != nil {
			secCount = sec!
			self.text = Datetime.timeFromSec(secCount, haveSpace: false, haveHour: false)
			if timer == nil {
				timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
                RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
			}
		} else {
			timeOut = true
			timer.invalidate()
			self.text = "ถึงเวลาสอบ"
		}
	}
	
	@objc func countdown() {
		secCount = secCount - 1
		if secCount >= 0 {
			setTime(secCount)
		} else {
			setTime(nil)
		}
	}
}


