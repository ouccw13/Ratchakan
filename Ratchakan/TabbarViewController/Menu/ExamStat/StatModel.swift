//
//  StatModel.swift
//  ratchakan
//
//  Created by JJsobtid on 19/3/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import Foundation

class StatModel: NSObject {

	var subjectGroup: [SubjectGroupModel]
	
	init(_ subjectData: [dictStringAny]) {
		subjectGroup = []
		for subject in subjectData {
			subjectGroup.append(SubjectGroupModel(subject))
		}
	}
}

class SubjectGroupModel: NSObject {
	
	var name: String
    var exams: [SubjectModel]
	var examArray: [SubjectModel]
	
	init(_ data: dictStringAny) {
		name = Validation.anyIsString(data, with: "examGroupName")
        exams = []
		examArray = []
		for exam in Utility.sortArrayOfDictionary(Validation.anyIsArrayAny(data, with: "exams"), withString: "examName", ascending: true) {
			exams.append(SubjectModel(exam))
            let sortExam = exams.sorted{$0.name.localizedStandardCompare($1.name) == .orderedAscending}
           examArray = sortExam
		}
	}
}

class SubjectModel: NSObject {
	
	var name: String
	var memberScore: MemberExamScoreModel!
	var graph: MemberGraphModel!
	var colorHex: String
	
	init(_ data: dictStringAny) {
		name = Validation.anyIsString(data, with: "examName")
		memberScore = MemberExamScoreModel(Validation.anyIsDictionary(data, with: "memberScore"))
		graph = MemberGraphModel(Validation.anyIsDictionary(data, with: "graph"))
		colorHex = Validation.anyIsString(data, with: "color")
	}
}

class MemberExamScoreModel: NSObject {
	
	struct Subject {
		var name: String
		var score: Float
		var categories: [dictStringAny]
		
		init(name: String, score: Float, categories: [dictStringAny]) {
			self.categories = []
			self.name = name
			self.score = score
			for cate in categories {
				self.categories.append(["categoryName" : Validation.anyIsString(cate, with: "categoryName"),
										"score" : Validation.anyIsFloat(cate, with: "scoreP"),
										"categoryScore" : Float(100.0)])
			}
		}
	}
	
	var subjects: [Subject]!
	var score: Float!
	
	init(_ data: dictStringAny) {
		subjects = []
		for subject in Validation.anyIsArrayAny(data, with: "subjects") {
			subjects.append(Subject(name: Validation.anyIsString(subject, with: "subjectName"), score: Validation.anyIsFloat(subject, with: "scoreP"), categories: Validation.anyIsArrayAny(subject, with: "categories")))
		}
		score = Validation.anyIsFloat(data, with: "scoreP")
	}
}

class MemberGraphModel: NSObject {
	
	struct Percent {
		var score: Float
		var id: Int
	}
	
	var count: Int!
	var min, max: Float!
	var percentages: [Percent]!
	
	init(_ data: dictStringAny) {
		percentages = []
		count = Validation.anyIsNumber(data, with: "count")
		min = Validation.anyIsFloat(data, with: "min")
		max = Validation.anyIsFloat(data, with: "max")
		for per in Utility.sortArrayOfDictionary(Validation.anyIsArrayAny(data, with: "percentages"), withInt: "id", ascending: false) {
			percentages.append(Percent(score: Validation.anyIsFloat(per, with: "scoreP"), id: count + 1 - Validation.anyIsNumber(per, with: "id")))
		}
	}
}
