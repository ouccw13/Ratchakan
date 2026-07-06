//
//  BottomButtonModel.swift
//  ratchakan
//
//  Created by JJsobtid on 13/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation
import UIKit

class BottomButton: NSObject {
	var title: String
	var color: UIColor
	
	init(title: String, color: UIColor = .brandcolor1) {
		self.title = title
		self.color = color
	}
	
	func setTitle(_ title: String) {
		self.title = title
	}
}
