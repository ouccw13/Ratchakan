//
//  HeaderRefreshControl.swift
//  ratchakan
//
//  Created by JJsobtid on 5/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class HeaderRefreshControl: UIRefreshControl {
	
	init(withColor color: UIColor, titleAttribute: NSAttributedString, target: (Any, Selector)) {
		super.init()
		
		tintColor = color
		attributedTitle = titleAttribute
		
		addTarget(target.0, action: target.1, for: .valueChanged)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func beginRefreshing() {
		show()
		super.beginRefreshing()
	}
	
	override func endRefreshing() {
		super.endRefreshing()
		attributedTitle = Utility.setStringAttributes(string.en_pull_refresh, textColor: .brandcolor1, font: .kanitReg14, underline: false)
	}
	
	func setTitleBeginRefreshing() {
		attributedTitle = Utility.setStringAttributes(string.en_loading, textColor: .brandcolor1, font: .kanitReg14, underline: false)
	}
}
