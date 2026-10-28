//
//  PretestViewModel.swift
//  ratchakan
//
//  Created by JJsobtid on 17/1/2561 BE.
//  Copyright © 2561 JJsobtid. All rights reserved.
//

import Foundation

protocol PretestViewModel {
	var pretestName: String { get }
	var sponsorName: String { get }
	var teacherName: String { get }
	var teacherProfile: String { get }
	var timeLimit: Int { get }
	var totalScore: Float { get }
	var vipPrice: Price { get }
	var regularPrice: Price { get }
	var banner: [String: Any] { get }
	var colorHEX: String { get }
	var dateGroup: [[String: Any]] { get }
	var pretestUpdate: Dynamic<Int> { get }
	var earlyBirdDate: Int { get }
	var limitNumRegis: Int { get }
	var pretestDate: Int { get }
	var pretestID: String { get }
	var questionID: [String] { get }
	var questionNum: Int { get }
	var question: String { get }
	var round: Dynamic<[[String: Any]]> { get }
	var startRegisDate: Int { get }
	var endRegisDate: Int { get }
	var selectedRound: roundSelected { get }
	//	var subjectGroups: [dictStringAny]
	
	var ownerPretest: Dynamic<Bool> { get }
	var roundPretest: Dynamic<Int?> { get }
	var summitPretest: Dynamic<Bool?> { get }
	
	func removeListenerPretest()
	func connectListenerPretest()
	func getPretestData() -> PretestModel
	func selectRound(dateIndex: Int, round: Int, pretestDate: Int, pretestEndDate: Int, action: Int)
}

protocol PromotionPretestViewModel {
	var promotionID: String { get }
	var promotionName: String { get }
	var vipPrice: Price { get }
	var regularPrice: Price { get }
	var banner: [String: Any] { get }
	var colorHEX: String { get }
	var promotionUpdate: Dynamic<Int> { get }
	var earlyBirdDate: Int  { get }
	var endRegisDate: Int { get }
	var startRegisDate: Int { get }
	var pretestList: [String] { get }
	var pretestListData: [PretestModel] { get }
	var pretestLoaded: Dynamic<Bool> { get }
}
