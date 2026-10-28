//
//  UINib+Loader.swift
//  ratchakan
//
//  Created by JJsobtid on 6/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit

fileprivate extension UINib {
	
	static func nib(named nibName: String) -> UINib {
		return UINib(nibName: nibName, bundle: nil)
	}
	
	static func loadSingleView(_ nibName: String, owner: Any?) -> UIView {
		return nib(named: nibName).instantiate(withOwner: owner, options: nil)[0] as! UIView
	}
}

// MARK: App Views

extension UINib {
	class func loadCustomNav(_ owner: AnyObject) -> UIView {
		return loadSingleView("CustomNav", owner: owner)
	}
	
	class func loadBottomButton(_ owner: AnyObject) -> UIView {
		return loadSingleView("CustomBottomButton", owner: owner)
	}
}
