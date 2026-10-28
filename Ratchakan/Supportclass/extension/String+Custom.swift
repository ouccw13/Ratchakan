//
//  String+Custom.swift
//  ratchakan
//
//  Created by JJsobtid on 13/12/2560 BE.
//  Copyright © 2560 JJsobtid. All rights reserved.
//

import Foundation
import CryptoSwift

extension String {
	func stringByAppendingPathComponent1(path: String) -> String {
		let nsSt = self as NSString
		return nsSt.appendingPathComponent(path)
	}
	
	func lastPathComponent() -> String {
		return (self as NSString).lastPathComponent
	}
//	var lastPathComponent: String {
//		return (self as NSString).lastPathComponent
//	}
	var pathExtension: String {
		return (self as NSString).pathExtension
	}
	var stringByDeletingLastPathComponent: String {
		return (self as NSString).deletingLastPathComponent
	}
	var stringByDeletingPathExtension: String {
		return (self as NSString).deletingPathExtension
	}
	var pathComponents: [String] {
		return (self as NSString).pathComponents
	}
	func stringByAppendingPathComponent(path: String) -> String {
		let nsSt = self as NSString
		return nsSt.appendingPathComponent(path)
	}
	func stringByAppendingPathExtension(ext: String) -> String? {
		let nsSt = self as NSString
		return nsSt.appendingPathExtension(ext)
	}
	
	func genPassword() -> String {
		let hashPass = "\(self.md5())@sobtid.me".md5()
		return hashPass
	}
	func hashMemberID(key: String) -> String {
		let hash = "\(self)|\(key)".md5()
		return hash
	}
	
	func genderThai() -> String {
		if self == "male" {
			return "ชาย"
		} else if self == "female" {
			return "หญิง"
		}
		return "ไม่ระบุ"
	}
	
	func trimSpace() -> String {
		return self.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	func substring(from: Int? = nil, to: Int? = nil) -> String {
		let template = self
		var indexStartOfText = template.index(template.startIndex, offsetBy: 0)
		var indexEndOfText = template.index(template.endIndex, offsetBy: 0)
		if from != nil {
			indexStartOfText = template.index(template.startIndex, offsetBy: from!)
		}
		if to != nil {
			indexEndOfText = template.index(template.endIndex, offsetBy: -(to!))
		}
		// Swift 4
		return String(template[indexStartOfText..<indexEndOfText])
	}
	
	func addPrefixHTTP() -> String {
		var url = self
		if not(self.hasPrefix("http")) {
			url = "https://" + self
		}
		return url
	}
	
	func removePTag() -> String {
		var str = self
		str = str.replacingOccurrences(of: "<p></p>", with: "")
		str = str.replacingOccurrences(of: "<p> </p>", with: "")
		str = str.replacingOccurrences(of: "<p>", with: "")
		str = str.replacingOccurrences(of: "</p>", with: "")
		
		return str
	}
	func removeHtmlTag() -> String {
		var str = self
		
		str = str.removePTag()
		str = str.removeHtmlTagWithP()
		
		return str
	}
	
	func removeHtmlTagWithP() -> String {
		var str = self
		
		str = str.replacingOccurrences(of: "<br>", with: "")
		str = str.replacingOccurrences(of: "<br />", with: "")
		str = str.replacingOccurrences(of: "<li>", with: "")
		str = str.replacingOccurrences(of: "</li>", with: "")
		str = str.replacingOccurrences(of: "&nbsp;", with: " ")
		str = str.replacingOccurrences(of: "&ndash;", with: "-")
		str = str.replacingOccurrences(of: "&amp;", with: "&")
		str = str.replacingOccurrences(of: "&lt;", with: "<")
		str = str.replacingOccurrences(of: "&gt;", with: ">")
		str = str.replacingOccurrences(of: "&quot;", with: "\"")
		str = str.replacingOccurrences(of: "&apos;", with: "'")
		str = str.replacingOccurrences(of: "<ins>", with: "<u>")
		str = str.replacingOccurrences(of: "</ins>", with: "</u>")
		
		return str
	}
	
	func findFirstCloseBracket(insertText: String) -> String {
		let substring = ">"
		var str = self
		var index = 0
		for char in self {
			if substring.first == char {
				// Create a start and end index to ultimately creata range
				//
				// Hello Agnosticdev, I love Tutorials
				//       6   ->   17 - rage of substring from 7 to 18
				//
				let startOfFoundCharacter = self.index(self.startIndex, offsetBy: index)
				let lengthOfFoundCharacter = self.index(self.startIndex, offsetBy: (substring.count + index))
				let range = startOfFoundCharacter..<lengthOfFoundCharacter
				
				// Grab the substring from the parent string and compare it against substring
				// Essentially, looking for the needle in a haystack
				if self.substring(with: range) == substring {
					str.insert(contentsOf: insertText, at: lengthOfFoundCharacter)
					break
				}
				
			}
			index += 1
		}
		return str
	}
	
	func phoneNumber() -> String {
		let tempPhoneIndex = self.index(after: self.startIndex)
		let phone = (self.prefix(1) == "0" ? "+66\(self[tempPhoneIndex...])" : self)
		return phone.trimSpace()
	}
	
	func inserting(separator: String, every n: Int) -> String {
		var result: String = ""
        let characters = Array(self)
		stride(from: 0, to: characters.count, by: n).forEach {
			result += String(characters[$0..<min($0+n, characters.count)])
			if $0+n < characters.count {
				result += separator
			}
		}
		return result
	}
	func replacing(at index: Int, with newChar: Character) -> String {
		var chars = Array(self)     // gets an array of characters
		chars[index] = newChar
		let modifiedString = String(chars)
		return modifiedString
	}
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)

        return ceil(boundingBox.width)
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    func base64Encoded() -> String? {
        data(using: .utf8)?.base64EncodedString()
    }
    
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
