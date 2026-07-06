//
//  UIColor+Theme.swift
//  ratchakan
//
//  Created by JJsobtid on 7/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit

extension UIColor {
	
	// MARK: Private
	fileprivate static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
		return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
	}
	
	fileprivate static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
		return rgba(r, g, b, 1.0)
	}
	
	fileprivate static func colorInteger(fromHexString: String) -> UInt32 {
		var hexInt: UInt32 = 0
		// Create scanner
		let scanner: Scanner = Scanner(string: fromHexString)
		// Tell scanner to skip the # character
		scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
		// Scan hex value
		scanner.scanHexInt32(&hexInt)
		return hexInt
	}
	
	// MARK: Public
	static let clearCanTouch = rgba(255, 255, 255, 0.001)
	
	static let borderColor = rgb(254, 250, 236)
	static let backgroundColor = rgb(67, 73, 110)
	static let scoreColor = rgb(255, 193, 45)
	static let textColor = UIColor.white
	static let playerBackgroundColor = rgb(84, 77, 126)
	static let brightPlayerBackgroundColor = rgba(101, 88, 156, 0.5)
	
	static let navcolor = rgb(250, 250, 250)
	static let navtextcolor = rgb(57, 57, 58)
	static let navtextsearch = UIColor.white//[UIColor colorWithRed:57/255.f green:57/255.f blue:58/255.f alpha:255/255.f]
	static let textgray = rgb(57, 57, 58)
	static let navbrandcolor = UIColor.brandcolor1
	static let navbrandtextcolor = UIColor.white
	static let navbrandtextsearch = rgb(255, 255, 255)
	static let segmentcolor = rgb(0, 110, 255)
	
	static let brandcolor1 = rgb(255, 50, 85)
	static let brandcoloralpha = rgba(255, 50, 85, 0.1)
	static let brandcolor2 = rgb(225, 50, 85)
	static let brandcolor3 = rgb(255, 193, 204)
	static let brandcolor3_dark = rgb(240, 152, 170)
	static let brandcolor3_darken = rgb(175, 0, 50)
	static let brandcolor_bg = rgb(255, 250, 250)
	
	static let brandconfirm = rgb(208, 2, 27)
	
	static let bottombutton = UIColor.brandcolor1
	static let disablebutton = rgb(205, 210, 216)
	static let lightblue = rgb(61, 168, 255)
	static let whiteblue = rgba(255, 255, 255, 0.6)
	static let btdarkblue = rgb(0, 133, 241)
	static let bordercolor = rgb(49, 52, 61)
	static let placeholdercolor = rgb(155, 155, 155)
	
	static let forgotcolor = rgb(101, 113, 128)
	static let guestcolor = rgb(110, 110, 110)
	static let cencelborder = rgb(66, 83, 104)
    static let canceltext = rgb(170, 170, 170)
	static let errorRed = rgb(226, 103, 100)
    static let titleAlert = rgb(137,137,137)
    static let messageAlert = rgb(137,137,137)
	
	static let kermitGreen = rgb(93, 178, 0)
	static let lightbluenoalpha = rgba(61, 168, 255, 0)
	static let blackalpha = rgba(0, 0, 0, 0.6)
	static let whitegray = rgb(252, 252, 252)
	static let Whitealpha80 = rgba(255, 255, 255, 0.8)
	static let Whitealpha50 = rgba(255, 255, 255, 0.5)
	static let lightblackbg = rgb(52, 52, 52)
	static let lightgraybg = rgb(239, 239, 239)
	static let graycellbg = rgb(162, 162, 162)
	static let darkgraybg = rgb(216, 216, 216)
	static let blackprice = rgb(41, 41, 41)
	static let darkloading = rgba(0, 0, 0, 0.3)
	static let darkbg = rgba(0, 0, 0, 0.25)
	static let darksearchbg = rgba(3, 3, 3, 0.2)
	static let Celllabel = rgb(74, 74, 74)
	static let Cellinformation = rgb(155, 155, 155)
	
	static let placeholderbg = rgb(0.75*255, 0.75*255, 0.75*255)
	
	static let bluesystem = rgb(52, 120, 246)
	
	static let Collectionbg = rgb(225, 225, 225)
	static let separateLine = rgb(235, 235, 235)
	static let endbtn = rgb(255, 121, 118)
	static let star = rgb(219, 208, 78)
	
	static let Exambg = rgb(238, 238, 238)
	static let bt_comment = rgb(197, 135, 198)
	static let bt_practice = rgb(72, 119, 181)
	static let bt_quiz = rgb(219, 84, 79)
	static let str_default = rgb(53, 53, 53)
	static let line = rgb(205, 210, 216)
	static let darkLine = rgb(74, 74, 74)
	static let thememenu = rgb(67, 84, 103)
	static let sepiabg = rgb(245, 239, 223)
	static let sepiaforeground = rgb(112, 66, 20)
	static let darkblue = rgb(67, 84, 103)
	static let popoverbg = rgb(245, 245, 245)
	
	static let segmentline = rgba(200, 200, 200, 150/255)
	static let successgreen = rgb(108, 190, 42)
	
	static let chart_highest = rgb(58, 188, 169)
	static let chart_lowest = rgb(226, 103, 100)
	static let chart_mean = rgb(255, 183, 0)
	static let chart_score = rgb(61, 168, 255)
	static let blackalpha50 = rgba(0, 0, 0, 0.5)
	static let facebook = rgb(71, 89, 147)
	static let greenendexam = rgb(41, 156, 80)
	static let greenpurchase = rgb(41, 156, 80)//rgb(30, 215, 145)
	static let grayiconexam = rgb(113, 127, 144)
	static let greenPurchase = rgb(92, 150, 100)
	static let redPurchase = rgb(196, 59, 68)
	static let weakness_d = rgb(250, 0, 50)
	static let weakness_c = rgb(235, 165, 0)
	static let weakness_b = rgb(15, 180, 140)
	static let weakness_a = rgb(0, 150, 255)
	static let weakness_d_s = rgb(255, 50, 85)
	static let weakness_c_s = rgb(255, 185, 20)
	static let weakness_b_s = rgb(0, 215, 150)
	static let weakness_a_s = rgb(0, 100, 255)
	static let removeRed = rgb(224, 56, 22)
    static let clearBlue = rgb(44, 100, 255)
    static let tomato = rgb(224, 56, 52)
    static let reddishPink = rgb(255, 50, 85)
    static let brownGrey = rgb(155, 155, 155)
    static let greyishBrown = rgb(74, 74, 74)
    static let pinky = rgb(240, 152, 170)
    static let lightRose = rgb(255, 193, 204)
    static let whiteTwo = rgb(255, 250, 250)
    static let statGreen = rgb(24, 171, 27)
	
	static func color(fromHexString: String, alpha: CGFloat = 1.0) -> UIColor {
		// Convert hex string to an integer
		let hexint = Int(colorInteger(fromHexString: fromHexString))
		let red = CGFloat((hexint & 0xff0000) >> 16)
		let green = CGFloat((hexint & 0xff00) >> 8)
		let blue = CGFloat((hexint & 0xff) >> 0)
		
		let color = rgba(red, green, blue, alpha)
		return color
	}
    
    static func blackAlpha(alpha: CGFloat = 1.0) -> UIColor {
        return rgba(0, 0, 0, alpha)
    }
    
    static let alphaBG = UIColor(named: "alphaBG") ?? blackAlpha(alpha: 0.4)
    static let cellWhiteLabel = UIColor(named: "cellWhiteLabel") ?? rgb(255, 255, 255)
    
	static func dark(color :UIColor) -> Bool {
		let componentColors: [CGFloat] = color.cgColor.components!
		if componentColors.count < 4 {
			return componentColors.first == 0 && componentColors.last != 0
		}
		let colorBrightness: CGFloat = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000
		
		return colorBrightness < 0.5
	}
	
}
