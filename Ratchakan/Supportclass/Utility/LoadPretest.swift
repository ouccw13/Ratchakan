//
//  LoadPretest.swift
//  ratchakan
//
//  Created by JJsobtid on 15/3/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import Foundation
import CryptoSwift

class LoadPretest {
	
	static func writePretest(_ id: String, question: String) {
		let pretestPath = "pretest/\(id)"
		
		let file = Filemanager()
		file.createDirectory(directoryname: pretestPath)
		
		let pathArray = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
		let documentDirectory = "\(pathArray[0])/\(pretestPath)"
		var filePath: String
		
		if questionChange(id, newQuestion: question) {
			filePath = documentDirectory.stringByAppendingPathComponent(path: "question.txt")
			do {
				try question.write(toFile: filePath, atomically: true, encoding: .utf8)
			} catch _ as NSError {
				
			}
			filePath = documentDirectory.stringByAppendingPathComponent(path: "answer.txt")
			do {
				try "".write(toFile: filePath, atomically: true, encoding: .utf8)
			} catch _ as NSError {
				
			}
		}
	}
	
	static func questionChange(_ id: String, newQuestion: String) -> Bool {
		let pretestPath = "pretest/\(id)"
		
		let pathArray = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
		let documentDirectory = "\(pathArray[0])/\(pretestPath)"
		let filePath = documentDirectory.stringByAppendingPathComponent(path: "question.txt")
		do {
			let question = try String.init(contentsOfFile: filePath, encoding: .utf8)
			return not(newQuestion == question)
		} catch _ as NSError {
			return true
		}
	}
	
	static func getPretest(_ id: String) -> [Question] {
		let pretestPath = "pretest/\(id)"
		
		let pathArray = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
		let documentDirectory = "\(pathArray[0])/\(pretestPath)"
		let filePath = documentDirectory.stringByAppendingPathComponent(path: "question.txt")
		
		do {
			let question = try String.init(contentsOfFile: filePath, encoding: .utf8)
			do {
				let aes = try AES(key: "FA14DF738AD3B1DC9EA13BD6C748CJD5", iv: "AV8LmxOdzwLbK0nE") // aes128
				let questionData = Data(base64Encoded: question, options: Data.Base64DecodingOptions(rawValue: NSData.Base64DecodingOptions.RawValue(0)))
				let decryptQuestion = try aes.decrypt(Array(questionData!))
				let questionArray = try JSONSerialization.jsonObject(with: Data(bytes: decryptQuestion), options: JSONSerialization.ReadingOptions(rawValue: JSONSerialization.ReadingOptions.RawValue(0))) as! [dictStringAny]
				var questions: [Question] = []
				for question in Utility.sortArrayOfDictionary(questionArray, withInt: "order", ascending: true) {
					questions.append(Question(questionData: question))
				}
				return questions
			} catch { print(error)
				return []
			}
		} catch _ as NSError {
			return []
		}
	}
}
