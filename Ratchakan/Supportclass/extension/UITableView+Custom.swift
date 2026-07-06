//
//  UITableView+Custom.swift
//  ratchakan
//
//  Created by JJsobtid on 12/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
	
	func setParameter(_ bg: UIColor = .clear, separatorColor: UIColor = .clear, showScrollVertical: Bool = false, horizontal: Bool = false, target: Any) {
		backgroundColor = bg
		self.separatorColor = separatorColor
		showsVerticalScrollIndicator = showScrollVertical
		showsHorizontalScrollIndicator = horizontal
		delegate = target as? UITableViewDelegate
		dataSource = target as? UITableViewDataSource
	}
	
	func setDynamicHeight(_ height: CGFloat) {
        rowHeight = UITableView.automaticDimension
		estimatedRowHeight = height
	}
}
