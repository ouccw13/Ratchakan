//
//  ExamStartProtocol.swift
//  ratchakan
//
//  Created by JJsobtid on 9/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class ExamStartProtocol: NSObject, UIPageViewControllerDataSource {

	var totalQuestion: Int!
	var examData: [Question]!
	var parameter: ExamModel!
	var pretest: PretestModel!
	
	init(withData parameter:[String: Any], questions: [dictStringAny]) {
		super.init()
		self.parameter = ExamModel(data: parameter, questionsData: questions)
		examData = self.parameter.questions
        totalQuestion = self.parameter.questionQty < 1 ? examData.count : self.parameter.questionQty
	}
	
	init(withPretest parameter:[String: Any]) {
		super.init()
		pretest = PretestModel(withDictionary: parameter)
		examData = LoadPretest.getPretest(pretest.pretestID)
		totalQuestion = pretest.questionNum
	}
    
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		var index = indexOfViewController(viewController as! ExamQuestionViewController)
		if index == 0 || index == NSNotFound {
			return nil
		}
		index -= 1
		return questionViewController(atIndex: index)
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		var index = indexOfViewController(viewController as! ExamQuestionViewController)
		if index == NSNotFound {
			return nil
		}
		
		index += 1
		if index == totalQuestion {
			return nil
		}
		return questionViewController(atIndex: index)
	}
	
	func indexOfViewController(_ questionView: ExamQuestionViewController) -> Int {
		return questionView.index!
	}
	
	func questionViewController(atIndex index: Int) -> ExamQuestionViewController? {
		if examData.count == 0 || index >= examData.count {
			return nil
		}
		
		let questionViewControllerAtIndex = ExamQuestionViewController()
		questionViewControllerAtIndex.questionData = examData[index]
		return questionViewControllerAtIndex
	}
    
}
