//
//  UIFont+Size.swift
//  ratchakan
//
//  Created by JJsobtid on 12/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
	fileprivate static func setFont(_ name: String, size: CGFloat) -> UIFont {
		return UIFont(name: name, size: size)!
	}
	
	// MARK: - KANIT
	static let navTitleFont = setFont("Kanit-Regular", size : 20.0)
    //kanit - LIGHT
	static let kanitLight10 = setFont("Kanit-Light", size:10.0)
	static let kanitLight12 = setFont("Kanit-Light", size:12.0)
	static let kanitLight14 = setFont("Kanit-Light", size:14.0)
	static let kanitLight16 = setFont("Kanit-Light", size:16.0)
	static let kanitLight24 = setFont("Kanit-Light", size:24.0)
    // Kanit - REG
    static let kanitReg10 = setFont("Kanit-Regular", size:10.0)
	static let kanitReg12 = setFont("Kanit-Regular", size:12.0)
	static let kanitReg14 = setFont("Kanit-Regular", size:14.0)
	static let kanitReg16 = setFont("Kanit-Regular", size:16.0)
	static let kanitReg18 = setFont("Kanit-Regular", size:18.0)
	static let kanitReg20 = setFont("Kanit-Regular", size:20.0)
    static let kanitReg22 = setFont("Kanit-Regular", size:22.0)
	static let kanitReg32 = setFont("Kanit-Regular", size:32.0)
	static let kanitReg36 = setFont("Kanit-Regular", size:36.0)
	static let kanitReg40 = setFont("Kanit-Regular", size:40.0)
	// kanit - MED
    static let kanitMed10 = setFont("Kanit-Medium", size: 10.0)
	static let kanitMed14 = setFont("Kanit-Medium", size: 14.0)
	static let kanitMed18 = setFont("Kanit-Medium", size: 18.0)
	
	// MARK: - TH SARABUN NEW
    static let thSarabun12 = setFont("THSarabunNew", size: 12.0)
	static let thSarabun18 = setFont("THSarabunNew", size: 18.0)
	static let thSarabun20 = setFont("THSarabunNew", size: 20.0)
	static let thSarabun22 = setFont("THSarabunNew", size: 22.0)
    // thSarabanNew BOLD
	static let thSarabunB22 = setFont("THSarabunNew-Bold", size: 22)
	static let thSarabunBI22 = setFont("THSarabunNew-BoldItalic", size: 22.0)
    
    // MARK: - SARABUN
    // saraban - REG
    static let sarabun12 = setFont("Sarabun-Regular", size: 12.0)
    static let sarabun18 = setFont("Sarabun-Regular", size: 18.0)
    static let sarabun20 = setFont("Sarabun-Regular", size: 20.0)
    static let sarabun22 = setFont("Sarabun-Regular", size: 22.0)
    // saraban - LIGHT
    static let sarabunL12 = setFont("Sarabun-Light", size: 12.0)
    static let sarabunL14 = setFont("Sarabun-Light", size: 14.0)
    // saraban - BOLD
    static let sarabunB22 = setFont("Sarabun-Bold", size: 22)
    static let sarabunBI22 = setFont("Sarabun-BoldItalic", size: 22.0)
}
