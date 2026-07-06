//
//  CustomBottomButtonFromMedel.swift
//  ratchakan
//
//  Created by JJsobtid on 13/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit

class CustomBottomButtonFromModel: NSObject, CustomBottomButtonViewModel {
	let button: BottomButton
	
	var title: Dynamic<String>
	var color: UIColor
	
	init(withButton button: BottomButton) {
		self.button = button
		
		self.title = Dynamic(button.title)
		self.color = button.color
		
		super.init()
	}
	
	func changeTitle(_ title: String) {
		button.setTitle(title)
		self.title.value = button.title
	}
}

