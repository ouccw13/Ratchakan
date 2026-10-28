//
//  d.swift
//  ratchakan
//
//  Created by JJsobtid on 7/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit

fileprivate enum Storyboard : String {
	case main = "Main"
	case signin = "SignIn"
}

fileprivate extension UIStoryboard {
	
	static func loadFromMain(_ identifier: String) -> UIViewController {
		return load(from: .main, identifier: identifier)
	}
	// add convenience methods for other storyboards here ...
	
	// ... or use the main loading method directly when instantiating view controller
	// from a specific storyboard
	static func load(from storyboard: Storyboard, identifier: String) -> UIViewController {
		let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
		return uiStoryboard.instantiateViewController(withIdentifier: identifier)
	}
}

// MARK: App View Controllers

extension UIStoryboard {
	static func loadTabBarViewController() -> TabBarViewController {
		return loadFromMain("TabBarViewController") as! TabBarViewController
	}
	
	static func loadSignInViewController() -> SignInViewController {
		return load(from: .signin, identifier: "SignInViewController") as! SignInViewController
	}
}

