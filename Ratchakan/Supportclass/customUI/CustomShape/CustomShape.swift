//
//  CustomShape.swift
//  ratchakan
//
//  Created by JJsobtid on 31/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class CustomShape: UIView, CAAnimationDelegate {

	let circleFromColor: [UIColor] = [.weakness_d, .greenendexam]
    
    let circleFromColorNew: [UIColor] = [.weakness_d, .greenendexam,.clear]
    let circleToColorNew: [UIColor] = [.weakness_d_s, .greenendexam,.clear]
	
    //new fromcolor
    let fromcolorNew = [UIColor.clear,UIColor.tomato,UIColor.chart_mean,UIColor.weakness_a_s,UIColor.statGreen]
    let toColorNew = [UIColor.clear,UIColor.tomato,UIColor.chart_mean,UIColor.weakness_a_s,UIColor.statGreen]
    
	var first: Bool = true
	
	func returnIndex(_ percent: CGFloat) -> Int {
        if percent == 0.0 {
            return 0
        }
        else if percent > 0.0 && percent <= 0.25 {
			return 1
		} else if percent <= 0.5 {
			return 2
		} else if percent <= 0.75 {
			return 3
		} else {
			return 4
		}
	}
	
	func returnPassPercent(_ percent: CGFloat) -> Int {
		if percent >= 0.6 {
			return 1
        }else if percent == 0.0 {
            return 2
        }else{
            return 0
        }
	}
    
    func returnPassPercentText(_ percent: CGFloat) -> Int {
        if percent >= 0.6 {
            return 1
        }else{
            return 0
        }
    }
}
