//
//  Question.swift
//  ratchakan
//
//  Created by JJsobtid on 24/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

enum QuestionType: String {
	case c4a1 = "C4A1"
	case c5a1 = "C5A1"
	case c5a2 = "C5A2"
	case cna1 = "CNA1"
	case relative = "RELATIVE"
	case fillin = "FILLIN"
	case h99 = "99H"
	case subjective = "SUBJECTIVE"
}

class Question: NSObject {
	var id: String!
	var subject: String!
	var subjectGroup: String!
	var question: String!
	var score: Float!
	var haveFormula: Bool!
	var haveSolution: Bool!
	var haveTool: Bool!
	var tool: String!
	var questionType: QuestionType!
	var order: Int!
	var choices: AnyObject?
	var categories: [String]!
	var language: String!
	var solution: String!
    var videoSolution: String!
	
	var time: Int!
	var timer: Timer?
	
	var isAnswer: Bool!
	var answer: Any?
	
	init(questionData: [String:Any]) {
		
		super.init()
		
		id = Validation.anyIsString(questionData, with: "questionId")
		subject = Validation.anyIsString(questionData, with: "subjectId")
		subjectGroup = Validation.anyIsString(questionData, with: "subjectGroupId")
		question = Validation.anyIsString(questionData, with: "question")
		score = Validation.anyIsFloat(questionData, with: "score")
		haveFormula = Validation.anyIsBool(questionData, with: "haveFormula")
		haveSolution = Validation.anyIsBool(questionData, with: "haveSolution")
		haveTool = Validation.anyIsBool(questionData, with: "haveTool")
		tool = Validation.anyIsString(questionData, with: "questionTool")
		order = Validation.anyIsNumber(questionData, with: "order")
		categories = Validation.anyIsArrayString(questionData, with: "categories")
		questionType = returnQuestionType(type: Validation.anyIsString(questionData, with: "questionType"))
		language = Validation.anyIsString(questionData, with: "language")
		solution = Validation.anyIsString(questionData, with: "questionSolution")
        videoSolution = Validation.anyIsString(questionData, with: "videoSolution")
		time = 0
		
		if questionType == .c4a1 || questionType == .c5a1 || questionType == .c5a2 || questionType == .cna1 {
			var tempChoices: [Choice] = []
			let sortedChoices = Utility.sortArrayOfDictionary(Validation.anyIsArrayAny(questionData, with: "questionChoice"), withInt: "order", ascending: true)
			for choice in sortedChoices {
				tempChoices.append(Choice(choiceData: choice))
			}
			choices = tempChoices as AnyObject
		} else if questionType == .relative {
			var tempChoices: [Int : [Choice]] = [:]
			
		}
		isAnswer = false

	}
	
	fileprivate func returnQuestionType(type: String) -> QuestionType{
		switch type {
		case "C4A1":
			return .c4a1
		case "C5A1":
			return .c5a1
		case "C5A2":
			return .c5a2
		case "CNA1":
			return .cna1
		case "RELATIVE":
			return .relative
		case "FILLIN":
			return .fillin
		case "99H":
			return .h99
		case "SUBJECTIVE":
			return .subjective
		default:
			return .c4a1
		}
	}
	
	func setAnswer(_ select: Any) {
		if questionType == .c4a1 || questionType == .c5a1 || questionType == .cna1 {
			isAnswer = true
			answer = select
		} else if questionType == .c5a2  {
			var answers: [Choice] = answer as? [Choice] ?? []
			let choice = select as! Choice
			if not(answers.contains(choice)) {
				answers.append(choice)
				if answers.count > 2 {
					answers.remove(at: 0)
				}
				if answers.count == 2 {
					isAnswer = true
				}
				answer = answers
			}
		} else if questionType == .relative {
			
		}
	}
	
	func startTime() {
		timer = Timer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
	}
	
	func stopTime() {
		if timer != nil {
			timer!.invalidate()
			timer = nil
		}
	}
	
	@objc func updateTime() {
		time = time + 1
	}
}
