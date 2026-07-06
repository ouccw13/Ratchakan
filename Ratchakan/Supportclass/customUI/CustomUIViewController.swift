//
//  CustomUIViewController.swift
//  ratchakan
//
//  Created by JJsobtid on 10/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class CustomUIViewControllerWithNav: UIViewController {

	override var preferredStatusBarStyle: UIStatusBarStyle {
		if UIColor.dark(color: .navbrandcolor) {
			return .lightContent
		} else {
			return .default
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.isNavigationBarHidden = true
		navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
		
		Utility.statusBar(color: .clear)
		tabBarController?.tabBar.isHidden = false
	}

}

class CustomUIViewControllerNoNav: UIViewController {

	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
//		self.navigationController?.isNavigationBarHidden = true
//		tabBarController?.tabBar.isHidden = false
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.navigationController?.isNavigationBarHidden = true
		tabBarController?.tabBar.isHidden = false
	}
	
}

class CustomUIViewControllerNoNavNoTabbar: UIViewController {
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		//		self.navigationController?.isNavigationBarHidden = true
		//		tabBarController?.tabBar.isHidden = false
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		self.navigationController?.isNavigationBarHidden = true
		tabBarController?.tabBar.isHidden = true
	}
	
}

class CustomViewControllerPresentNavAndNoTabbar: UIViewController {
	override var preferredStatusBarStyle: UIStatusBarStyle {
		if UIColor.dark(color: .navbrandcolor) {
			return .lightContent
		} else {
			return .default
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		navigationController?.isNavigationBarHidden = true
		navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
		tabBarController?.tabBar.isHidden = true
	}
	
//	override func viewDidAppear(_ animated: Bool) {
//		<#code#>
//	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

class CustomViewControllerPushNavAndNoTabbar: CustomViewControllerPresentNavAndNoTabbar {
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		navigationController?.isNavigationBarHidden = true
		navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
		navigationController?.interactivePopGestureRecognizer?.isEnabled = true

		tabBarController?.tabBar.isHidden = true
	}
}
