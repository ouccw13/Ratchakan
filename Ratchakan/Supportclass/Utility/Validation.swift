//
//  Validation.swift
//  ratchakan
//
//  Created by JJsobtid on 19/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation

class Validation{
	static func dictionary(_ dictionary: [String: Any],with key: String) -> Bool {
		if dictionary[key] != nil {
			if dictionary[key] is NSNull {
				return false
			}
			return true
		}
		return false
	}
	
	static func anyIsString(_ dictionary: [String: Any],with key: String) -> String {
		if Validation.dictionary(dictionary, with: key) {
			return dictionary[key] as? String ?? ""
		}
		return ""
	}
	static func anyIsNumber(_ dictionary: [String: Any],with key: String) -> Int {
		if Validation.dictionary(dictionary, with: key) {
			return dictionary[key] as? Int ?? 0
		}
		return 0
	}
	static func anyIsDouble(_ dictionary: dictStringAny,with key: String) -> Double {
		if Validation.dictionary(dictionary, with: key) {
			return dictionary[key] as? Double ?? 0
		}
		return 0.0
	}
	static func anyIsFloat(_ dictionary: dictStringAny,with key: String) -> Float {
		if Validation.dictionary(dictionary, with: key) {
			let str = String(format: "%.2f", dictionary[key] as? Double ?? dictionary[key] as? Float ?? 0)
			print(str: str)
			return Float(str)!
		}
		return 0.0
	}
	static func anyIsBool(_ dictionary: [String: Any],with key: String) -> Bool {
		if Validation.dictionary(dictionary, with: key) {
			return dictionary[key] as? Bool ?? false
		}
		return false
	}
	static func anyIsDictionary(_ dictionary: [String: Any],with key: String) -> [String: Any] {
		if Validation.dictionary(dictionary, with: key) {
			return dictionary[key] as? [String: Any] ?? [:]
		}
		return [:]
	}
	static func intDictionary(_ dictionary: [Int: String],withInt num: Int) -> String {
		if let str = dictionary[num] {
			return str
		}
		return ""
	}
	static func anyIsArrayString(_ dictionary: [String: Any],with key: String) -> [String] {
		if Validation.dictionary(dictionary, with: key) {
			return dictionary[key] as? [String] ?? []
		}
		return []
	}
	static func anyIsArrayAny(_ dictionary: [String: Any],with key: String) -> [[String: Any]] {
		if Validation.dictionary(dictionary, with: key) {
			return dictionary[key] as? [[String: Any]] ?? []
		}
		return []
	}
	
	static func oldVersion(_ version: String) -> Bool {
		let arrCurrentVersion = Utility.getAppVersion().split(separator: ".").flatMap { Int($0)! }
		let arrRemoteVersion = version.split(separator: ".").flatMap { Int($0)! }
		
		if arrCurrentVersion.count != arrRemoteVersion.count {
			return true
		} else {
			if arrCurrentVersion[0] <= arrRemoteVersion[0] && arrCurrentVersion[1] <= arrRemoteVersion[1] && arrCurrentVersion[2] <= arrRemoteVersion[2] {
				return true
			}
		}
		return false
	}
	
	static func email(_ email: String) -> Bool {
		let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
		let matches = regex.numberOfMatches(in: email, options: .anchored, range: NSRange(location: 0, length: email.count))
		if(matches > 0) {
			return true
		}
		return false
	}
	static func password(_ pass: String) -> Bool {
		let pattern = "^.{8,50}$"
		let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
		let matches = regex.numberOfMatches(in: pass, options: .anchored, range: NSRange(location: 0, length: pass.count))
		if(matches > 0) {
			return true
		}
		return false
	}
	
	static func id(_ id: String) -> Bool {
		let pattern = "^[0-9]{13}$"
		let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
		let matches = regex.numberOfMatches(in: id, options: .anchored, range: NSRange(location: 0, length: id.count))
		if(matches > 0) {
			var ident = CLong(id)
			var chkSum: Int = 0, chkDg: Int = 0
			for i in 0..<13 {
				if i != 0 {
					chkSum += (ident! % 10) * (i+1);
				} else {
					chkDg = ident! % 10;
				}
				ident! /= 10;
			}
			chkSum = (11 - (chkSum%11)) % 10
			if chkSum == chkDg {
				return true
			}
			return false
		}
		return false
	}
	
	static func tel(_ phonenum: String) -> Bool {
		let pattern = "^[0-9\\-\\+]{10,30}$"
		let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
		let matches = regex.numberOfMatches(in: phonenum, options: .anchored, range: NSRange(location: 0, length: phonenum.count))
		if(matches > 0) {
			return true
		}
		return false
	}
	
	func isNumeric(_ number: String) -> Bool {
		let format = NumberFormatter()
		
		if format.number(from: number) != nil {
			return true
		}
		return false
	}

	static func mathMLDetect(_ text: String) -> Bool {
		if text.range(of: "<math") != nil || text.range(of: "<table") != nil || text.range(of: "<img") != nil {
			return true
		}
		return false
	}
}
