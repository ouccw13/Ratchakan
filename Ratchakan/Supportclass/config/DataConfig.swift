//
//  File.swift
//  ratchakan
//
//  Created by JJsobtid on 20/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation
import UIKit

typealias dictStringAny = [String:Any]

let myAppID = 1358182696 //1191038395

class DataConfig {
	
	static let numberTH = ["๐", "๑", "๒", "๓", "๔", "๕", "๖", "๗", "๘", "๙"]
	static let weekday = ["อาทิตย์", "จันทร์", "อังคาร", "พุธ", "พฤหัสบดี", "ศุกร์", "เสาร์"]
	static let month = ["มกราคม", "กุมภาพันธ์", "มีนาคม", "เมษายน", "พฤษภาคม", "มิถุนายน", "กรกฎาคม", "สิงหาคม", "กันยายน", "ตุลาคม", "พฤศจิกายน", "ธันวาคม"]
	static let shortMonth = ["ม.ค.", "ก.พ.", "มี.ค.", "เม.ย.", "พ.ค.", "มิ.ย.", "ก.ค.", "ส.ค.", "ก.ย.", "ต.ค.", "พ.ย.", "ธ.ค."]
	
	// MARK: REGISTER FORM
	static let formRegis = [["key":FieldType.email, "iconImage":#imageLiteral(resourceName: "emailIcon"), "placeholder":"อีเมลหรือเบอร์โทรศัพท์"],
							["key":FieldType.password, "iconImage":#imageLiteral(resourceName: "passIcon"), "placeholder":string.th_password],
							["key":FieldType.name, "iconImage":#imageLiteral(resourceName: "detailIcon"), "placeholder":string.th_name],
							["key":FieldType.surname, "iconImage":#imageLiteral(resourceName: "detailIcon"), "placeholder":string.th_surname],
							["key":FieldType.gender, "iconImage":#imageLiteral(resourceName: "genderIcon"), "placeholder":string.th_gender],
							["key":FieldType.birthday, "iconImage":#imageLiteral(resourceName: "birthdayIcon"), "placeholder":string.th_birthday]
							]

	// MARK: PRETEST FORM
	static let formPretest = [string.th_name, string.th_surname/*, string.th_identifier*/, string.th_phone_number, string.th_email]
	static let sizeFormPretest: [CGFloat] = [16.0, 48.0, 122.0, 75.0, 29.0]
	
	// MARK: MENU CELL
	static let cellGuestProfile = ["key": MenuCellType.profile, "title": "SOBTID GUEST", "imageName": "vipIcon", "detail": string.th_pls_login] as [String : Any]
	
	static let cellEditProfile = ["key": MenuCellType.editUserData, "title": string.th_edit_user, "imageName": "editProfileIcon"] as [String : Any]
	static let cellStatTest = ["key" : MenuCellType.statTest, "title": string.th_test_stats, "imageName": "statIcon"] as [String : Any]
	static let cellHistoryTest = ["key" : MenuCellType.historyTest, "title": string.th_test_history, "imageName": "historyIcon"] as [String : Any]
	static let cellHistoryPur = ["key" : MenuCellType.historyPurchase, "title": string.th_purchase_history, "imageName": "historyIcon"] as [String : Any]
	
	static let cellVIP = ["key" : MenuCellType.vip, "title": string.th_vip, "imageName": "vipIcon"] as [String : Any]
	static let cellTel = ["key" : MenuCellType.tel, "title": string.th_contactUs, "imageName": "contactIcon"] as [String : Any]
	static let cellHelp = ["key" : MenuCellType.help, "title": string.th_helpUs, "imageName": "helpIcon"] as [String : Any]
	static let cellVersion = ["key" : MenuCellType.version, "title": string.th_version, "imageName": "versionIcon", "detail": Utility.getAppVersion()] as [String : Any]
    static let cellTermOfCondition = ["key": MenuCellType.termOfCondition, "title": string.th_condition,"imageName": "versionIcon"] as [String : Any]
    static let cellPrivacy = ["key": MenuCellType.privacy, "title": string.th_privacy,"imageName": "versionIcon"] as [String : Any]
    static let cellDeleteAccount = ["key": MenuCellType.deleteAccount, "title": string.th_deleteAccount, "imageName": "deleteIcon"] as [String:Any]
	static let cellNoti = ["key" : MenuCellType.noti, "title": string.th_noti, "imageName": "notiIcon"] as [String : Any]
    /*static let cellRevokedAppleID = ["key" : MenuCellType.revokedAppleID, "title": string.th_revoked_AppleID, "imageName": "signWithApple"] as [String : Any]*/
	static let cellLogout = ["key" : MenuCellType.logout, "title": string.th_log_out, "imageName": "logoutIcon"] as [String : Any]
	static let cellLogin = ["key" : MenuCellType.login, "title": string.th_login, "imageName": "loginIcon"] as [String : Any]
	
	//MARK: MENU DATA
    static let ratchakanAppMenuSectionI = [cellEditProfile,cellVIP,cellStatTest,cellHistoryTest,cellHistoryPur]
	static let lastCellSectionMenu: [MenuCellType] = [.profile, .historyPurchase, .version, .noti, .logout, .login]
    static let nonUserInteraction: [MenuCellType] = [.profile, .version, .noti]
	static let tableUserMenu = [["key" : MenuGroupType.profile,
								 "cell": [cellGuestProfile]],
								["key" : MenuGroupType.userData,
								 "cell": [cellEditProfile, cellVIP, cellStatTest, cellHistoryTest, cellHistoryPur]],
								["key" : MenuGroupType.contactMe,
								 "cell": [/*cellTel, cellHelp,*/ cellVersion]],
                               /* ["key" : MenuGroupType.revokedAppleID,
                                 "cell" : [cellRevokedAppleID]],*/
								["key" : MenuGroupType.logOut,
								 "cell" : [cellLogout]]]
	static let tableUserMenuTell = [["key" : MenuGroupType.profile,
									 "cell": [cellGuestProfile]],
									["key" : MenuGroupType.userData,
									 "cell": [cellEditProfile, cellVIP, cellStatTest, cellHistoryTest, cellHistoryPur]],
									["key" : MenuGroupType.contactMe,
									 "cell": [cellTel,/* cellHelp,*/ cellVersion,cellTermOfCondition,cellPrivacy,cellDeleteAccount]],
//                                    ["key" : MenuGroupType.revokedAppleID,
//                                     "cell" : [cellRevokedAppleID]],
									["key" : MenuGroupType.logOut,
									 "cell" : [cellLogout]]]
	
	static let tableGuestMenu = [["key" : MenuGroupType.profile,
								  "cell": [cellGuestProfile]],
								 ["key" : MenuGroupType.contactMe,
								  "cell": [cellVIP/*, cellTel, cellHelp*/, cellVersion,cellTermOfCondition,cellPrivacy]],
								 ["key" : MenuGroupType.logIn,
								  "cell": [cellLogin]]]
	static let tableGuestMenuTell = [["key" : MenuGroupType.profile,
									  "cell": [cellGuestProfile]],
									 ["key" : MenuGroupType.contactMe,
									  "cell": [cellVIP, cellTel/*, cellHelp*/, cellVersion, cellTermOfCondition,cellPrivacy]],
									 ["key" : MenuGroupType.logIn,
									  "cell": [cellLogin]]]
	
	static let contactInfo: [Int : (type : ContactList , key : String)] = [0 :(.company, ""), 1 : (.tel , "tel"), 2 : (.email, "email"), 3 : (.line, "line"), 4 : (.instagram, "instagram"), 5 : (.facebook, "facebook"), 6 : (.twitter, "twitterId") ]
	
    static let editUser: [Int : (type: UserData , key : String)] = [0 : (.name, /*"displayName"*/string.th_name), 1 : (.email, string.th_email/*"email"*/), 2 : (.phone, string.th_phone_number/*"phoneNumber"*/), 3 : (.password, string.th_password), 4 : (.birthday, string.th_birthday/*"birthday"*/), 5 : (.gender, string.th_gender/*"gender"*/)]
	
	static let editNameUser: [Int: (type: UserData, key: String)] = [0 : (.firstname, "name"), 1 : (.surname, "surname")]
	static let editPassUser: [Int: (type: UserData, key: String)] = [0 : (.oldpassword, "oldPassword"), 1 : (.newpassword, "newPassword"), 2 : (.confirmpass, "password")]
	static let editEmailUser: [Int: (type: UserData, key: String)] = [0 : (.email, "email")]
	
	static let genderData = ["male", "female", "unknown"]
	static let typePayment: [Int: String] = [1 : "Credit Card",
											 2 : "MOL",
											 4 : "Counter Service",
											 5 : "In-app Purchase",
											 6 : "Redeem",
											 7 : "Free",
											 8 : "Line Pay"]
	
	static let timeReminderCalendar: [Double] = [60*60, 60*60*24]
	static let timeReminderPretest: [Double] = [30*60, 60*60*24]
}
