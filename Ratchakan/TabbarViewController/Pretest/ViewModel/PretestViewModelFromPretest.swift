//
//  PretestViewModelFromPretest.swift
//  ratchakan
//
//  Created by JJsobtid on 17/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import UIKit

class PretestViewModelFromPretest: NSObject, PretestViewModel {
	
	fileprivate let pretest: PretestModel!
	
	var pretestName: String
	var sponsorName: String
	var teacherName: String
	var teacherProfile: String
	var timeLimit: Int
	var totalScore: Float
	var vipPrice: Price
	var regularPrice: Price
	var banner: [String : Any]
	var colorHEX: String
	var dateGroup: [[String : Any]]
	var pretestUpdate: Dynamic<Int>
	var earlyBirdDate: Int
	var limitNumRegis: Int
	var pretestDate: Int
	var pretestID: String
	var questionID: [String]
	var questionNum: Int
	var question: String
	var round: Dynamic<[[String : Any]]>
	var startRegisDate: Int
	var endRegisDate: Int
	var selectedRound: roundSelected
	
	var ownerPretest: Dynamic<Bool>
	var roundPretest: Dynamic<Int?>
	var summitPretest: Dynamic<Bool?>
	
	init(pretest: PretestModel) {
		self.pretest = pretest
		pretestName = pretest.pretestName
		sponsorName = pretest.sponsorName
		teacherName = pretest.teacherName
		teacherProfile = pretest.teacherProfile
		timeLimit = pretest.timeLimit
		totalScore = pretest.totalScore
		vipPrice = pretest.vipPrice
		regularPrice = pretest.regularPrice
		banner = pretest.banner
		colorHEX = pretest.colorHEX
		dateGroup = pretest.dateGroup
		earlyBirdDate = pretest.earlyBirdDate
		limitNumRegis = pretest.limitNumRegis
		pretestDate = pretest.pretestDate
		pretestID = pretest.pretestID
		questionID = pretest.questionID
		questionNum = pretest.questionNum
		question = pretest.question
		startRegisDate = pretest.startRegisDate
		endRegisDate = pretest.endRegisDate
		pretestUpdate = Dynamic(pretest.pretestUpdate.value)
		round = Dynamic(pretest.round.value)
		
		selectedRound = pretest.selectedRound
		
		roundPretest = Dynamic(pretest.roundPretest)
		ownerPretest = Dynamic(pretest.ownerPretest.value)
		summitPretest = Dynamic(pretest.summitPretest.value)
		
		super.init()
		
		pretest.ownerPretest.bindAndFire { (owner) in
			self.ownerPretest.value = owner
		}
		pretest.summitPretest.bindAndFire { (summit) in
			self.summitPretest.value = summit
		}
		
		pretest.pretestUpdate.bindAndFire { (date) in
			self.pretestUpdate.value = date
		}
		pretest.round.bindAndFire { (round) in
			self.round.value = round
		}
		
	}

	func removeListenerPretest() {
		pretest.removeListener()
	}
	
	func connectListenerPretest() {
		pretest.connectListener()
	}
	
	func getPretestData() -> PretestModel{
		return pretest
	}
	func selectRound(dateIndex: Int, round: Int, pretestDate: Int, pretestEndDate: Int, action: Int) {
		pretest.selectedRound.set(round: round, from: pretestDate, toDate: pretestEndDate, dateIndex: dateIndex, action: action)
	}
}

class PromotionViewModelFromPromotion: NSObject, PromotionPretestViewModel {
	
	fileprivate var model: PromotionPretestModel
	
	var promotionID: String
	var promotionName: String
	var promotionUpdate: Dynamic<Int>
	var pretestList: [String]
	var pretestListData: [PretestModel]
	var vipPrice: Price
	var regularPrice: Price
	var banner: [String : Any]
	var colorHEX: String
	var earlyBirdDate: Int
	var endRegisDate: Int
	var startRegisDate: Int
	var pretestLoaded: Dynamic<Bool>
	
	init(promotion: PromotionPretestModel) {
		model = promotion
		
		promotionID = promotion.promotionID
		promotionName = promotion.promotionName
		vipPrice = promotion.vipPrice
		regularPrice = promotion.regularPrice
		banner = promotion.banner
		colorHEX = promotion.colorHEX
		earlyBirdDate = promotion.earlyBirdDate
		startRegisDate = promotion.startRegisDate
		endRegisDate = promotion.endRegisDate
		pretestList = promotion.pretestList
		pretestListData = []
		promotionUpdate = Dynamic(promotion.promotionUpdate)
		pretestLoaded = Dynamic(promotion.pretestLoaded.value)

		super.init()
		
		promotion.pretestLoaded.bindAndFire { (loaded) in
			self.pretestLoaded.value = loaded
			if loaded {
				self.pretestListData = promotion.pretestListData
			}
		}
	}
	
	func getModel() -> PromotionPretestModel {
		return model
	}
}
