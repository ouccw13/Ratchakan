//
//  UIImageView+Custom.swift
//  ratchakan
//
//  Created by JJsobtid on 15/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
	
    func setParameter(name: String, mode: UIView.ContentMode) {
		image = UIImage(named: name)
		contentMode = mode
	}
    
    func setImageColor(color: UIColor) {
      let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
      self.image = templateImage
      self.tintColor = color
    }
	
}
