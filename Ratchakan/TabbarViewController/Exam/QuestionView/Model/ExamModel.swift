//
//  ExamModel.swift
//  ratchakan
//
//  Created by JJsobtid on 24/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class ExamModel: NSObject {
	var id: String!
	var name: String!
	var categories: [[String:Any]]!
	var questions: [Question]
	var questionQty: Int!
	var score: Float!
	var coverImage: String!
	var free: Bool!
	var tags: [String]!
	var owner: Bool!
	
	init(data: dictStringAny, questionsData: [dictStringAny]) {
		
		id = Validation.anyIsString(data, with: "examId")
		name = Validation.anyIsString(data, with: "name")
		categories = []
		questions = []
		questionQty = Validation.anyIsNumber(data, with: "questionQty")
		score = Validation.anyIsFloat(data, with: "examScore")
		coverImage = Validation.anyIsString(data, with: "coverImage")
		free = Validation.anyIsBool(data, with: "free")
		owner = false
		tags = Validation.anyIsArrayString(data, with: "tags")
		let sortedQuestions = Utility.sortArrayOfDictionary(questionsData, withInt: "order", ascending: true)
		
		for question in sortedQuestions {
			questions.append(Question(questionData: question))
		}
		super.init()
	}
}
