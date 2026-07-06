//
//  File.swift
//  ratchakan
//
//  Created by JJsobtid on 6/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation
import UIKit

class Nav: NSObject {
	var title: String
	var left: Bool
	var right: Bool
	var imageRight: String?
	
	var color: UIColor
	
	init(title: String, isBack: Bool, isRight: Bool, imageRight: String? = "", color: UIColor = .brandcolor1) {
		self.title = title
		self.left = isBack
		self.right = isRight
		if(isRight) {
			self.imageRight = imageRight
		}
		self.color = color
	}
}
