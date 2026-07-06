//
//  DatabaseModel.swift
//  ratchakan
//
//  Created by JJsobtid on 22/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class member: Object {
	@objc dynamic var member_id: String = ""
	@objc dynamic var token: String = ""
	@objc dynamic var name: String = ""
	@objc dynamic var surname: String = ""
	@objc dynamic var email: String = ""
    @objc dynamic var phoneNumber: String = ""
	@objc dynamic var birthday: String = ""
	@objc dynamic var gender: String = ""
	@objc dynamic var date_reg: String = ""
	@objc dynamic var profile_picture: String = ""
	@objc dynamic var date_changepassword: String = ""
	@objc dynamic var plan_expire: String = "0"
	@objc dynamic var time_noti: String = "06:00:00"
	@objc dynamic var first_of_date: String = ""
//    @objc dynamic var fieldLogin: String = ""
	var packages = List<Packages>()
	
	override static func primaryKey() -> String? {
		return "member_id"
	}
	
	override var description: String { return "member {\(member_id), \(name) \(surname), \(plan_expire), \(birthday), \(time_noti)}" }
	
	func returnJSON() -> [String:Any] {
		return ["memberId": member_id,
				"token": token,
				"name": name,
				"surname": surname,
				"displayName": "\(name) \(surname)",
				"email": email,
                "phoneNumber": phoneNumber,
				"birthday": birthday,
				"gender": gender,
				"createAt": date_reg,
				"profileImage": profile_picture,
				"date_changepassword": date_changepassword,
				"plan_expire": plan_expire,
				"time_noti": time_noti,
				"first_of_daye": first_of_date,
//                "fieldLogin": fieldLogin,
				"packages" : listToDict()]
	}
	
	fileprivate func listToDict() -> dictStringAny {
		var package: [String:Int] = [:]
		for pack in packages {
			package[pack.examId] = pack.endDate
		}
		return package
	}
	
	func updateFrom(dictionary: [String:AnyObject]) {
		name = dictionary["name"] as! String
		surname = dictionary["surname"] as! String
		email = dictionary["email"] as? String ?? "" /*?? (dictionary["phoneNumber"] as? String ?? "")!*/
        phoneNumber = dictionary["phoneNumber"] as? String ?? ""
		if let birthday = dictionary["birthday"] {
			self.birthday = birthday as! String
		}
		for package in Validation.anyIsDictionary(dictionary, with: "packages") {
			let pack = Packages()
			pack.examId = package.key
			pack.endDate = Validation.anyIsNumber(package.value as! dictStringAny, with: "endDate")
			packages.append(pack)
		}
		if Validation.dictionary(dictionary, with: "gender") { gender = dictionary["gender"] as! String }
		if Validation.dictionary(dictionary, with: "date_reg") { date_reg = "\(dictionary["date_reg"] as! Int)" }
		if Validation.dictionary(dictionary, with: "profile_picture") { profile_picture = dictionary["profile_picture"] as! String }
		if Validation.dictionary(dictionary, with: "date_changepassword") { date_changepassword = "\(dictionary["date_changepassword"] as! Int)" }
	}
	
	func updateFrom(member: member) {
		name = member.name
		surname = member.surname
		email = member.email
        phoneNumber = member.phoneNumber
		birthday = member.birthday
		gender = member.gender
		date_reg = member.date_reg
		profile_picture = member.profile_picture
		date_changepassword = member.date_changepassword
		packages = member.packages
	}
	
	func updateProfile(image: String) {
		profile_picture = image
	}
}

class Packages: Object {
	
	@objc dynamic var examId: String = ""
	@objc dynamic var endDate: Int = 0
	
	override static func primaryKey() -> String? {
		return "examId"
	}
	
	func returnJSON() -> [String:Any] {
		return ["examId": examId,
				"endDate": endDate]
	}
	
}

class screen_capture: Object {
	@objc dynamic var num: String = ""
	@objc dynamic var date: String = ""
	
	func returnJSON() -> [String:String] {
		return ["num": num,
				"date": date]
	}
	
}

class Theme: Object {
	@objc dynamic var theme: Int = 0
	
	func returnJSON() -> [String:Int] {
		return ["theme": theme]
	}
}

class AppleSignInResponse: Object {
    @objc dynamic var clientSecret: String = ""
    @objc dynamic var appleToken: String = ""
    @objc dynamic var authorizationcode: String = ""
    @objc dynamic var userIdentifier_appleid: String = ""
    
    func returnJSON() -> [String:String] {
        return ["clientSecret": clientSecret,
                "appleToken": appleToken,
                "authorizationcode": authorizationcode,
                "userIdentifier_appleid": userIdentifier_appleid
        ]
    }
    
}
