//
//  UITextField+Custom.swift
//  ratchakan
//
//  Created by JJsobtid on 20/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import UIKit

extension UITextField {
	
	func regisType(placeholder: String, isSecure: Bool = false, tag: Int, target: Any?, selector: Selector) {
		self.font = UIFont.kanitLight16
		self.placeholder = placeholder
        self.textColor = .Celllabel
        if #available(iOS 13.0, *) {
            self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.placeholdercolor])
        }
		self.isSecureTextEntry = isSecure
		self.tag = tag
		self.delegate = target as? UITextFieldDelegate
		self.addTarget(target, action: selector, for: .editingChanged)
	}

	func underline(in view: UIView, error: Bool = false, color: UIColor = .darkgraybg) {
		for subview in view.subviews {
			if subview.accessibilityIdentifier == "underline" {
				if (text?.isEmpty)! || error {
					UIView.animate(withDuration: 0.3, animations: {
						subview.layer.backgroundColor = UIColor.errorRed.cgColor
					})
				} else {
					UIView.animate(withDuration: 0.3, animations: {
						subview.layer.backgroundColor = color.cgColor
					})
				}
			}
		}
	}
}
