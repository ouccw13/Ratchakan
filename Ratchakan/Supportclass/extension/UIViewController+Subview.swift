//
//  UIViewController+Subview.swift
//  ratchakan
//
//  Created by JJsobtid on 7/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit

extension UIViewController {
	
	func insertChildController(_ childController: UIViewController, intoParentView parentView: UIView) {
        childController.willMove(toParent: self)
		
        self.addChild(childController)
		childController.view.frame = parentView.bounds
		parentView.addSubview(childController.view)
		
        childController.didMove(toParent: self)
	}
	
	func insertChildController(_ childController: UIViewController, intoParentView parentView: UIView, withFrame frame: CGRect) {
        childController.willMove(toParent: self)
		
        self.addChild(childController)
		childController.view.frame = frame
		parentView.addSubview(childController.view)
		
        childController.didMove(toParent: self)
	}
	
	func insertChildController(_ childController: UIViewController, intoParentView parentView: UIView, below: UIView, withFrame frame: CGRect) {
        childController.willMove(toParent: self)
		
        self.addChild(childController)
		childController.view.frame = frame
		parentView.insertSubview(childController.view, belowSubview: below)
		
        childController.didMove(toParent: self)
	}
	
	func removeChildController(_ childController: UIViewController, outofParentView parentView: UIView) {
        childController.willMove(toParent: self)
		
        childController.removeFromParent()
		
	}
	
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
	
	func moveViewWhenKeyboradAppear() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	func listenNotiLogInOut(_ selector: Selector) {
		NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: NotiCenter.checkLogIn), object: nil)
		NotificationCenter.default.addObserver(self, selector: selector, name: NSNotification.Name(rawValue: NotiCenter.logOut), object: nil)
	}
	func listenNotiCapScreen(_ selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: UIApplication.userDidTakeScreenshotNotification, object: nil)
	}
	func viewDisappear() {
		NotificationCenter.default.removeObserver(self)
	}
	
	@objc func keyboardWillShow(notification: NSNotification) {
//		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//			if view.frame.origin.y == 0{
//				view.frame.origin.y -= keyboardSize.height
//			}
//		}
	}
	
	func moveViewKeyboardShow() {
		if view.frame.origin.y == 0{
			view.frame.origin.y -= KEYBOARD_HEIGHT
		}
	}
	@objc func keyboardWillHide(notification: NSNotification) {
//		if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
			if view.frame.origin.y < 0{
				moveViewDown()
			}
//		}
	}
	
	func moveViewUp(_ height: CGFloat = 0) {
		if view.frame.origin.y == 0 {
			animateMoveView(y: view.frame.origin.y - height)
//			view.frame.origin.y -= height
		} else {
			animateMoveView(y: -height)
		}
	}
	
	func moveViewDown() {
		animateMoveView(y: 0)
//		view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.width, height: SCREEN_HEIGHT)
	}
	
	func animateMoveView(y: CGFloat) {
		UIView.animate(withDuration: TIME_ANIMATE_COLOR_C) {
			self.view.frame.origin.y = y
		}
	}
	
	func checkOverlab(_ overlab: (Bool, CGFloat)) {
		if overlab.0 {
			moveViewUp(overlab.1)
		} else {
			moveViewDown()
		}
	}
	
	func separateLineIPad() {

		if IS_IPAD {
			let leftLine = UIView()
			leftLine.backgroundColor = .guestcolor
			
			view.addSubview(leftLine)
			leftLine.snp.makeConstraints({ (make) in
				make.top.equalTo(0)
				make.bottom.equalTo(SCREEN_HEIGHT)
				make.leading.equalTo(0)
				make.width.equalTo(0.5)
			})
		}
	}
	
	func hideTabBar() {
		if var frame = self.tabBarController?.tabBar.frame {
			frame.origin.y = self.view.frame.size.height + frame.size.height
			UIView.animate(withDuration: 0.5, animations: {
				self.tabBarController?.tabBar.frame = frame
			})
		}
	}
	
	func showTabBar() {
		if var frame = self.tabBarController?.tabBar.frame {
			frame.origin.y = self.view.frame.size.height - frame.size.height
			UIView.animate(withDuration: 0.5, animations: {
				self.tabBarController?.tabBar.frame = frame
			})
		}
	}
}
