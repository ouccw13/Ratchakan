//
//  QuestionViewModel.swift
//  ratchakan
//
//  Created by JJsobtid on 24/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import Foundation

protocol QuestionViewModel {
	var id: String { get }
	var subject: String { get }
	var subjectGroup: String { get }
	var question: String { get }
	var score: Int { get }
	var haveFormula: Bool { get }
	var haveSolution: Bool { get }
	var haveTool: Bool { get }
	var tool: String { get }
	var questionType: QuestionType { get }
	var order: Int { get }
	var choices: [[String:Any]] { get }
	var categories: [String] { get }
}
