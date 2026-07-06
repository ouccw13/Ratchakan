//
//  UIImage+Custom.swift
//  ratchakan
//
//  Created by JJsobtid on 1/8/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

extension CGImage {
	var isDark: Bool {
		get {
			guard let imageData = self.dataProvider?.data else { return false }
			guard let ptr = CFDataGetBytePtr(imageData) else { return false }
			let length = CFDataGetLength(imageData)
			let threshold = Int(Double(self.width * self.height) * 0.45)
			var darkPixels = 0
			for i in stride(from: 0, to: length, by: 4) {
				let r = ptr[i]
				let g = ptr[i + 1]
				let b = ptr[i + 2]
				let luminance = (0.299 * Double(r) + 0.587 * Double(g) + 0.114 * Double(b))
				if luminance < 150 {
					darkPixels += 1
					if darkPixels > threshold {
						return true
					}
				}
			}
			return false
		}
	}
}

extension UIImage {
	var isDark: Bool {
		get {
			return self.cgImage?.isDark ?? false
		}
	}
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
}

