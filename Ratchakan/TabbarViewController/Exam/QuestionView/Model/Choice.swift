//
//  Choice.swift
//  ratchakan
//
//  Created by JJsobtid on 24/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class Choice: NSObject {
	var id: String!
	var order: Int!
	var detail: String!
	var correct: Bool!
	var prefix: String!
	
	init(choiceData: [String: Any]) {
		super.init()
		
		id = Validation.anyIsString(choiceData, with: "id")
		order = Validation.anyIsNumber(choiceData, with: "order")
		prefix = Validation.anyIsString(choiceData, with: "prefix")
		detail = Validation.anyIsString(choiceData, with: "detail")
		correct = Validation.anyIsBool(choiceData, with: "correct")
	}
}
