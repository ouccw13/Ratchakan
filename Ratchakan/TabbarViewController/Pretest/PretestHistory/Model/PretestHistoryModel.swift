//
//  PretestHistoryModel.swift
//  ratchakan
//
//  Created by JJsobtid on 12/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

enum PretestOnlineStatus {
	case add
	case delete
}

class PretestHistoryModel: NSObject {

	var rawData: dictStringAny
	var pretestId, answerId, typeName, timeToShow, dateToShow: String
	var isPractice, isPass: Bool
	var score, totalScore: Float
	var type, totalTime, submissDate: Int
	var memberScore: dictStringAny
	var subjectData: [dictStringAny]
	var memberStat: PretestSummaryModel
	
	init(withData data: dictStringAny) {
		rawData = data
		pretestId = Validation.anyIsString(data, with: "pretestId")
		answerId = Validation.anyIsString(data, with: "answerId")
		type = Validation.anyIsNumber(data, with: "type")
		isPractice = type == 0
		typeName = Validation.anyIsString(data, with: "typeName")
		isPass = Validation.anyIsBool(data, with: "isPass")
		score = Validation.anyIsFloat(data, with: "score")
		totalScore = Validation.anyIsFloat(data, with: "totalScore")
		totalTime = Validation.anyIsNumber(data, with: "totalTime")
		timeToShow = Validation.anyIsString(data, with: "totalTimeFormat")
		submissDate = Validation.anyIsNumber(data, with: "submissionDate")
		dateToShow = Validation.anyIsString(data, with: "submissionDateFormat")
		memberScore = Validation.anyIsDictionary(data, with: "memberScore")
		subjectData = Validation.anyIsArrayAny(memberScore, with: "subjects")
		memberStat = PretestSummaryModel(withData: Validation.anyIsDictionary(data, with: "memberStat"))
	}
	
	func getSubjectNum() -> Int {
		return subjectData.count
	}
	func getSubject(atIndex index: Int) -> dictStringAny {
		return subjectData[index]
	}
}

class PretestHistoryListModel: NSObject {
	
	lazy var api = API()
	
	var pretestId: String
	var historyLoading: Dynamic<(finished: Bool, isFirsttime: Bool)>
	var historyList: [PretestHistoryModel]!
	
	init(id: String) {
		historyLoading = Dynamic((false, true))
		pretestId = id
		historyList = []
	}
	
	func loadHistory() {
		api.getPretestHistory(pretestId: pretestId) { (finished, response) in
			self.historyList = []
			if finished {
				for history in Validation.anyIsArrayAny(response!, with: "result") {
					self.historyList.append(PretestHistoryModel(withData: history))
				}
			} else {
			}
			self.historyLoading.value = (finished, false)
			return
		}
	}
	
	func getNumber() -> Int {
		return historyList.count
	}
	func getHistory(atIndex index: Int) -> PretestHistoryModel {
		return historyList[index]
	}
}
