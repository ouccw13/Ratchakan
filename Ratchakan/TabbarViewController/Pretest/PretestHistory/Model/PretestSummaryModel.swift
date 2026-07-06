//
//  PretestSummaryModel.swift
//  ratchakan
//
//  Created by JJsobtid on 12/2/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class PretestSummaryModel: NSObject {
	var averageTime, sd, score, mean, Tscore, max, min, totalScore: Float
	var time: Int
	
	init(withData data: dictStringAny) {
		sd = Validation.anyIsFloat(data, with: "sd")
		score = Validation.anyIsFloat(data, with: "score")
		averageTime = Validation.anyIsFloat(data, with: "averageTime")
		mean = Validation.anyIsFloat(data, with: "mean")
		Tscore = Validation.anyIsFloat(data, with: "TScore")
		time = Validation.anyIsNumber(data, with: "time")
		max = Validation.anyIsFloat(data, with: "max")
		min = Validation.anyIsFloat(data, with: "min")
		totalScore = Validation.anyIsFloat(data, with: "totalScore")
	}
}
