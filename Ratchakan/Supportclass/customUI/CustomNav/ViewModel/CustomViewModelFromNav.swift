//
//  CustomViewModelFromNav.swift
//  ratchakan
//
//  Created by JJsobtid on 7/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit

class CustomViewModelFromNav: NSObject, CustomNavViewModel {
	let nav: Nav
	
	var titleName: String
	var left: Bool
	var right: Bool
	var imageRight: String?
	
	var color: UIColor
	
	init(withNav nav: Nav) {
		self.nav = nav
		
		self.titleName = nav.title
		self.left = nav.left
		self.right = nav.right
		self.imageRight = nav.imageRight
		self.color = nav.color
		
		super.init()
	}
}
