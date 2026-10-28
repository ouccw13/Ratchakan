//
//  UIWindow+Custom.swift
//  ratchakan
//
//  Created by JJsobtid on 12/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit

extension UIWindow {
	
	func visibleViewController() -> UIViewController? {
		if let rootViewController: UIViewController = self.rootViewController {
			return UIWindow.getVisibleViewControllerFrom(rootViewController)
		}
		return nil
	}
	
	class func getVisibleViewControllerFrom(_ vc:UIViewController) -> UIViewController {
		
		if vc.isKind(of: UINavigationController.self) {
			
			let navigationController = vc as! UINavigationController
			return UIWindow.getVisibleViewControllerFrom( navigationController.visibleViewController! )
			
		} else if vc.isKind(of: UITabBarController.self) {
			
			let tabBarController = vc as! UITabBarController
			return UIWindow.getVisibleViewControllerFrom(tabBarController.selectedViewController!)
			
		} else {
			
			if let presentedViewController = vc.presentedViewController {

				return UIWindow.getVisibleViewControllerFrom(presentedViewController)
				
			} else {
				
				return vc;
			}
		}
	}
}
