//
//  ExamModel.swift
//  ratchakan
//
//  Created by JJsobtid on 16/7/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class Exam: NSObject {
	var rawData: dictStringAny
	var id, groupId, name, colorHEX, subjectGroup, examGroup, alert, descriptionText: String
	var questionNum, created, updated: Int
	var subjects: [dictStringAny]
	var score, examScore: Float
	var status, free, isDone: Bool
	var tags: [String]
	
	init(withDictionary dict: dictStringAny) {
		rawData = dict
		id = Validation.anyIsString(dict, with: "examId")
		groupId = Validation.anyIsString(dict, with: "examGroupId")
		name = Validation.anyIsString(dict, with: "name")
		colorHEX = Validation.anyIsString(dict, with: "color")
		subjectGroup = Validation.anyIsString(dict, with: "subjectGroup")
		examGroup = Validation.anyIsString(dict, with: "examGroup")
		descriptionText = Validation.anyIsString(dict, with: "description")
		alert = Validation.anyIsString(dict, with: "alert")
		
		questionNum = Validation.anyIsNumber(dict, with: "questionQty")
		created = Validation.anyIsNumber(dict, with: "createdAt")
		updated = Validation.anyIsNumber(dict, with: "updatedAt")
		
		subjects = Validation.anyIsArrayAny(dict, with: "subjects")
		examScore = Validation.anyIsFloat(dict, with: "examScore")
		score = Validation.anyIsFloat(dict, with: "score")
		
		status = Validation.anyIsBool(dict, with: "status")
		free = Validation.anyIsBool(dict, with: "free")
		isDone = Validation.anyIsBool(dict, with: "isDone")
		
		tags = Validation.anyIsArrayString(dict, with: "tags")
	}
}


