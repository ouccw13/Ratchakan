//
//  EnumData.swift
//  ratchakan
//
//  Created by JJsobtid on 11/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import Foundation

enum NotiCenter {
	static let checkLogIn = "login"
	static let logOut = "logout"
	static let purchaseComplete = "purchase"
}
enum MenuGroupType {
	case profile
	case userData
	case contactMe
	case noti
	case logOut
	case logIn
}
enum MenuCellType {
	case profile
	
	case vip
	case editUserData
	case statTest
	case historyTest
	case historyPurchase
	
	case tel
	case help
	case version
    case termOfCondition
    case privacy
    case deleteAccount
	
	case noti
	case logout
	case login
}
enum ContactList: String {
	case company = "Company Name"
	case tel = "Tel."
	case email = "Email"
	case line = "Line"
	case instagram = "Instagram"
	case facebook = "Facebook"
	case twitter = "Twitter"
	
	static func hash(type: ContactList) -> Int {
		switch type {
		case .company:
			return 0
		case .tel:
			return 1
		case .email:
			return 2
		case .line:
			return 3
		case .instagram:
			return 4
		case .facebook:
			return 5
		case .twitter:
			return 6
        default:
            return 0
		}
	}
}
enum UserData: String {
	case name = "ชื่อ"
	case email = "อีเมล"
	case phone = "เบอร์โทรศัพท์"
	case password = "รหัสผ่าน"
	case birthday = "วันเกิด"
	case gender = "เพศ"
	
	case firstname = "ชื่อจริง"
	case surname = "นามสกุล"
	case oldpassword = "รหัสผ่านเดิม"
	case newpassword = "รหัสผ่านใหม่"
	case confirmpass = "ยืนยันรหัสผ่าน"
	
	static func hash(type: UserData) -> Int {
		switch type {
		case .name:
			return 0
		case .email:
			return 1
		case .phone:
			return 2
		case .password:
			return 3
		case .birthday:
			return 4
		case .gender:
			return 5
		case .firstname:
			return 6
		case .surname:
			return 7
		case .oldpassword:
			return 8
		case .confirmpass:
			return 9
		default:
			return 0
		}
	}
}

enum ExamTheme {
	case normal
	case sepia
	case darkblue
	case night
}

enum PurchaseType: Int {
	case omise = 1
	case mol = 2
	case counterService = 4
	case inapp = 5
	case free = 7
//	OMISE: 1, MOL: 2, COUNTER_SERVICE: 4, IN_APP: 5, FREE: 7
}
