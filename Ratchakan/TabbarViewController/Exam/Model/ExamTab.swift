//
//  ExamTab.swift
//  ratchakan
//
//  Created by JJsobtid on 16/7/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

enum ExamFilter {
	case total
	case done
	case notDone
}

class ExamTab: NSObject {

	var filterType: ExamFilter
	var examList, examShow: [Exams]

	override init() {
		filterType = .total
		examList = []
		examShow = []
	}
	
	func reloadExam() {
		examList = []
		examShow = []
	}
	
	func addExamList(_ exam: Exams) {
		examList.append(exam)
        if filterType == .done && (exam.isDone != nil) {
			examShow.append(exam)
        } else if filterType == .notDone && not(exam.isDone ?? false) {
			examShow.append(exam)
		}
	}
	
	func setFilter(_ filter: ExamFilter) {
		filterType = filter
		examShow = examList.filter({ exam -> Bool in
			if self.filterType == .done {
                return exam.isDone ?? false
			} else if self.filterType == .notDone {
                return not(exam.isDone ?? false)
			} else {
				return true
			}
		})
	}
	
	func getExamNumber() -> Int {
		if filterType == .total {
			return examList.count
		} else {
			return examShow.count
		}
	}
	
	func getExam(atIndex index: Int) -> Exams {
		if filterType == .total {
			return examList[index]
		} else {
			return examShow[index]
		}
	}
}
